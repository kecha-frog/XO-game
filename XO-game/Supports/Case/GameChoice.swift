//
//  GameChoice.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

enum GameChoice {
    case vsPlayer
    case fiveMoves(isMoveAllowed: Bool = true)
    case fiveMovesComputer(_ move: [(Player, GameboardPosition)], isMoveAllowed: Bool = true)
    case vsComputer(isMoveAllowed: Bool = true)
}

extension GameChoice {
    // MARK: - Computed Properties

    var isMoveAllowed: Bool {
        switch self {
        case .vsPlayer:
            return true
        case .fiveMovesComputer(_, let isMoveAllowed):
            return isMoveAllowed
        case .fiveMoves(let isMoveAllowed):
            return isMoveAllowed
        case .vsComputer(let isMoveAllowed):
            return isMoveAllowed
        }
    }
    
    // MARK: - Public Methods

    mutating func moveAllow(_ move: Bool) {
        switch self {
        case .vsPlayer:
            break
        case .fiveMovesComputer(let array, _):
            self  = .fiveMovesComputer(array, isMoveAllowed: move)
        case .fiveMoves(_):
            self  = .fiveMoves(isMoveAllowed: move)
        case .vsComputer(_):
            self  = .vsComputer(isMoveAllowed: move)
        }
    }
}


