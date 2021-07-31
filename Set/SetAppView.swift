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
            
            SoloSetGameView(game: game)
                .padding(.horizontal)
            
            HStack {
                newGameButton
                dealCardsButton
            }
        }
    }
    
    private var newGameButton: some View {
        Button(action: {
            game.newGame()
        }, label: {
            Text("New Game")
                .font(.title)
        })
        .padding(.horizontal)
    }
    
    private var dealCardsButton: some View {
        Button(action: {
            game.dealCards()
        }, label: {
            Text("Deal Cards")
                .font(.title)
        })
        .padding(.horizontal)
        .disabled(game.deck.isEmpty)
    }
}

struct SetAppView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SoloSetGame()
        
        return SetAppView(game: game)
    }
}
