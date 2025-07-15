import SwiftData
import SwiftUI
import HighlightSwift

// MARK: - Data Models
@Model
class Gist {
    var id = UUID()
    var title: String
    var gistContent: String
    var programmingLanguage: String
    var hashtags: [String]
    var creationDate: Date
    
    init(
        title: String = "",
        gistContent: String = "",
        programmingLanguage: String = "",
        hashtags: [String] = []
    ) {
        self.title = title
        self.gistContent = gistContent
        self.programmingLanguage = programmingLanguage
        self.hashtags = hashtags
        self.creationDate = Date()
    }
}

// MARK: - Group Types
enum GroupType: Hashable {
    case language(String)
    case hashtag(String)
    case all
    
    var displayName: String {
        switch self {
        case .language(let lang):
            return lang.isEmpty ? "Unknown Language" : lang
        case .hashtag(let tag):
            return "#\(tag)"
        case .all:
            return "All Gists"
        }
    }
    
    var icon: String {
        switch self {
        case .language:
            return "curlybraces"
        case .hashtag:
            return "number"
        case .all:
            return "doc.text"
        }
    }
}

// MARK: - Main App
@main
struct CodeGists: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Gist.self)
    }
}

// MARK: - Content View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var gists: [Gist]
    @State private var selectedGroup: GroupType? = .all
    @State private var selectedGist: Gist?
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    //    var highlight: Highlight = Highlight()
    //
    //    let someCode = """
    //        print(\"Hello World\")
    //        """
    
    var body: some View {
        
        //        CodeText(someCode)
        //            .highlightLanguage(.swift)
        
        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // First Column - Groups
            GroupSidebarView(
                gists: gists,
                selectedGroup: $selectedGroup
            )
        } content: {
            // Second Column - Gist List
            GistListView(
                gists: filteredGists,
                selectedGist: $selectedGist,
                selectedGroup: selectedGroup,
                modelContext: modelContext
            )
        } detail: {
            // Third Column - Gist Detail
            if let selectedGist = selectedGist {
                GistDetailView(gist: selectedGist)
            } else {
                ContentUnavailableView(
                    "Select a Gist",
                    systemImage: "doc.text",
                    description: Text(
                        "Choose a gist from the list to view and edit its details"
                    )
                )
            }
        }
        .onChange(of: selectedGroup) {
            // Clear selected gist when switching groups/smart folders
            selectedGist = nil
        }
    }
    
    private var filteredGists: [Gist] {
        switch selectedGroup {
        case .all:
            return gists
        case .language(let lang):
            return gists.filter {
                $0.programmingLanguage.lowercased() == lang.lowercased()
            }
        case .hashtag(let tag):
            return gists.filter { $0.hashtags.contains(tag) }
        case .none:
            return []
        }
    }
}

// MARK: - Group Sidebar View
struct GroupSidebarView: View {
    let gists: [Gist]
    @Binding var selectedGroup: GroupType?
    
