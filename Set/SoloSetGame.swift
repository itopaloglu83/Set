//
//  SoloSetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import SwiftUI

class SoloSetGame: ObservableObject {
    typealias Card = SetGame.Card
    
    @Published private var model = SetGame()
    
    // Cards available for the game.
    var deck: Array<Card> {
        model.deck
    }
    
    // Playable cards in the game.
    var visibleCards: Array<Card> {
        model.visibleCards
    }
    
    // MARK: - Intent(s)
    
    // Deals 12 cards to start the game.
    // Deals 3 cards on all subsequent calls.
    func dealCards() {
        model.dealCards()
    }
    
    // Selects the given card.
    func select(_ card: Card) {
        model.select(card)
    }
    
}
