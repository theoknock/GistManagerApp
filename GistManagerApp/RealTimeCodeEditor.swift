import SwiftUI
import HighlightSwift

struct RealTimeCodeEditor: View {
    @State private var attributedText = AttributedString("")
    @State private var lastProcessedText = ""
    @State private var isProcessing = false
    @State private var debounceTask: Task<Void, Never>?
    
    private let highlight = Highlight()
    
    var body: some View {
        TextEditor(text: $attributedText)
            .font(.system(.body, design: .monospaced))
            .onChange(of: attributedText) { oldValue, newValue in
                let currentText = String(newValue.characters)
                
                // Only process if text content actually changed and we're not already processing
                if currentText != lastProcessedText && !isProcessing {
                    debounceTask?.cancel()
                    debounceTask = Task {
                        try? await Task.sleep(nanoseconds: 500_000_000) // 500ms debounce
                        await processTextForSyntaxHighlighting(currentText)
                    }
                }
            }
    }
    
    @MainActor
    func processTextForSyntaxHighlighting(_ text: String) async {
        guard !isProcessing else { return }
        guard text != lastProcessedText else { return }
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            lastProcessedText = ""
            return
        }
        
        isProcessing = true
        lastProcessedText = text
        
        do {
            // Use the Highlight class directly as shown in documentation
            let newAttributedText = try await highlight.attributedText(text)
            attributedText = newAttributedText
        } catch {
            print("Syntax highlighting failed: \(error)")
            attributedText = AttributedString(text)
        }
        
        isProcessing = false
    }
}
