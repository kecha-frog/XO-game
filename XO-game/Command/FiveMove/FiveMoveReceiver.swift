//
//  FiveMoveReceiver.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveMoveReceiver {
    // MARK: - Private Properties
    
    private weak var gameViewController: GameViewController?
    private weak var gameBoard: Gameboard?
    private weak var gameBoardView: GameboardView?

    // MARK: - Initialization

    init(gameBoardView: GameboardView?, gameBoard: Gameboard?){
        self.gameBoardView = gameBoardView
        self.gameBoard = gameBoard
    }

    // MARK: - Public Methods
    
    func move(_ command: FiveMoveCommand, group: DispatchGroup, sec: Double) {
        Timer.scheduledTimer(withTimeInterval: sec, repeats: false) { [weak self] (timer) in
            DispatchQueue.main.async {
                let (player, position, mark) = command.getCommand

                self?.gameBoardView?.removeMarkView(at: position)
                self?.gameBoardView?.placeMarkView(mark, at: position, checkPlace: false)
                self?.gameBoard?.setPlayer(player, at: position)
                group.leave()
            }
        }
    }
}
