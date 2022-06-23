//
//  FiveMoveCommand.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

final class FiveMoveCommand {
    // MARK: - Private Properties

    private let player: Player
    private let position: GameboardPosition
    private let mark: MarkView


    // MARK: - Initialization

    init(_ player: Player, _ position: GameboardPosition, _ markView: MarkView) {
        self.player = player
        self.position = position
        self.mark = markView
    }

    // MARK: - Public Methods

    func execute() -> (Player, GameboardPosition, MarkView) {
        return (self.player, self.position, self.mark)
    }
}
