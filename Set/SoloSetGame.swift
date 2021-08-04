//
//  SoloSetGame.swift
//  Set
//
//  Created by İhsan TOPALOĞLU on 7/26/21.
//

import SwiftUI

class SoloSetGame: ObservableObject {
    typealias SoloSetGameModel = SetGameModel<Int, Shape, Shading, Color>
    typealias Card = SoloSetGameModel.Card
    typealias Trio = SoloSetGameModel.Trio
    typealias Features = SoloSetGameModel.Features
    
    // Number, Shape, Shading, Color
    private static let numbers = [1, 2, 3]
    private static let shapes = [Shape.diamond, .squiggle, .oval]
    private static let shadings = [Shading.solid, .striped, .open]
    private static let colors = [Color.red, .green, .purple]
    
    // Creates a new model by providing card contents.
    private static func createSoloSetGame() -> SoloSetGameModel {
        SoloSetGameModel {
            Features(
                one: numbers[$0.rawValue],
                two: shapes[$1.rawValue],
                three: shadings[$2.rawValue],
                four: colors[$3.rawValue]
            )
        }
    }
    
    // Published Model
    @Published private var model = createSoloSetGame()
    
    // MARK: - Game Variables
    
    // Cards available for the game.
    var deck: Array<Card> {
        model.deck
    }
    
    // Playable cards in the game.
    var visibleCards: Array<Card> {
        model.visibleCards
    }
    
    // Game score for solo game.
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    // Starts a new game.
    func newGame() {
        model = SoloSetGame.createSoloSetGame()
    }
    
    // Deals 12 cards to start the game.
    // Deals 3 cards on all subsequent calls.
    func deal() {
        model.deal()
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
    
    // Available shapes.
    enum Shape: Equatable {
        case diamond, squiggle, oval
    }
    
    // Available shadings.
    enum Shading {
        case solid, striped, open
    }
}
