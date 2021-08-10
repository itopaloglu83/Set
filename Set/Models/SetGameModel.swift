//
//  SetGameModel.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/9/21.
//

import Foundation
import Algorithms

struct SetGameModel<Content> {
    // Game score.
    private(set) var score = 0
    
    // All the cards in the game.
    private(set) var cards: Array<Card>
    
    // Cards that are not dealt.
    var availableCards: Array<Card> {
        cardsWith(condition: .new)
    }
    
    // Cards playable in the game.
    var dealtCards: Array<Card> {
        cardsWith(condition: .dealt)
    }
    
    // Matched and removed cards.
    var removedCards: Array<Card> {
        cardsWith(condition: .removed)
    }
    
    // Initializer
    init(generateCardContent: (Features) -> Content) {
        cards = []
        
        // Generate all the cards.
        for one in Trio.allCases {
            for two in Trio.allCases {
                for three in Trio.allCases {
                    for four in Trio.allCases {
                        let features = Features(one, two, three, four)
                        let content = generateCardContent(features)
                        
                        let card = Card(features, content)
                        
                        cards.append(card)
                    }
                }
            }
        }
        
        // Shuffle all the cards.
        cards.shuffle()
        
        // Initial card deal.
        deal()
    }
    
    // MARK: - Intent Functions
    
    // Deal 12 cards to start the game.
    // Deal 3 cards on all subsequent calls.
    mutating func deal() {
        if dealtCards.isEmpty {
            dealCards(Constants.initialCardCount)
        } else {
            dealCards(Constants.subsequentCardCount)
        }
    }
    
    // Used by the ViewModel to select a given card.
    mutating func select(_ card: Card) {
        // First we need to find the index of the given card.
        guard let index = cards.firstIndex(of: card) else { return }
        
        // Only visible cards can be selected.
        guard cards[index].condition == .dealt else { return }
        
        // If there are no matched cards that are visible,
        // then we are in the selection mode.
        if cardsWith(condition: .dealt, status: .matched).isEmpty {
            // Remove highlight for any mismatched cards.
            indicesWith(status: .mismatched).forEach({ cards[$0].status = .normal })
            
            // Select or deselect the chosen card.
            cards[index].toggleSelection()
            
            // If there are now 3 cards selected then highlight with the matching result.
            if cardsWith(status: .selected).count == 3 {
                // Does selection form a Set?
                if checkSelectedCardsForSet() {
                    score += Constants.matchPoints
                    indicesWith(status: .selected).forEach({ cards[$0].status = .matched })
                } else {
                    score -= Constants.mismatchPoints
                    indicesWith(status: .selected).forEach({ cards[$0].status = .mismatched })
                }
            }
        } else {
            // Remove the matched cards.
            indicesWith(condition: .dealt, status: .matched).forEach({ cards[$0].condition = .removed })
            
            // Select or deselect the chosen card.
            cards[index].toggleSelection()
            
            // Deal new cards.
            deal()
        }
    }
    
    // Selects the first visible card that can form a Set.
    mutating func hint() {
        // Get the first card that would form a Set and
        // reduce the score as a cost of using hint.
        if let card = firstMatchingCard {
            score -= Constants.hintPoints
            select(card)
        }
    }
    
    // Shuffles the visible cards with the deck.
    mutating func shuffle() {
        // Reduce the score if there was a match.
        if (firstMatchingCard != nil) {
            score -= Constants.shufflePoints
        }
        
        // Remove any matched cards before shuffling.
        indicesWith(condition: .dealt, status: .matched).forEach({ cards[$0].condition = .removed })
        
        // Remove any visible highlights.
        indicesWith(condition: .dealt).forEach({ cards[$0].status = .normal })
        
        // Move all visible cards back to the deck.
        indicesWith(condition: .dealt).forEach({ cards[$0].condition = .new })
        
        // Shuffle all the cards in the game.
        cards.shuffle()
        
        // Deal new cards.
        deal()
    }
    
    // MARK: - Helper Functions and Variables
    
