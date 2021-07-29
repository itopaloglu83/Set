//
//  SoloSetGameView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import SwiftUI

struct SoloSetGameView: View {
    @ObservedObject var game = SoloSetGame()
    
    var body: some View {
        ScrollView {
            ForEach(game.dealt) { card in
                CardView(card: card)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        }
    }
}

struct CardView: View {
    let card: SoloSetGame.Card
    
    var body: some View {
        Text(card.description)
            .padding()
            .font(card.isSelected ? .headline : .body)
            .foregroundColor(card.isMatched ? .red : .primary)
            .border(Color.purple, width: card.isMismatched ? 1 : 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SoloSetGameView()
    }
}
