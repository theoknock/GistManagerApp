import SwiftUI
import CodeEditor

struct CodeEditorViewRE: View {
    
#if os(macOS)
    @AppStorage("fontsize") var fontSize = Int(NSFont.systemFontSize)
#endif
    @State private var source = """
    import SwiftUI
    import CodeEditor

    struct CodeEditorViewRE: View {
        
    #if os(macOS)
        @AppStorage("fontsize") var fontSize = Int(NSFont.systemFontSize)
    #endif
        @State private var source = "let a = 42"
        @State private var language = CodeEditor.Language.swift
        @State private var theme    = CodeEditor.ThemeName.pojoaque
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Picker("", selection: $language) {
                        ForEach(CodeEditor.availableLanguages) { language in
                                                            .tag(language)
                        }
                    }
                    Picker("", selection: $theme) {
                        ForEach(CodeEditor.availableThemes) { theme in
                                .tag(theme)
                        }
                    }
                }
                .padding()
                
                Divider()
                
    #if os(macOS)
                CodeEditor(source: $source, language: language, theme: theme,
                           fontSize: .init(get: { CGFloat(fontSize)  },
                                           set: { fontSize = Int($0) }))
                .frame(minWidth: 640, minHeight: 480)
    #else
                CodeEditor(source: $source, language: language, theme: theme)
    #endif
            }
        }
    }

    struct CodeEditorViewRE_Previews: PreviewProvider {
        static var previews: some View {
            CodeEditorViewRE()
                .preferredColorScheme(.dark)
        }
    }

"""
    @State private var language = CodeEditor.Language.swift
    @State private var theme    = CodeEditor.ThemeName.pojoaque
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("", selection: $language) {
                    ForEach(CodeEditor.availableLanguages) { language in
                        Text("\(language.rawValue.capitalized)")
                            .tag(language)
                    }
                }
                Picker("", selection: $theme) {
                    ForEach(CodeEditor.availableThemes) { theme in
                        Text("\(theme.rawValue.capitalized)")
                            .tag(theme)
                    }
                }
            }
            .padding()
            
            Divider()
            
#if os(macOS)
            CodeEditor(source: $source, language: language, theme: theme,
                       fontSize: .init(get: { CGFloat(fontSize)  },
                                       set: { fontSize = Int($0) }))
            .frame(minWidth: 640, minHeight: 480)
#else
            CodeEditor(source: $source, language: language, theme: theme)
#endif
        }
    }
}

struct CodeEditorViewRE_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditorViewRE()
            .preferredColorScheme(.dark)
    }
}
