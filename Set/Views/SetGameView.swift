//
//  SetGameView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/3/21.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGame
    
    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            gameHeader
            gameBody
            gameFooter
        }
        .padding(.horizontal)
    }
    
    private var gameHeader: some View {
        HStack {
            Text("Solo Set Game")
                .bold()
            
            Spacer()
            
            Button(action: {
                    game.newGame()
            }, label: {
                Image(systemName: "plus.circle.fill")
            })
        }
        .font(.largeTitle)
    }
    
    private var gameBody: some View {
        CardVGrid(items: game.cards, aspectRatio: Constants.aspectRatio) { card in
            CardView(card: card)
            .onTapGesture {
                game.select(card)
            }
        }
    }
    
    private var gameFooter: some View {
        HStack {
            Group {
                Button(action: {
                        game.hint()
                }, label: {
                    Text("Hint").bold()
                })
                
                Text("Score: \(game.score)")
                
                Button(action: {
                        game.shuffle()
                }, label: {
                    Text("Shuffle").bold()
                })
            }
            .frame(maxWidth: .infinity)
        }
        .font(.title3)
    }
    
    private struct Constants {
        static let verticalSpacing: CGFloat = 10
        static let aspectRatio: CGFloat = 5/7
        static let cardSpacing: CGFloat = 2
    }
}

struct ContentView_Previews: PreviewProvider {
    static let game = SetGame()
    
    static var previews: some View {
        SetGameView(game: game)
            .preferredColorScheme(.dark)
    }
}
