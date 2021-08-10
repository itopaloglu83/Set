//
//  CardView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/6/21.
//

import SwiftUI

struct CardView: View {
    typealias Card = SetGame.Card
    
    var card: Card
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let cornerRadius = width * Constants.cornerRadiusRatio
            let borderWidth = width * Constants.borderWidthRatio
            let shadowWidth = width * Constants.shadowWidthRatio
            let cardPadding = width * Constants.cardPaddingRatio
            let verticalSpacing = width * Constants.verticalSpacingRatio
            let shapePadding = width * Constants.shapePaddingRatio
            let shapeWidth = width * Constants.shapeWidthRatio
            
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(highlightColor(card.status), lineWidth: borderWidth)
                    .shadow(color: shadowColor(card.status), radius: shadowWidth)
                
                VStack(alignment: .center, spacing: verticalSpacing) {
                    ForEach(0..<card.content.number, id: \.self) { _ in
                        CardShapeView(content: card.content)
                            .padding(shapePadding)
                    }
                }
                .frame(width: shapeWidth)
            }
            .padding(cardPadding)
        }
        .aspectRatio(Constants.cardAspectRatio, contentMode: .fit)
        .contentShape(Rectangle())
    }
    
    private func highlightColor(_ highlight: Card.Status) -> Color {
        switch highlight {
        case .normal:
            return .secondary
        case .selected:
            return .blue
        case .matched:
            return .green
        case .mismatched:
            return .red
        }
    }
    
    private func shadowColor(_ highlight: Card.Status) -> Color {
        switch highlight {
        case .normal:
            return .clear
        case .selected, .matched, .mismatched:
            return highlightColor(highlight)
        }
    }
}

struct CardShapeView: View {
    typealias CardContent = SetGame.CardContent
    
    var content: CardContent
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            switch content.shape {
            case .diamond:
                Diamond()
                    .shading(content.shading, in: size)
            case .squiggle:
                Squiggle()
                    .shading(content.shading, in: size)
            case .oval:
                Oval()
                    .shading(content.shading, in: size)
            }
        }
        .opacity(Constants.shapeOpacity)
        .foregroundColor(content.color)
        .aspectRatio(Constants.shapeAspectRatio, contentMode: .fit)
    }
}

fileprivate extension InsettableShape {
    typealias CardShading = SetGame.CardShading
    
    @ViewBuilder
    func shading(_ shading: CardShading, in size: CGSize) -> some View {
        let lineWidth = size.width * Constants.lineWidthRatio
        switch shading {
        case .solid:
            self.fill()
        case .striped:
            let stripeStroke = lineWidth * Constants.stripeStrokeRatio
            let stripeSpacing = stripeStroke * Constants.stripeSpacingRatio
            ZStack {
                Striped(stripeSpacing: stripeSpacing)
                    .stroke(lineWidth: stripeStroke)
                    .clipShape(self)
                self.stroke(lineWidth: lineWidth)
            }
            .compositingGroup()
        case .open:
            self.strokeBorder(lineWidth: lineWidth)
        }
    }
}

fileprivate struct Constants {
    // Card Constants
    static let cornerRadiusRatio: CGFloat = 1 / 10
    static let borderWidthRatio: CGFloat = 1 / 25
    static let shadowWidthRatio: CGFloat = 1 / 40
    static let cardPaddingRatio: CGFloat = 1 / 50
    static let verticalSpacingRatio: CGFloat = 1 / 18
    static let shapeWidthRatio: CGFloat = 2 / 3
    static let cardBackgroundColor: Color = .secondary
    static let cardAspectRatio: CGFloat = 5 / 7
    // Card Shape Constants
    static let lineWidthRatio: CGFloat = 1 / 20
    static let shapePaddingRatio: CGFloat = 1 / 30
    static let stripeStrokeRatio: CGFloat = 2 / 3
    static let stripeSpacingRatio: CGFloat = 5 / 2
    static let shapeAspectRatio: CGFloat = 11 / 5
    static let shapeOpacity: Double = 1
}

struct CardView_Previews: PreviewProvider {
    static let game = SetGame()
    
    static var previews: some View {
        CardView(card: game.cards.first!)
            .frame(width: 300)
    }
}
