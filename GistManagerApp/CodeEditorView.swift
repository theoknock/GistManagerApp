import SwiftUI
import CodeEditor

struct CodeEditorView: View {
    
#if os(macOS)
    @AppStorage("fontsize") var fontSize = Int(NSFont.systemFontSize)
#endif
    @State private var source = "let a = 42"
    @State private var language = CodeEditor.Language.swift
    @State private var theme    = CodeEditor.ThemeName.pojoaque
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, content: {
                HStack {
                    Picker("Language", selection: $language) {
                        ForEach(CodeEditor.availableLanguages) { language in
                            Text("\(language.rawValue.capitalized)")
                                .font(.system(.body))
                                .dynamicTypeSize(.xSmall ... .xxLarge)
                                .tag(language)
                        }
                    }
                }.border(Color.red, width: 1.0)
                HStack {
                    Picker("Theme", selection: $theme) {
                        ForEach(CodeEditor.availableThemes) { theme in
                            Text("\(theme.rawValue.capitalized)")
                                .font(.system(.body))
                                .dynamicTypeSize(.xSmall ... .xxLarge)
                                .tag(theme)
                        }
                    }
                }.border(Color.blue, width: 1.0)
            }).border(Color.blue, width: 1.0)
            
            //            Divider()
            
            HStack {
#if os(macOS)
                CodeEditor(source: $source, language: language, theme: theme,
                           fontSize: .init(get: { CGFloat(fontSize)  },
                                           set: { fontSize = Int($0) }))
                .frame(minWidth: 640, minHeight: 480)
#else
                CodeEditor(source: $source, language: language, theme: theme)
                    .frame(minWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
#endif
            }.border(Color.blue, width: 1.0)
            
        }.border(Color.green, width: 1.0)
        .padding()
    }
}

struct CodeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditorView()
            .preferredColorScheme(.dark)
    }
}
