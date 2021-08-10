//
//  Diamond.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/6/21.
//

import SwiftUI

struct Diamond: InsettableShape {
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
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        
        return path
    }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
            .aspectRatio(11 / 5, contentMode: .fit)
            .frame(width: 200)
    }
}
