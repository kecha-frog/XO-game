//
//  PlayerGameState.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class PlayerGameState: PlayGameState {
    // MARK: - Public Properties

    var isMoveCompleted: Bool = false
    
    public let player: Player

    public let markView: MarkView

    // MARK: - Private Properties

    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameBoard: Gameboard?
    private(set) weak var gameBoardView: GameboardView?

    // MARK: - Initialization

    init(player: Player, gameViewController: GameViewController?, gameBoard: Gameboard?, gameBoardView: GameboardView?, markView: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markView = markView
    }

    // MARK: - Public Methods
    
    func addSign(at position: GameboardPosition) {
        guard let gameBoardView = gameBoardView,
              gameBoardView.canPlaceMarkView(at: position)
        else { return }
        
        gameBoard?.setPlayer(player, at: position)
        Logger.shared.log(action: .playerSetSign(player: player, position: position))
        gameBoardView.placeMarkView(markView.copy(), at: position)
        isMoveCompleted = true
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
        gameViewController?.moveCounterLabel.isHidden = true
    }
}
