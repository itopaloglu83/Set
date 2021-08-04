//
//  SetGameModel.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/2/21.
//

import Foundation

struct SetGameModel<FeatureOne, FeatureTwo, FeatureThree, FeatureFour> where FeatureOne: Equatable, FeatureTwo: Equatable, FeatureThree: Equatable, FeatureFour: Equatable {
    // Game score.
    private(set) var score = 0
    
    // All the cards for a Set Game.
    private(set) var cards: Array<Card>
    
    // Cards available for the game.
    var deck: Array<Card> {
        cards.filter({ !$0.isDealt })
    }
    
    // Playable cards in the game.
    var visibleCards: Array<Card> {
        cards.filter({ $0.isDealt && !$0.isRemoved })
    }
    
    init(createCardContent: (Trio, Trio, Trio, Trio) -> Features) {
        cards = []
        
        // Create all cards.
        for one in Trio.allCases {
            for two in Trio.allCases {
                for three in Trio.allCases {
                    for four in Trio.allCases {
                        let features = createCardContent(one, two, three, four)
                        cards.append(Card(with: features))
                    }
                }
            }
        }
        
        // Shuffle the cards.
//        cards.shuffle()
        
        // Initial card deal.
        deal()
    }
    
    // MARK: - Intent Functions
    
    // Deal 12 cards to start the game.
    // Deal 3 cards on all subsequent calls.
    mutating func deal() {
        if visibleCards.isEmpty {
            dealCards(SetGameConstants.initialCardCount)
        } else {
            dealCards(SetGameConstants.subsequentCardCount)
        }
    }
    
    // Used by the ViewModel to select a given card.
    mutating func select(_ card: Card) {
        // First we need to find the index of the given card.
        // Only visible cards can be selected.
        guard let chosenIndex = visibleCards.firstIndex(of: card) else { return }
        
        // If there are no matched cards then
        // we are in the selection mode.
        if matchedCards.count == 0 {
            // Remove highlight for any mismatched cards.
            setHighlights(of: mismatchedCards, to: nil)
            
            // Select or deselect the chosen card.
            toggleSelection(for: chosenIndex)
            
            // If there are now 3 cards selected then highlight with the matching result.
            if selectedCards.count == 3 {
                // Does selection form a Set?
                if checkCardsForSet(selectedCards) {
                    // Update the score and highlight cards as matched.
                    score += SetGameConstants.matchScore
                    setHighlights(of: selectedCards, to: .matched)
                } else {
                    // Update the score and highlight cards as mismatched.
                    score += SetGameConstants.mismatchScore
                    setHighlights(of: selectedCards, to: .mismatched)
                }
            }
        } else {
            // Remove the matched cards and deal new ones.
            removeMatchedCards()
            deal()
        }
    }
    
    // Shuffles the visible cards with the deck.
    mutating func shuffle() {
        // Remove any matched cards before shuffling.
        removeMatchedCards()
        
        // Remove any visible highlights.
        undoVisibleHighlights()
        
        // Move all visible cards back to the deck.
        moveVisibleCardsToDeck()
        
        // Shuffle all the cards in the game.
        cards.shuffle()
        
        // Deal new cards.
        deal()
    }
    
    // MARK: - Helper Functions and Variables
    
