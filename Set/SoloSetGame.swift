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
    
    func getStatus(for card: Card) -> Status {
        Status(
            isCardSelected: model.isCardSelected(card),
            areThreeCardsSelected: model.areThreeCardsSelected,
            isSelectionASet: model.isSelectionASet)
    }
    
    struct Status {
        let isCardSelected: Bool
        let areThreeCardsSelected: Bool
        let isSelectionASet: Bool
    }
    
    // MARK: - Intent(s)
    
    func dealCards() {
        model.dealCards()
    }
    
    func select(_ card: Card) {
        model.select(card)
    }
    
}
