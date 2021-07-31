//
//  CardView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/30/21.
//

import SwiftUI

struct CardView: View {
    let card: SoloSetGame.Card
    
    var body: some View {
        ZStack {
            let roundedShape = RoundedRectangle(cornerRadius: 10)
            
//            if card.isMatched || card.isMismatched {
//                roundedShape
//                    .foregroundColor(card.isMatched ? .green : .red)
//            }
            
            roundedShape
                .strokeBorder(lineWidth: 3)
                .foregroundColor(card.isSelected ? .black : .gray)
            
            if !card.isMatched && !card.isMismatched {
                Text(card.description)
            }
            
            if card.isMismatched {
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .background(Color.white)
                    .padding()
            }
            
            if card.isMatched {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .background(Color.white)
                    .padding()
            }
            
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SoloSetGame()
        
        return CardView(card: game.visibleCards.first!)
    }
}
