//
//  Striped.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/7/21.
//

import SwiftUI

struct Striped: Shape {
    var stripeSpacing: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if stripeSpacing == 0 {
            return path
        }
        
        for x in stride(from: rect.midX, through: rect.maxX, by: stripeSpacing) {
            let dx = x - rect.midX
            
            path.move(to: CGPoint(x: rect.midX + dx, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + dx, y: rect.maxY))
            path.move(to: CGPoint(x: rect.midX - dx, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX - dx, y: rect.maxY))
        }
        
        return path
    }
}

struct Striped_Previews: PreviewProvider {
    static var previews: some View {
        Striped(stripeSpacing: 9)
            .stroke(lineWidth: 3)
            .aspectRatio(11 / 5, contentMode: .fit)
            .frame(width: 200)
    }
}
