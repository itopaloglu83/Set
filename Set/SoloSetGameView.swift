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
        VStack {
            Button("Deal Cards: \(game.deck.count)", action: { game.dealCards() })
                .font(.largeTitle)
                .disabled(game.deck.isEmpty)
            
            ScrollView {
                ForEach(game.visibleCards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            game.select(card)
                        }
                }
            }
        }
    }
}

struct CardView: View {
    let card: SoloSetGame.Card
    
    var body: some View {
        ZStack {
            let roundedShape = RoundedRectangle(cornerRadius: 10)
            
            if card.isMatched || card.isMismatched {
                roundedShape
                    .foregroundColor(card.isMatched ? .green : .red)
            }
            
            roundedShape
                .strokeBorder(lineWidth: 3)
                .foregroundColor(card.isSelected ? .black : .gray)
            
            Text(card.description)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SoloSetGameView()
    }
}
