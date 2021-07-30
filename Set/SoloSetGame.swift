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
    
    var deck: Array<Card> {
        model.deck
    }
    
    var availableCards: Array<Card> {
        model.availableCards
    }
    
    // MARK: - Intent(s)
    
    func dealCards() {
        model.dealCards()
    }
    
    func select(_ card: Card) {
        model.select(card)
    }
    
}
