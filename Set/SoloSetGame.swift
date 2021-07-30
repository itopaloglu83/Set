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
    
    func getStatus(for card: Card) -> CardStatus {
        CardStatus(
            isSelected: model.isCardSelected(card),
            isHighlighted: model.isCardSelected(card) && model.areThreeCardsSelected,
            isSelectionASet: model.isSelectionASet
        )
    }
    
    struct CardStatus {
        let isSelected: Bool
        let isHighlighted: Bool
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
