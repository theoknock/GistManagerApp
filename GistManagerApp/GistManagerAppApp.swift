//
//  GistManagerAppApp.swift
//  GistManagerApp
//
//  Created by Xcode Developer on 6/11/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct GistManagerAppApp: App {
    var body: some Scene {
        DocumentGroup(editing: .itemDocument, migrationPlan: GistManagerAppMigrationPlan.self) {
            ContentView()
        }
    }
}

extension UTType {
    static var itemDocument: UTType {
        UTType(importedAs: "com.example.item-document")
    }
}

struct GistManagerAppMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
        GistManagerAppVersionedSchema.self,
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
    ]
}

struct GistManagerAppVersionedSchema: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] = [
        Item.self,
    ]
}
