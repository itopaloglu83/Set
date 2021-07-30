//
//  SetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import Foundation

struct SetGame {
    private(set) var cards: Array<Card>
    
    private var availableCardsIndices: [Array<Card>.Index] {
        didSet{
            availableCardsIndices.forEach({ cards[$0].isDealt = true })
        }
    }
    
    private var selectedCardsIndices: [Array<Card>.Index] {
        didSet{
            cards.indices.forEach({ cards[$0].isSelected = selectedCardsIndices.contains($0) })
            if selectedCardsIndices.count == 3 {
                if isSelectionASet {
                    selectedCardsIndices.forEach({ cards[$0].isMatched = true })
                } else {
                    selectedCardsIndices.forEach({ cards[$0].isMismatched = true })
                }
            } else {
                availableCardsIndices.forEach { index in
                    cards[index].isMatched = false
                    cards[index].isMismatched = false
                }
            }
        }
    }
    
    var deck: Array<Card> {
        cards.filter({ !$0.isDealt })
    }
    
    var availableCards: Array<Card> {
        availableCardsIndices.map({ cards[$0] })
    }
    
    var selectedCards: Array<Card> {
        selectedCardsIndices.map({ cards[$0] })
    }
    
    init() {
        cards = []
        availableCardsIndices = []
        selectedCardsIndices = []
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        cards.append(Card(number, shape, shading, color))
                    }
                }
            }
        }
        
        // Initial card deal.
        dealCards()
    }
    
    // Deal 12 cards to start the game.
    // Deal 3 cards on all subsequent calls.
    mutating func dealCards() {
        if availableCardsIndices.isEmpty {
            dealCards(12)
        } else {
            dealCards(3)
        }
    }
    
    // Try removing a card from the deck if there are any,
    // and add it to the availableCards.
    private mutating func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let index = cards.firstIndex(where: { !$0.isDealt }) {
                availableCardsIndices.append(index)
            }
        }
    }
    
    // Checks if the selectedCards forms a Set.
    private var isSelectionASet: Bool {
        // Selection must contain three cards.
        guard selectedCardsIndices.count == 3 else { return false }
        
        let currentlySelectedCards = selectedCards
        
        // All properties must be either all the same or all different.
        // Having a collection with two unique members means the selection cannot be a Set.
        if Set<Card.Number>(currentlySelectedCards.map({ $0.number })).count == 2 { return false }
        if Set<Card.Shape>(currentlySelectedCards.map({ $0.shape })).count == 2 { return false }
        if Set<Card.Shading>(currentlySelectedCards.map({ $0.shading })).count == 2 { return false }
        if Set<Card.Color>(currentlySelectedCards.map({ $0.color })).count == 2 { return false }
        
        // Selection is a Set if the program flow can reach here.
        return true
    }
    
    // Called after a Set is accomplished.
    // Replaces selected and matched cards in place if there are cards in the deck.
    // Otherwise removes the selected cards from availableCards.
    private mutating func replaceSelectedCards() {
        // Replacement only occurs when there is a Set selected.
        guard isSelectionASet == true else { return }
        
        selectedCardsIndices.forEach { selectedIndex in
            let indexPosition = availableCardsIndices.firstIndex(of: selectedIndex)!
            
            if let newIndex = cards.firstIndex(where: { !$0.isDealt }) {
                availableCardsIndices[indexPosition] = newIndex
            } else {
                availableCardsIndices.remove(at: indexPosition)
            }
        }
        
        selectedCardsIndices.removeAll()
    }
    
    mutating func select(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(of: card) else { return }
        selectTheCard(at: chosenIndex)
    }
    
    private mutating func selectTheCard(at index: Array<Card>.Index) {
        // Only available cards can be selected.
        guard availableCardsIndices.contains(index) else { return }
        
        // If there are less than 3 cards selected.
        // Either select or deselect the index and return.
        if selectedCardsIndices.count < 3 {
            if selectedCardsIndices.contains(index) {
                selectedCardsIndices.removeAll(where: { $0 == index })
            } else {
                selectedCardsIndices.append(index)
            }
            return
        }
        
        // If there are already 3 cards selected.
        // Either replace the selected cards or make a card selection.
        if isSelectionASet {
            // Replace matched cards with new ones.
            replaceSelectedCards()
            
            // Selected the card if it is still available.
            if availableCardsIndices.contains(index) {
                selectedCardsIndices.append(index)
            }
        } else {
            // The trio was not a set.
            // Deselect all currently selected cards.
            selectedCardsIndices.removeAll()
            
            // Select the card.
            selectedCardsIndices.append(index)
        }
    }
    
    // Set Card
    struct Card: Identifiable, Equatable {
        let id = UUID()
        
        let number: Number
        let shape: Shape
        let shading: Shading
        let color: Color
        
        var isDealt = false
        var isSelected = false
        var isMatched = false
        var isMismatched = false
        
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
