//
//  SoloSetGameView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import SwiftUI

struct SoloSetGameView: View {
    @ObservedObject var game: SoloSetGame
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let width = bestCardWidth(itemCount: game.visibleCards.count,
                                                   in: geometry.size,
                                                   aspectRatio: 3/4)
                
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(game.visibleCards) { card in
                        CardView(card: card)
                            .onTapGesture {
                                game.select(card)
                            }
                    }
                }
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func bestCardWidth(itemCount: Int, in size: CGSize, aspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / aspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        
        if columnCount > itemCount {
            columnCount = itemCount
        }
        
        let bestWidth = floor(size.width / CGFloat(columnCount))
        
        return max(bestWidth, 70)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = SoloSetGame()
//
//        return SoloSetGameView(game: game)
//    }
//}
