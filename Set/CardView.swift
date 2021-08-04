//
//  CardView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/30/21.
//

import SwiftUI

struct CardView: View {
    typealias Card = SoloSetGame.Card
    
    let card: Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let roundedShape = RoundedRectangle(cornerRadius: 10)
                
                if let highlight = card.highlight {
                    switch highlight {
                    case .selected:
                        roundedShape
                            .strokeBorder(lineWidth: 5)
                            .foregroundColor(.black)
                    case .matched:
                        roundedShape
                            .strokeBorder(lineWidth: 5)
                            .foregroundColor(.blue)
                    case .mismatched:
                        roundedShape
                            .strokeBorder(lineWidth: 5)
                            .foregroundColor(.red)
                    }
                } else {
                    roundedShape
                        .strokeBorder(lineWidth: 4)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    ForEach(0..<card.featureOne, id: \.self) { _ in
                        CardShapeView(shape: card.featureTwo, shading: card.featureThree, color: card.featureFour)
                    }
                }
                .padding()
            }
            .contentShape(Rectangle())
        }
        .padding(1)
        .aspectRatio(3/4, contentMode: .fit)
    }
    
    // TODO: Create a CardShape struct.
    
    private struct CardShape: InsettableShape {
        let shape: SoloSetGame.Shape
        
        var insetAmount: CGFloat = 0
        
        func inset(by amount: CGFloat) -> some InsettableShape {
            var diamond = self
            diamond.insetAmount += amount
            return diamond
        }
        
        func path(in rect: CGRect) -> Path {
            var path: Path
            
            switch shape {
            case .diamond:
                path = Diamond().path(in: rect)
            case .squiggle:
                path = Rectangle().path(in: rect)
            case .oval:
                path = Ellipse().path(in: rect)
            }
            
            return path
        }
    }
    
    // Number, Shape, Shading, Color
    private struct CardShapeView: View {
        let shape: SoloSetGame.Shape
        let shading: SoloSetGame.Shading
        let color: Color
        
        var body: some View {
            CardShape(shape: shape)
                .cardStyle(for: shading)
                .aspectRatio(9/4, contentMode: .fit)
                .foregroundColor(color)
        }
        
        @ViewBuilder
        var shapeView: some View {
            switch shape {
            case .diamond:
                Diamond().cardStyle(for: shading)
            case .squiggle:
                Rectangle().cardStyle(for: shading)
            case .oval:
                Ellipse().cardStyle(for: shading)
            }
        }
    }
}

private extension InsettableShape {
    @ViewBuilder
    func cardStyle(for shading: SoloSetGame.Shading) -> some View {
        switch shading {
        case .solid:
            self.fill()
        case .striped:
            ZStack {
                self.fill().opacity(0.4)
                self.strokeBorder(lineWidth: 4)
            }
        case .open:
            self.strokeBorder(lineWidth: 4)
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = SoloSetGame()
//
//        return CardView(card: game.visibleCards.first!)
//    }
//}
