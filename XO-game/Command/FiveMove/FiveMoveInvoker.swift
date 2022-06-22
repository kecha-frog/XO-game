//
//  FiveMoveInvoker.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveMoveInvoker {
    // MARK: - Computed Properties

    private var bufferSize: Int {
        moveIndex.count
    }
    /// Очередность ходов
    private var moveIndex: [Int] {
        [0,5,1,6,2,7,3,8,4,9]
    }

    // MARK: - Public Properties

    // MARK: - Private Properties

    private let receiver: FiveMoveReceiver
    private(set) var commands: [FiveMoveCommand]

    private weak var gameViewController: GameViewController?
    
    // MARK: - Initialization

    init(gameViewController: GameViewController?, gameBoardView: GameboardView?, gameBoard: Gameboard?) {
        self.gameViewController = gameViewController
        self.receiver = FiveMoveReceiver(gameBoardView: gameBoardView, gameBoard: gameBoard)
        self.commands = []
    }

    // MARK: - Public Methods

    func addLogCommand(command: FiveMoveCommand) {
        commands.append(command)
        execute()
    }

    // MARK: - Private Methods
    
    private func execute() {
        guard commands.count >= bufferSize else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.gameViewController?.gameChoice = .vsPlayer(isMoveAllowed: false)
            self?.gameViewController?.restartButtonTapped(nil)
        }

        let group = DispatchGroup()

        var sec: Double = 2

        self.moveIndex.forEach { index in
            group.enter()
            let command = self.commands[index]
            receiver.move(command, group: group, sec: sec)
            sec += 0.33
        }

        group.notify(queue: .main) { [weak self] in
            self?.gameViewController?.nextPlayerTurn()
            self?.gameViewController?.gameChoice = .fiveMoves(isMoveAllowed: true)
        }
    }

}
