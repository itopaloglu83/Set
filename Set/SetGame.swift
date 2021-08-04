//
//  SetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import Foundation

struct SetGame {
    // All the cards for a Set Game.
    private(set) var cards: Array<Card>
    
    private(set) var score = 0
    
    // Card indices for the visible cards.
    // Updates the dealt status once a card is added.
    private var availableCardsIndices: [Array<Card>.Index] {
        didSet{
            availableCardsIndices.forEach({ cards[$0].isDealt = true })
        }
    }
    
    // Card indices for selected cards.
    // Updates the selection and match status when a card is added or removed.
    private var selectedCardsIndices: [Array<Card>.Index] {
        didSet{
            // Update selection for all cards.
            cards.indices.forEach({ cards[$0].isSelected = selectedCardsIndices.contains($0) })
            
            // Update match status for selected or available cards.
            if selectedCardsIndices.count == 3 {
                // If there are 3 cards selected, then they are either a match or a mismatch.
                if isSelectionASet {
                    selectedCardsIndices.forEach({ cards[$0].isMatched = true })
                } else {
                    selectedCardsIndices.forEach({ cards[$0].isMismatched = true })
                }
            } else {
                // No cards should have match status, unless a trio is selected.
                availableCardsIndices.forEach { index in
                    cards[index].isMatched = false
                    cards[index].isMismatched = false
                }
            }
        }
    }
    
    // Cards available for the game.
    var deck: Array<Card> {
        cards.filter({ !$0.isDealt })
    }
    
    // Playable cards in the game.
    var visibleCards: Array<Card> {
        availableCardsIndices.map({ cards[$0] })
    }
    
    init() {
        cards = []
        availableCardsIndices = []
        selectedCardsIndices = []
        
        // Create all cards.
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        cards.append(Card(number, shape, shading, color))
                    }
                }
            }
        }
        
        // Shuffle the cards.
        cards.shuffle()
        
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
    
    mutating func shuffle() {
        availableCardsIndices.forEach({ cards[$0].isDealt = false })
        availableCardsIndices.removeAll()
        
        availableCardsIndices.forEach { index in
            cards[index].isMatched = false
            cards[index].isMismatched = false
        }
        selectedCardsIndices.removeAll()
        
        cards.shuffle()
        
        dealCards()
    }
    
    // Deal cards by adding them to the available cards indices array.
    // We can only deal as many card as available.
    private mutating func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let index = cards.firstIndex(where: { !$0.isDealt }) {
                availableCardsIndices.append(index)
            }
        }
    }
    
    // Checks if the selected cards form a Set.
    private var isSelectionASet: Bool {
        // Selection must contain 3 cards.
        guard selectedCardsIndices.count == 3 else { return false }
        
        // Obtain the currently selected cards via their indices.
        let currentlySelectedCards = selectedCardsIndices.map({ cards[$0] })
        
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
    // Replaces selected cards in place if there are any available.
    // Otherwise removes the selected cards from the available cards list.
    private mutating func replaceSelectedCards() {
        // Replacement only occurs when there is a Set selected.
        guard isSelectionASet == true else { return }
        
        // Each selected card must be updated individually.
        selectedCardsIndices.forEach { selectedIndex in
            // First we need to determine the position of the selected index in
            // the available cards indices. This value must exist!
            let indexPosition = availableCardsIndices.firstIndex(of: selectedIndex)!
            
            // Replace the card if there are any available, or remove it.
            if let newIndex = cards.firstIndex(where: { !$0.isDealt }) {
                availableCardsIndices[indexPosition] = newIndex
            } else {
                availableCardsIndices.remove(at: indexPosition)
            }
        }
        
        score += 1
        
        // All selected cards are processed.
        // Deselect all cards.
        selectedCardsIndices.removeAll()
    }
    
    // Used by the ViewModel to select a given card.
    mutating func select(_ card: Card) {
        // First we need to find the index value for the given card.
        guard let chosenIndex = cards.firstIndex(of: card) else { return }
        
        // Select the card at the chosen index.
        selectTheCard(at: chosenIndex)
    }
    
    // Selects the card at the given index.
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
            
            // Select the chosen card if it is still available.
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
        
        // Card value variables.
        let number: Number
        let shape: Shape
        let shading: Shading
        let color: Color
        
        // Card status variables.
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
            """
            \(number)
            \(shape)
            \(shading)
            \(color)
            """
        }
        
        // Number, Shape, Shading, Color
        enum Number: Int, CaseIterable {
            case one = 1, two, three
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