    var body: some View {
        VStack {
            List(selection: $selectedGroup) {
                Section("Smart Folders") {
                    NavigationLink(value: GroupType.all) {
                        Label("All Gists", systemImage: "doc.text")
                    }
                    
                    ForEach(uniqueLanguages, id: \.self) { language in
                        NavigationLink(value: GroupType.language(language)) {
                            Label(
                                language.isEmpty
                                ? "Unknown Language" : language,
                                systemImage: "curlybraces"
                            )
                        }
                    }
                }
                
                if !uniqueHashtags.isEmpty {
                    Section("Hashtags") {
                        ForEach(uniqueHashtags, id: \.self) { hashtag in
                            NavigationLink(value: GroupType.hashtag(hashtag)) {
                                Label("#\(hashtag)", systemImage: "number")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Code Gists")
            
            // Attribution at bottom
            VStack(spacing: 2) {
                Text("James Alan Bush")
                    .font(.caption)
                    .foregroundColor(.primary)
                Text("Commit ID 64fb891")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
        }
    }
    
    private var uniqueLanguages: [String] {
        Array(Set(gists.map { $0.programmingLanguage })).sorted()
    }
    
    private var uniqueHashtags: [String] {
        Array(Set(gists.flatMap { $0.hashtags })).sorted()
    }
}

// MARK: - Gist List View
struct GistListView: View {
    let gists: [Gist]
    @Binding var selectedGist: Gist?
    let selectedGroup: GroupType?
    let modelContext: ModelContext
    
    var body: some View {
        List(selection: $selectedGist) {
            ForEach(gists) { gist in
                NavigationLink(value: gist) {
                    GistRowView(gist: gist)
                }
            }
            .onDelete(perform: deleteGists)
        }
        .navigationTitle(selectedGroup?.displayName ?? "Gists")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addGist) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func addGist() {
        let newGist = Gist(title: "")
        modelContext.insert(newGist)
        
        // Auto-save first
        do {
            try modelContext.save()
        } catch {
            print("Failed to save new gist: \(error)")
        }
        
        // Delay selection to allow SwiftData to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            selectedGist = newGist
        }
    }
    
    private func deleteGists(offsets: IndexSet) {
        for index in offsets {
            let gist = gists[index]
            if selectedGist == gist {
                selectedGist = nil
            }
            modelContext.delete(gist)
        }
        
        // Auto-save
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete gists: \(error)")
        }
    }
}

// MARK: - Gist Row View
struct GistRowView: View {
    let gist: Gist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(gist.title.isEmpty ? "Untitled Gist" : gist.title)
                .font(.headline)
                .lineLimit(1)
            
            HStack {
                if !gist.programmingLanguage.isEmpty {
                    Text(gist.programmingLanguage)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Spacer()
                
//                Text(gist.creationDate, style: .date)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
            }
            
            if !gist.hashtags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(gist.hashtags, id: \.self) { hashtag in
                            Text("#\(hashtag)")
                                .font(.caption)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Gist Detail View
struct GistDetailView: View {
    @Bindable var gist: Gist
    @Environment(\.modelContext) private var modelContext
    @State private var hashtagInput = ""
    @FocusState private var isHashtagFieldFocused: Bool
    
    @FocusState private var isEditorFocused: Bool
    
    var highlight: Highlight = Highlight()
    
    // Programming languages for dropdown
    private let programmingLanguages = [
        "Swift", "Objective-C", "JavaScript", "TypeScript", "Python", "Java",
        "C++", "C#", "Go", "Rust",
        "Ruby", "PHP", "Kotlin", "Dart", "Scala", "Clojure", "Haskell",
        "Elixir", "Erlang", "F#",
        "HTML", "CSS", "SQL", "Shell", "Bash", "PowerShell", "R", "MATLAB",
        "Perl", "Lua",
        "Assembly", "VHDL", "Verilog", "Fortran", "COBOL", "Pascal", "Delphi",
        "Visual Basic",
        "ActionScript", "CoffeeScript", "Elm", "PureScript", "ReasonML",
        "OCaml", "Scheme", "Racket",
    ].sorted()
    
    var body: some View {
        Form {
            Section("") {
                TextField("Untitled Gist", text: $gist.title)
                    .font(.title2)
                
//                Picker(
//                    "Programming Language",
//                    selection: $gist.programmingLanguage
//                ) {
//                    Text("Select Language").tag("")
//                    ForEach(programmingLanguages, id: \.self) { language in
//                        Text(language).tag(language)
//                    }
//                }
                
//                HStack {
//                    Text("Created:")
//                    Spacer()
//                    Text(gist.creationDate, style: .date)
//                        .foregroundColor(.secondary)
//                }
            }
            
            Section("Hashtags") {
                if !gist.hashtags.isEmpty {
                    LazyVGrid  (
                        columns: [
                            GridItem(.adaptive(minimum: 80))
                        ],
                        spacing: 8
                    ) {
                        ForEach(gist.hashtags, id: \.self) { hashtag in
                            HStack {
                                Text("#\(hashtag)")
                                    .font(.caption)
                                Button(action: {
                                    removeHashtag(hashtag)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                }
                
                HStack {
                    TextField("Add hashtag", text: $hashtagInput)
                        .focused($isHashtagFieldFocused)
                        .onSubmit {
                            addHashtag()
                        }
                    
                    Button("Add", action: addHashtag)
                        .disabled(
                            hashtagInput.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty
                        )
                }
            }
        }
        .scrollDisabled(true)
        
        Section("") {
            GeometryReader { geometry in
                VStack {
                    CodeEditorViewRE()
                }
            }
        }
    }
    
    private func addHashtag() {
        let trimmedTag = hashtagInput.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !trimmedTag.isEmpty && !gist.hashtags.contains(trimmedTag) else {
            return
        }
        
        gist.hashtags.append(trimmedTag)
        hashtagInput = ""
        isHashtagFieldFocused = false
        autoSave()
    }
    
    private func removeHashtag(_ hashtag: String) {
        gist.hashtags.removeAll { $0 == hashtag }
        autoSave()
    }
    
    private func autoSave() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to auto-save: \(error)")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .modelContainer(for: Gist.self, inMemory: true)
        .preferredColorScheme(.dark)
    
}
