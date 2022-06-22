//
//  FiveMoveCommand.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

final class FiveMoveCommand {
    private let player: Player
    private let position: GameboardPosition

    init(_ player: Player, _ position: GameboardPosition) {
        self.player = player
        self.position = position
    }

    var getCommand: (Player, GameboardPosition) {
        return (self.player, self.position)
    }
}
