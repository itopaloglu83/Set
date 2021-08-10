//
//  Squiggle.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/6/21.
//

import SwiftUI

struct Squiggle: InsettableShape {
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
    
    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(
            to: CGPoint(
                x: rect.minX + rect.size.width * 0.70,
                y: rect.minY + rect.size.height * 0.20
            ),
            control1: CGPoint(
                x: rect.minX + rect.size.width * 0.05,
                y: rect.minY - rect.size.height * 0.40
            ),
            control2: CGPoint(
                x: rect.midX,
                y: rect.minY + rect.size.height * 0.20
            )
        )
        path.addCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.midY
            ),
            control1: CGPoint(
                x: rect.minX + rect.size.width * 0.95,
                y: rect.minY + rect.size.height * 0.20
            ),
            control2: CGPoint(
                x: rect.maxX,
                y: rect.minY - rect.size.height * 0.40
            )
        )
        path.addCurve(
            to: CGPoint(
                x: rect.minX + rect.size.width * 0.30,
                y: rect.minY + rect.size.height * 0.80
            ),
            control1: CGPoint(
                x: rect.minX + rect.size.width * 0.95,
                y: rect.maxY + rect.size.height * 0.40
            ),
            control2: CGPoint(
                x: rect.midX,
                y: rect.minY + rect.size.height * 0.80
            )
        )
        path.addCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            ),
            control1: CGPoint(
                x: rect.minX + rect.size.width * 0.05,
                y: rect.minY + rect.size.height * 0.80
            ),
            control2: CGPoint(
                x: rect.minX,
                y: rect.maxY + rect.size.height * 0.40
            )
        )
        path.closeSubpath()
        
        return path
    }
}

struct Squiggle_Previews: PreviewProvider {
    static var previews: some View {
        Squiggle()
            .aspectRatio(11 / 5, contentMode: .fit)
            .frame(width: 200)
    }
}
