//
//  SetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import Foundation

struct SetGame {
    // All cards starts in the deck.
    // As cards are selected, they are moved to availableCards.
    // Once a card trio is matched, they are then moved to removedCards.
    private(set) var deck: Array<Card>
    private(set) var availableCards: Array<Card>
    private(set) var removedCards: Array<Card>
    
    // TODO: Replace selectedCards with selectedIndices in availableCards.
    // A copy of selected cards are added to selectedCards to keep tally.
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
        
        // The game starts with full deck and nothing else.
        availableCards = []
        removedCards = []
        selectedCards = []
        
        // Initial card deal.
        dealCards()
    }
    
    // Deal 12 cards to start the game.
    // Deal 3 cards on all subsequent calls.
    mutating func dealCards() {
        if availableCards.isEmpty {
            dealCards(12)
        } else {
            dealCards(3)
        }
    }
    
    // Try removing a card from the deck if there are any,
    // and add it to the availableCards.
    private mutating func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let card = deck.popLast() {
                availableCards.append(card)
            }
        }
    }
    
    // Returns if a card is selected.
    // Used by ViewModel to translate model status to view requirements.
    func isCardSelected(_ card: Card) -> Bool {
        selectedCards.contains(card)
    }
    
    // Return if there are three cards selected.
    // Used by ViewModel to translate model status to view requirements.
    var areThreeCardsSelected: Bool {
        selectedCards.count == 3
    }
    
    // Checks if the selectedCards forms a Set.
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
    
    // Called after a Set is accomplished.
    // Replaces selected and matched cards in place if there are cards in the deck.
    // Otherwise removes the selected cards from availableCards.
    private mutating func replaceSelectedCards() {
        // Replacement only occurs when there is a Set selected.
        guard isSelectionASet == true else { return }
        
        for card in selectedCards {
            // Take a card from the deck if there are any.
            if let newCard = deck.popLast() {
                // Replace the card in place with the new one.
                availableCards[availableCards.firstIndex(of: card)!] = newCard
            } else {
                // No cards left in the deck. Remove the matched card.
                availableCards.removeAll(where: { $0.id == card.id })
            }
            
            // Add the card to removedCards for record keeping.
            removedCards.append(card)
        }
        
        // Deselect all cards.
        selectedCards.removeAll()
    }
    
    // Selects a card that is in availableCards.
    // Subsequent calls either replaces the matched cards or updates the card selection.
    mutating func select(_ card: Card) {
        // Only dealt cards can be selected.
        guard availableCards.contains(card) else { return }
        
        // If the card is already selected and there are less than three cards selected
        // then allow the user to deselect the card and return.
        if selectedCards.contains(card) && selectedCards.count < 3 {
            selectedCards.removeAll(where: { $0.id == card.id })
            return
        }
        
        // Select the card and return, unless there is already a trio selected.
        if selectedCards.count < 3 {
            selectedCards.append(card)
            return
        }
        
        // There are already three cards selected.
        // Either replace the selected cards or make a card selection.
        if isSelectionASet {
            // Replace matched cards with new ones.
            replaceSelectedCards()
            
            // Selected the card if it is still available.
            if availableCards.contains(card) {
                selectedCards.append(card)
            }
        } else {
            // The trio was not a set.
            // Deselect all currently selected cards.
            selectedCards.removeAll()
            
            // Select the card.
            selectedCards.append(card)
        }
    }
    
    // TODO: Create a new Set Card struct that encompasses value and style together.
    // Set Card
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
