//
//  Oval.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/6/21.
//

import SwiftUI

struct Oval: InsettableShape {
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
    
    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(
            to: CGPoint(
                x: rect.midX + rect.size.width * 0.15,
                y: rect.minY
            )
        )
        // Curve
        path.addCurve(
            to: CGPoint(
                x: rect.midX + rect.size.width * 0.15,
                y: rect.maxY
            ),
            control1: CGPoint(
                x: rect.midX + rect.size.width * 0.15 + rect.size.height,
                y: rect.minY
            ),
            control2: CGPoint(
                x: rect.midX + rect.size.width * 0.15 + rect.size.height,
                y: rect.maxY
            )
        )
        path.addLine(
            to: CGPoint(
                x: rect.midX - rect.size.width * 0.15,
                y: rect.maxY
            )
        )
        // Curve
        path.addCurve(
            to: CGPoint(
                x: rect.midX - rect.size.width * 0.15,
                y: rect.minY
            ),
            control1: CGPoint(
                x: rect.midX - rect.size.width * 0.15 - rect.size.height,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.midX - rect.size.width * 0.15 - rect.size.height,
                y: rect.minY
            )
        )
        path.addLine(
            to: CGPoint(
                x: rect.midX,
                y: rect.minY
            )
        )
        path.closeSubpath()
        
        return path
    }
}

struct Oval_Previews: PreviewProvider {
    static var previews: some View {
        Oval()
            .aspectRatio(11 / 5, contentMode: .fit)
            .frame(width: 200)
    }
}
