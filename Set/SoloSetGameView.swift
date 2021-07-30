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
                ForEach(game.availableCards) { card in
                    CardView(card: card, status: game.getStatus(for: card))
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
    let status: SoloSetGame.CardStatus
    
    var body: some View {
        ZStack {
            let roundedShape = RoundedRectangle(cornerRadius: 10)
            
            if status.isHighlighted {
                roundedShape
                    .foregroundColor(status.isSelectionASet ? .green : .red)
            }
            
            roundedShape
                .strokeBorder(lineWidth: 3)
                .foregroundColor(status.isSelected ? .black : .gray)
            
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