    // We can only deal as many card as available.
    private mutating func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let index = cards.firstIndex(where: { $0.condition == .new }) {
                cards[index].condition = .dealt
            }
        }
    }
    
    // Returns cards with a certain condition, status, or both.
    private func cardsWith(condition: Card.Condition? = nil, status: Card.Status? = nil) -> Array<Card> {
        switch (condition, status) {
        case (nil, nil):
            return []
        case (.some, nil):
            return cards.filter({ $0.condition == condition! })
        case (nil, .some):
            return cards.filter({ $0.status == status! })
        case (.some, .some):
            return cards.filter({
                $0.condition == condition! && $0.status == status!
            })
        }
    }
    
    // Returns card indices with a certain condition, status, or both.
    private func indicesWith(condition: Card.Condition? = nil, status: Card.Status? = nil) -> [Array<Card>.Index] {
        switch (condition, status) {
        case (nil, nil):
            return []
        case (.some, nil):
            return cards.indices.filter({ cards[$0].condition == condition! })
        case (nil, .some):
            return cards.indices.filter({ cards[$0].status == status! })
        case (.some, .some):
            return cards.indices.filter({
                cards[$0].condition == condition! && cards[$0].status == status!
            })
        }
    }
    
    // Checks the selected cards for a Set.
    // Each feature must be all the same or all different.
    private func checkSelectedCardsForSet() -> Bool {
        let selectedCards = cardsWith(status: .selected)
        return checkCardsForSet(selectedCards)
    }
    
    // Checks if the given cards form a Set.
    private func checkCardsForSet(_ givenCards: Array<Card>) -> Bool {
        // There should be at least 3 cards.
        guard givenCards.count == 3 else { return false }
        
        // Each card feature must be all the same or all different.
        // Having two features out of three means the given cards do not form a Set.
        if Set<Trio>(givenCards.map({ $0.features.one })).count == 2 { return false }
        if Set<Trio>(givenCards.map({ $0.features.two })).count == 2 { return false }
        if Set<Trio>(givenCards.map({ $0.features.three })).count == 2 { return false }
        if Set<Trio>(givenCards.map({ $0.features.four })).count == 2 { return false }
        
        // Selection is a Set if the program flow can reach here.
        return true
    }
    
    private var firstMatchingCard: Card? {
        // Get the selected cards.
        let selectedCards = cardsWith(condition: .dealt, status: .selected)
        
        // Check that number of selected cards is less than three.
        // Ensure that we don't try to select negative cards.
        guard selectedCards.count < 3 else { return nil }
        
        // Number of cards to select.
        let numberOfCardsToSelect = 3 - selectedCards.count
        
        // Get the cards in normal and mismatched status to form accessible cards.
        let normalCards = cardsWith(condition: .dealt, status: .normal)
        let mismatchedCards = cardsWith(condition: .dealt, status: .mismatched)
        
        // Accessible cards can be used by the user to form a Set.
        let accessibleCards = (normalCards + mismatchedCards).shuffled()
        
        // Get combinations of accessible cards and check for a Set.
        for possibleMatchCombo in accessibleCards.combinations(ofCount: numberOfCardsToSelect) {
            // Combine user selected cards with possibly matching cards.
            // If there is a match, return the card.
            if checkCardsForSet(selectedCards + possibleMatchCombo) {
                return possibleMatchCombo.first
            }
        }
        
        // If the program flow reaches here, there was no match present.
        return nil
    }
    
    // MARK: - Type Declarations
    
    // A collection of triple states.
    struct Features {
        let one: Trio
        let two: Trio
        let three: Trio
        let four: Trio
        
        internal init(_ one: Trio, _ two: Trio, _ three: Trio, _ four: Trio) {
            self.one = one
            self.two = two
            self.three = three
            self.four = four
        }
    }
    
    // Triple state variable.
    enum Trio: Int, CaseIterable {
        case zero, one, two
    }
    
    // Set Card
    struct Card: Identifiable, Equatable {
        // Identifiable Protocol
        let id = UUID()
        
        // Card Features
        let features: Features
        
        // Card Content
        let content: Content
        
        // Card
        var condition = Condition.new
        
        // Card Status
        var status = Status.normal
        
        internal init(_ features: Features, _ content: Content) {
            self.features = features
            self.content = content
        }
        
        // Toggle Selection
        mutating func toggleSelection() {
            switch status {
            case .normal:
                status = .selected
            case .selected:
                status = .normal
            default:
                break
            }
        }
        
        // Location
        enum Condition {
            case new, dealt, removed
        }
        
        // Status
        enum Status {
            case normal, selected, matched, mismatched
        }
        
        // Equatable Protocol
        static func == (lhs: Card, rhs: Card) -> Bool {
            lhs.id == rhs.id && lhs.condition == rhs.condition && lhs.status == rhs.status
        }
    }
}

fileprivate struct Constants {
    static let initialCardCount = 12
    static let subsequentCardCount = 3
    // Scores
    static let matchPoints = 3
    static let mismatchPoints = 1
    static let hintPoints = 1
    static let shufflePoints = 1
}
