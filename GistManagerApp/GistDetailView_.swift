import SwiftUI

struct GistDetailView_: View {
    @State private var codeText: String = "// Enter your code here"
    @FocusState private var isCodeEditorFocused: Bool
    @State private var keyboardHeight: CGFloat = 0

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
                ScrollView {
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

                        TextEditor(text: $codeText)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.clear)
                            .cornerRadius(8)
                            .focused($isCodeEditorFocused)

                        Spacer(minLength: 20)

                        if isCodeEditorFocused {
                            Button("Dismiss Keyboard") {
                                isCodeEditorFocused = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                        }

                        Spacer(minLength: 300) // Push content above keyboard
                    }
                    .padding()
                    .padding(.bottom, keyboardHeight)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .background(Color(UIColor.tertiarySystemBackground))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isCodeEditorFocused = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
            .onAppear {
                startObservingKeyboard()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private func startObservingKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation {
                keyboardHeight = 0
            }
        }
    }
}

struct GistDetailView__Previews: PreviewProvider {
    static var previews: some View {
        GistDetailView_()
            .preferredColorScheme(.dark)
    }
}
