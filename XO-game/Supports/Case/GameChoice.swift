//
//  GameChoice.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

enum GameChoice {
    case vsPlayer(isMoveAllowed: Bool = true)
    case fiveMoves(isMoveAllowed: Bool = true)
    case vsComputer(isMoveAllowed: Bool = true)
}

extension GameChoice {
    // MARK: - Computed Properties


    /// Ограничение хода чтоб во время хождения компьютера нельзя было поставить view
    var isMoveAllowed: Bool {
        switch self {
        case .vsPlayer(let isMoveAllowed):
            return isMoveAllowed
        case .fiveMoves(let isMoveAllowed):
            return isMoveAllowed
        case .vsComputer(let isMoveAllowed):
            return isMoveAllowed
        }
    }
    
    // MARK: - Public Methods

    /// Функция резрешения хода
    /// - Parameter move: 
    mutating func moveAllow(_ move: Bool) {
        switch self {
        case .vsPlayer(_):
            self  = .fiveMoves(isMoveAllowed: move)
        case .fiveMoves(_):
            self  = .fiveMoves(isMoveAllowed: move)
        case .vsComputer(_):
            self  = .vsComputer(isMoveAllowed: move)
        }
    }
}


