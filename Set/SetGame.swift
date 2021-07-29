//
//  SetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import Foundation

struct SetGame {
    private(set) var cards: Array<Card>
    
    init() {
        cards = []
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        cards.append(Card(number, shape, shading, color))
                    }
                }
            }
        }
        // cards.shuffle()
        cards.indices.prefix(12).forEach({ cards[$0].isDealt = true })
    }
    
    var deck: Array<Card> {
        cards.filter({ !$0.isDealt })
    }
    
    var dealt: Array<Card> {
        cards.filter({ $0.isDealt && !$0.isRemoved })
    }
    
    mutating func dealThreeMoreCards() {
        cards.indices.filter({ !cards[$0].isDealt }).prefix(3).forEach({ cards[$0].isDealt = true })
    }
    
    private var currentlySelectedCards: Array<Card> {
        cards.filter({ $0.isSelected })
    }
    
    private var currentlySelectedIndices: [Array<Card>.Index] {
        cards.indices.filter({ cards[$0].isSelected })
    }
    
    private func isSelectionASet(_ selectedCards: Array<Card>) -> Bool {
        // Selection must contain three cards.
        guard selectedCards.count == 3 else { return false }
        
        // All properties must be either all the same or all different.
        // Having a collection with two unique members means the selection cannot be a Set.
        if Set<Card.Number>(selectedCards.map({ $0.number })).count == 2 { return false }
        if Set<Card.Shape>(selectedCards.map({ $0.shape })).count == 2 { return false }
        if Set<Card.Shading>(selectedCards.map({ $0.shading })).count == 2 { return false }
        if Set<Card.Color>(selectedCards.map({ $0.color })).count == 2 { return false }
        
        // Selection is a Set if the program flow can reach here.
        return true
    }
    
    mutating func choose(_ card: Card) {
        // Only dealt cards can be chosen.
        guard dealt.contains(card) else { return }
        // Chosen card must be present in the cards array.
        guard let chosenIndex = cards.firstIndex(of: card) else { return }
        
        // If the card is already selected and there are less than three cards selected
        // then allow the user to deselect the card and return.
        if cards[chosenIndex].isSelected && currentlySelectedCards.count < 3 {
            cards[chosenIndex].isSelected = false
            return
        }
        
        // Are there already three cards selected?
        if currentlySelectedCards.count < 3 {
            // Mark the card as selected.
            cards[chosenIndex].isSelected = true
            
            // If the selected card did not increase the count to three then return.
            if currentlySelectedCards.count < 3 {
                return
            }
            
            // Mark cards as either matched or mismatched.
            if isSelectionASet(currentlySelectedCards) {
                currentlySelectedIndices.forEach({ cards[$0].isMatched = true })
            } else {
                currentlySelectedIndices.forEach({ cards[$0].isMismatched = true })
            }
        } else {
            // There are already three cards selected. Check if they are a Set.
            if isSelectionASet(currentlySelectedCards) {
                // Remove the matched cards from the game.
                currentlySelectedIndices.forEach({ cards[$0].isRemoved = true })
                
                // Deal three More Cards
                dealThreeMoreCards()
                
                // Deselect all currently selected cards.
                currentlySelectedIndices.forEach({ cards[$0].isSelected = false })
                
                // Select the card if it is not matched or removed.
                if !cards[chosenIndex].isMatched || !cards[chosenIndex].isRemoved {
                    cards[chosenIndex].isSelected = true
                }
            } else {
                // Remove the mismatch markings.
                currentlySelectedIndices.forEach({ cards[$0].isMismatched = false })
                
                // Deselect all currently selected cards.
                currentlySelectedIndices.forEach({ cards[$0].isSelected = false })
                
                // Select the card.
                cards[chosenIndex].isSelected = true
            }
        }
    }
    
    struct Card: Identifiable, Equatable {
        let id = UUID()
        
        var isDealt = false
        var isSelected = false
        var isMatched = false
        var isMismatched = false
        var isRemoved = false
        
        let number: Number
        let shape: Shape
        let shading: Shading
        let color: Color
        
        init(_ number: Number, _ shape: Shape, _ shading: Shading, _ color: Color) {
            self.number = number
            self.shape = shape
            self.shading = shading
            self.color = color
        }
        
        var description: String {
            "\(number):\(shape):\(shading):\(color)"
        }
        
        // Number, Shape, Shading, Color
        enum Number: CaseIterable {
            case one, two, three
        }
        
        enum Shape: CaseIterable {
            case diamond, squiggle, oval
        }
        
        enum Shading: CaseIterable {
            case solid, striped, open
        }
        
        enum Color: CaseIterable {
            case red, green, purple
        }
    }
}
