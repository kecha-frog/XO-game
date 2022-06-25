//
//  LogCommand.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class LogCommand {
    // MARK: - Public Methods

    var logMessage: String {
        switch action {
        case .playerSetSign(let player, let position):
            return "\(player) placed mark at position \(position)"
        case .gameFinished(let winner):
            if let winner = winner {
                return "\(winner) won game"
            } else {
                return "Is Draw"
            }
        case .restartGame:
            return "Game was restarted"
        }
    }

    // MARK: - Private Properties

    private let action: LogAction

    // MARK: - Initialization
    
    init(action: LogAction) {
        self.action = action
    }
}
