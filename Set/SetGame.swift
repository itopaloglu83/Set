//
//  SetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import Foundation

struct SetGame {
    private(set) var deck: Array<Card>
    private(set) var availableCards: Array<Card>
    private(set) var removedCards: Array<Card>
    
    private(set) var selectedCards: Array<Card>
    
    init() {
        deck = []
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        deck.append(Card(number, shape, shading, color))
                    }
                }
            }
        }
        availableCards = []
        removedCards = []
        selectedCards = []
        
//        dealCards()
    }
    
    private mutating func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let card = deck.popLast() {
                availableCards.append(card)
            }
        }
    }
    
    mutating func dealCards() {
        dealCards(3)
//        if !deck.isEmpty {
//            if availableCards.isEmpty {
//                dealCards(6)
//            } else {
//                dealCards(3)
//            }
//        }
    }
    
    private mutating func replaceSelectedCards() {
        for card in selectedCards {
            if let newCard = deck.popLast() {
                availableCards[availableCards.firstIndex(of: card)!] = newCard
            } else {
                availableCards.removeAll(where: { $0.id == card.id })
            }
            removedCards.append(card)
        }
        selectedCards.removeAll()
    }
    
    var areThreeCardsSelected: Bool {
        selectedCards.count == 3
    }
    
    func isCardSelected(_ card: Card) -> Bool {
        selectedCards.contains(card)
    }
    
    var isSelectionASet: Bool {
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
    
    mutating func select(_ card: Card) {
        // Only dealt cards can be selected.
        guard availableCards.contains(card) else { return }
        
        // If the card is already selected and there are less than three cards selected
        // then allow the user to deselect the card and return.
        if selectedCards.contains(card) && selectedCards.count < 3 {
            selectedCards.removeAll(where: { $0.id == card.id })
            return
        }
        
        if selectedCards.count < 3 {
            selectedCards.append(card)
        } else {
            if isSelectionASet {
                // Replace matched cards and deal new ones.
                replaceSelectedCards()
                
                // Select the card if it's still available.
                if availableCards.contains(card) {
                    selectedCards.append(card)
                }
            } else {
                // Deselect all currently selected cards.
                selectedCards.removeAll()
                selectedCards.append(card)
            }
        }
    }
    
    struct Card: Identifiable, Equatable {
        let id = UUID()
        
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
