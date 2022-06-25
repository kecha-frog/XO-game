//
//  FiveMoveReceiver.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveMoveReceiver {
    // MARK: - Public Properties

    let group = DispatchGroup()
    var sec: Double = 1

    // MARK: - Private Properties

    private weak var gameBoard: Gameboard?
    private weak var gameBoardView: GameboardView?

    // MARK: - Initialization

    init(gameBoardView: GameboardView?, gameBoard: Gameboard?){
        self.gameBoardView = gameBoardView
        self.gameBoard = gameBoard
    }

    // MARK: - Public Methods
    
    func move(_ command: FiveMoveCommand) {
        group.enter()
        self.sec += 0.5
        Timer.scheduledTimer(withTimeInterval: sec, repeats: false) { [weak self] (timer) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.gameBoardView?.removeMarkView(at: command.position)
                self.gameBoardView?.placeMarkView(command.mark, at: command.position, checkPlace: false)
                self.gameBoard?.setPlayer(command.player, at: command.position)
                self.group.leave()
            }
        }
    }
}
