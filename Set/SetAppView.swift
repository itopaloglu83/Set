//
//  SetAppView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/30/21.
//

import SwiftUI

struct SetAppView: View {
    @ObservedObject var game: SoloSetGame
    
    var body: some View {
        VStack {
            Text("Solo Set Game")
                .font(.largeTitle)
                .bold()
                .onTapGesture {
                    game.shuffle()
                }
            
            SoloSetGameView(game: game)
                .padding(.horizontal)
            
            HStack {
                menuButton(title: "New Game") {
                    game.newGame()
                }
                
                Text("Score: \(game.score)")
                    .font(.headline)
                    .padding()
                
                menuButton(title: "Deal Cards") {
                    game.deal()
                }
                .disabled(game.deck.isEmpty)
            }
        }
    }
    
    private func menuButton(title: String, closure: @escaping ()-> Void) -> some View {
        Button {
            closure()
        } label: {
            Text(title)
                .font(.headline)
        }
        .padding(.horizontal)
    }
}

struct SetAppView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SoloSetGame()
        
        return SetAppView(game: game)
    }
}
