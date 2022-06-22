//
//  ComputerGameState.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class ComputerGameState: PlayerGameState {
    // MARK: - Override Initialization

    override init(
        player: Player, gameViewController: GameViewController?,
        gameBoard: Gameboard?, gameBoardView: GameboardView?, markView: MarkView
    ) {
        super.init(
            player: player,
            gameViewController: gameViewController,
            gameBoard: gameBoard,
            gameBoardView: gameBoardView, markView: markView)
    }

    // MARK: - Override Methods

    override func begin() {
        super.begin()
        
        switch player {
        case .first:
            break
        case .second:
            if #available(iOS 13.0, *) {
                Task {
                    sleep(1)
                    await MainActor.run {
                        computerMove()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.computerMove()
                }

            }
        }
    }

    private func computerMove() {
        guard let gameBoardView = gameBoardView,
              let gameViewController = gameViewController
        else { return }
        
        let position = GameboardPosition(column: Int.random(in: 0...2), row: Int.random(in: 0...2))

        if gameBoardView.canPlaceMarkView(at: position) {
            gameViewController.moveAllow(true)
            self.gameBoardView?.onSelectPosition?(position)
        }else {
            computerMove()
        }
    }
}
