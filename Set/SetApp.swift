//
//  SetApp.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = SetGame()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
