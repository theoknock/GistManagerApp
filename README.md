Gists App

A simple, intuitive macOS/iOS application for managing your GitHub Gists. Create, edit, search, and organize your code snippets and notes directly from your desktop or mobile device.

Features
	•	Create & Edit Gists: Write new gists or update existing ones with syntax highlighting for multiple languages.
	•	Search & Filter: Quickly find your snippets by title, description, or content.
	•	Organize with Tags: Assign custom tags to your gists for easy categorization and retrieval.
	•	Offline Support: View and edit drafts even without an internet connection; sync when you’re back online.
	•	Dark & Light Mode: Seamless UI adapts to your system appearance.
	•	Cross-Platform: Universal support for macOS and iOS (iPhone & iPad).

Installation
	1.	Clone the repository:

git clone https://github.com/your-username/gists-app.git
cd gists-app


	2.	Install dependencies using CocoaPods or Swift Package Manager:
	•	CocoaPods:

pod install
open GistsApp.xcworkspace


	•	Swift Package Manager (built into Xcode):
	1.	Open GistsApp.xcodeproj in Xcode.
	2.	Let Xcode resolve and fetch packages.

	3.	Build and run:
	•	Select your target (macOS or iOS simulator/device).
	•	Hit ⌘R to build and run the app.

Usage
	1.	Authentication: On first launch, you’ll be prompted to sign in with your GitHub account via OAuth.
	2.	Creating a Gist:
	•	Click the + button (macOS) or tap New Gist (iOS).
	•	Enter a filename, content, and optional description.
	•	Choose Public or Secret, then Save.
	3.	Editing a Gist:
	•	Select a gist from your list.
	•	Make changes and tap Update.
	4.	Search & Filter:
	•	Use the search bar to find gists by keyword.
	•	Apply tags to filter results.

Configuration
	•	API Token: If you prefer personal tokens over OAuth, set an environment variable:

export GISTS_APP_TOKEN=your_github_personal_token


	•	Theme: Override system appearance in Settings > Appearance.

Project Structure

GistsApp/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Views/
│   ├── GistListView.swift
│   ├── GistDetailView.swift
│   └── EditorView.swift
├── Models/
│   └── Gist.swift
├── Services/
│   ├── GitHubAPI.swift
│   └── AuthManager.swift
├── Resources/
│   ├── Assets.xcassets
│   └── LaunchScreen.storyboard
└── README.md

Contributing

Contributions, issues, and feature requests are welcome!
	1.	Fork the repository.
	2.	Create a new branch: git checkout -b feature/YourFeature.
	3.	Commit your changes: git commit -m 'Add some feature'.
	4.	Push to the branch: git push origin feature/YourFeature.
	5.	Open a Pull Request.

License

This project is licensed under the MIT License. See the LICENSE file for details.

⸻

Built with ❤️ by James
