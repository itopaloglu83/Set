//
//  SetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 8/6/21.
//

import SwiftUI

class SetGame: ObservableObject {
    typealias Card = SetGameModel<CardContent>.Card
    typealias Trio = SetGameModel<CardContent>.Trio
    typealias Features = SetGameModel<CardContent>.Features
    
    // Number, Shape, Shading, Color
    private static let numbers = [1, 2, 3]
    private static let shapes = [CardShape.diamond, .squiggle, .oval]
    private static let shadings = [CardShading.solid, .striped, .open]
    private static let colors = [Color.red, .green, .purple]
    
    // Creates a new model by providing card contents.
    private static func createSetGameModel() -> SetGameModel<CardContent> {
        SetGameModel<CardContent> {
            CardContent(
                number: numbers[$0.one.rawValue],
                shape: shapes[$0.two.rawValue],
                shading: shadings[$0.three.rawValue],
                color: colors[$0.four.rawValue]
            )
        }
    }
    
    // Published Model
    @Published private var model = createSetGameModel()
    
    // MARK: - Game Variables
    
    // Cards available for the game.
    var deck: Array<Card> {
        model.availableCards
    }
    
    // Playable cards in the game.
    var cards: Array<Card> {
        model.dealtCards
    }
    
    // Game score for solo game.
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    // Starts a new game.
    func newGame() {
        model = SetGame.createSetGameModel()
    }
    
    // Deals 12 cards to start the game.
    // Deals 3 cards on all subsequent calls.
    func deal() {
        model.deal()
    }
    
    // Selects the first card that would form a set.
    func hint() {
        model.hint()
    }
    
    // Shuffle visible cards with the deck.
    func shuffle() {
        model.shuffle()
    }
    
    // Selects the given card.
    func select(_ card: Card) {
        model.select(card)
    }
    
    // MARK: - Type Declaration
    
    // Number, Shape, Shading, Color
    struct CardContent {
        let number: Int
        let shape: CardShape
        let shading: CardShading
        let color: Color
    }
    
    // Available shapes.
    enum CardShape {
        case diamond, squiggle, oval
    }
    
    // Available shadings.
    enum CardShading {
        case solid, striped, open
    }
}
