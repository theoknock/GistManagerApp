import SwiftUI

struct GistDetailView_: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 1. Basic Information Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("New Gist")
                        .font(.title)
                        .bold()
                    HStack {
                        Text("Programming Language")
                        Spacer()
                        Text("Select Language ⌄")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Created:")
                        Spacer()
                        Text("June 13, 2025")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Color(UIColor.secondarySystemBackground))

                // 2. Hashtags Section
                HStack {
                    Text("Add hashtag")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Add")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))

                // 3. Code Section — takes remaining space
                VStack {
                    HStack {
                        Text("Language")
                        Spacer()
                        Text("Swift ⌄")
                        Text("Theme")
                        Spacer()
                        Text("Pojoaque")
                    }
                    .padding(.bottom)

                    Spacer() // Placeholder for code editor content
                }
                .padding()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .background(Color(UIColor.tertiarySystemBackground))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CodeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditorView()
            .preferredColorScheme(.dark)
    }
}
