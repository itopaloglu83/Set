//
//  ContentView.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/3/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SoloSetGame
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Solo Set Game")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button(action: { game.newGame() }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                })
            }
            
            AspectVGrid(items: game.visibleCards, spacing: 2, aspectRatio: 5/7, minCardWidth: 70) { card in
                CardView(card: card)
                    .onTapGesture {
                        game.select(card)
                    }
            }
            
            HStack {
                Group {
                    Button(action: { game.deal() }, label: { Text("Deal") })
                    
                    Text("Score: \(game.score)")
                    
                    Button(action: { game.shuffle() }, label: { Text("Shuffle") })
                }
                .font(.title3)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SoloSetGame()
        ContentView(game: game)
    }
}

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var spacing: CGFloat
    var aspectRatio: CGFloat
    var minCardWidth: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], spacing: CGFloat, aspectRatio: CGFloat, minCardWidth: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView ) {
        self.items = items
        self.spacing = spacing
        self.aspectRatio = aspectRatio
        self.minCardWidth = minCardWidth
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                let cardWidth = bestCardWidth(
                    itemCount: items.count,
                    in: geometry.size,
                    aspectRatio: aspectRatio,
                    minCardWidth: minCardWidth
                )
                
                LazyVGrid(columns: [adaptiveGridItem(width: cardWidth)], spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .padding(spacing)
                            .aspectRatio(aspectRatio, contentMode: .fit)
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
    
    private func bestCardWidth(itemCount: Int, in size: CGSize, aspectRatio: CGFloat, minCardWidth: CGFloat) -> CGFloat {
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
        
        let optimumWidth = floor(size.width / CGFloat(columnCount))
        
        return max(minCardWidth, optimumWidth)
    }
}
