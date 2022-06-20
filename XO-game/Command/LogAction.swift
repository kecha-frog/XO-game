//
//  LogAction.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

enum LogAction {
    case playerSetSign(player: Player, position: GameboardPosition)
    case gameFinished(won: Player?)
    case restartGame
}