    // We can only deal as many card as available.
    private mutating func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let card = deck.first, let index = cards.firstIndex(of: card) {
                cards[index].isDealt = true
            }
        }
    }
    
    // Toggles the selection for a given card index.
    private mutating func toggleSelection(for index: Array<Card>.Index) {
        if cards[index].highlight == .selected {
            cards[index].highlight = nil
        } else {
            cards[index].highlight = .selected
        }
    }
    
    // Returns the card indices for given cards.
    private func cardIndices(for givenCards: Array<Card>) -> [Array<Card>.Index] {
        givenCards.map({ cards.firstIndex(of: $0)! })
    }
    
    // Updates with given cards with the highlight value.
    private mutating func setHighlights(of givenCards: Array<Card>, to highlight: Card.Highlight?) {
        cardIndices(for: givenCards).forEach({ cards[$0].highlight = highlight })
    }
    
    // Removes the matched cards from visible cards.
    private mutating func removeMatchedCards() {
        cardIndices(for: matchedCards).forEach({ cards[$0].isRemoved = true })
    }
    
    // Removes the highlights from all visible cards.
    private mutating func undoVisibleHighlights() {
        cardIndices(for: visibleCards).forEach({ cards[$0].highlight = nil })
    }
    
    // Moves all the visible cards back into the deck.
    private mutating func moveVisibleCardsToDeck() {
        cardIndices(for: visibleCards).forEach({ cards[$0].isDealt = false })
    }
    
    // Returns the visible cards with the given highlight value.
    private func visibleCards(for highlight: Card.Highlight) -> Array<Card> {
        visibleCards.filter({ $0.highlight == highlight })
    }
    
    // Selected visible cards in the game.
    private var selectedCards: Array<Card> {
        visibleCards(for: .selected)
    }
    
    // Matched visible cards in the game.
    private var matchedCards: Array<Card> {
        visibleCards(for: .matched)
    }
    
    // Mismatched visible cards in the game.
    private var mismatchedCards: Array<Card> {
        visibleCards(for: .mismatched)
    }
    
    // Checks the given cards for a Set.
    // Each feature must be all the same or all different.
    private func checkCardsForSet(_ givenCards: Array<Card>) -> Bool {
        // Selection must contain 3 cards.
        guard givenCards.count == 3 else { return false }
        
        // Each card feature must be all the same or all different.
        // Having two features out of three means the given cards do not form a Set.
        if givenCards.map({ $0.featureOne }).twoOutOfThree! { return false }
        if givenCards.map({ $0.featureTwo }).twoOutOfThree! { return false }
        if givenCards.map({ $0.featureThree }).twoOutOfThree! { return false }
        if givenCards.map({ $0.featureFour }).twoOutOfThree! { return false }
        
        // Selection is a Set if the program flow can reach here.
        return true
    }
    
    // MARK: - Type Declarations
    
    // Triple state variable.
    // Used by ViewModel in content creation.
    enum Trio: Int, CaseIterable {
        case zero, one, two
    }
    
    // Collection of card features.
    // Used by ViewModel in content creation.
    struct Features {
        let one: FeatureOne
        let two: FeatureTwo
        let three: FeatureThree
        let four: FeatureFour
    }
    
    // Set Card
    struct Card: Identifiable, Equatable {
        // Identifiable
        let id = UUID()
        
        // Card value variables.
        let featureOne: FeatureOne
        let featureTwo: FeatureTwo
        let featureThree: FeatureThree
        let featureFour: FeatureFour
        
        // Card status variables.
        var isDealt = false
        var isRemoved = false
        var highlight: Highlight?
        
        init(with features: Features) {
            self.featureOne = features.one
            self.featureTwo = features.two
            self.featureThree = features.three
            self.featureFour = features.four
        }
        
        // Card Highlight Style
        enum Highlight {
            case selected, matched, mismatched
        }
    }
    
    // Set Game Constants
    // Variables have to be defined as static computed vars because
    // static stored properties are not supported in generic types.
    private struct SetGameConstants {
        static var matchScore: Int { 3 }
        static var mismatchScore: Int { -1 }
        static var initialCardCount: Int { 12 }
        static var subsequentCardCount: Int { 3 }
    }
}

// MARK: - Array Extensions

// Helper extension to check for a Set.
// Feature types are only Equatable so it's not possible to use Set collection type.
private extension Array where Element: Equatable {
    var twoOutOfThree: Bool? {
        guard count == 3 else { return nil }
        
        if allThreeTheSame! || allThreeDifferent! {
            return false
        }
        
        return true
    }
    
    private var allThreeTheSame: Bool? {
        guard count == 3 else { return nil }
        
        if self[0] == self[1] && self[1] == self[2] {
            return true
        }
        
        return false
    }
    
    private var allThreeDifferent: Bool? {
        guard count == 3 else { return nil }
        
        if self[0] == self[1] || self[1] == self[2] || self[0] == self[2] {
            return false
        }
        
        return true
    }
}
