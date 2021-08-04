//
//  Diamond.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/31/21.
//

import SwiftUI

struct Diamond: Shape, InsettableShape {
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var diamond = self
        diamond.insetAmount += amount
        return diamond
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        
        // Rectangle().path(in: rect)
        return path
    }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
            .aspectRatio(2, contentMode: .fit)
    }
}
