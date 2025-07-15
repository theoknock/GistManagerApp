//
//  test.swift
//  GistManagerApp
//
//  Created by Xcode Developer on 7/15/25.
//

import Foundation
import SwiftUI

struct FixedTop_ScrollableBottom: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Fixed Top Half
                VStack {
                    Text("Top, always visible")
                        .font(.title)
                    // ...other misc fixed components here...
                }
                .frame(height: geometry.size.height / 2)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                
                // Scrollable Bottom Half
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(0..<100) { i in
                            Text("Scrollable line \(i)")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: geometry.size.height / 2)
                .background(.background)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    FixedTop_ScrollableBottom()
}
