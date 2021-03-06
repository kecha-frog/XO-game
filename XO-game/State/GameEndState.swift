//
//  GameEndState.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class GameEndState: PlayGameState {
    // MARK: - Public Properties
    
    var isMoveCompleted: Bool = false

    weak var gameViewController: GameViewController?

    // MARK: - Private Properties
    
    private let winnerPlayer: Player?

    // MARK: - Initialization
    
    init(winnerPlayer: Player?, gameViewController: GameViewController) {
        self.winnerPlayer = winnerPlayer
        self.gameViewController = gameViewController
    }

    // MARK: - Public Methods

    func addSign(at position: GameboardPosition) {}
    
    func begin() {
        gameViewController?.winnerLabel.isHidden = false
        
        if let winnerPlayer = winnerPlayer {
            Logger.shared.log(action: .gameFinished(won: winnerPlayer))
            gameViewController?.winnerLabel.text = setPlayerName(player: winnerPlayer) + " won"
        } else {
            Logger.shared.log(action: .gameFinished(won: nil))
            gameViewController?.winnerLabel.text = "No winner/Draw"
        }
        
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    // MARK: - Private Methods

    private func setPlayerName(player: Player) -> String {
        switch player {
        case .first:
            return "First"
        case .second:
            return "Second"
        }
    }
}
