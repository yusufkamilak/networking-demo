//
//  NetworkingDemoApp.swift
//  Shared
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import SwiftUI

@main
struct NetworkingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            HomeContentView(viewModel: HomeViewModel())
        }
    }
}
