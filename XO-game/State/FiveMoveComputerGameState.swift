//
//  FiveMoveGameState.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveMoveComputerGameState: PlayerGameState{
    private(set) var move: [(Player, GameboardPosition)]

    private let position: GameboardPosition

    init(gameViewController: GameViewController?,
         gameBoard: Gameboard?,
         gameBoardView: GameboardView?,
         markView: MarkView, _  move: [(Player, GameboardPosition)]
    ) {
        var array = move
        let (player, postion) = array.removeFirst()
        self.move = array
        self.position = postion

        super.init(
            player: player,
            gameViewController: gameViewController,
            gameBoard: gameBoard,
            gameBoardView: gameBoardView, markView: markView)
        gameViewController?.moveAllow(false)
    }

    override func addSign(at position: GameboardPosition) {
        guard let gameBoardView = gameBoardView else { return }

        gameBoard?.setPlayer(player, at: position)
        Logger.shared.log(action: .playerSetSign(player: player, position: position))
        gameBoardView.removeMarkView(at: position)
        gameBoardView.placeMarkView(markView.copy(), at: position)
        isMoveCompleted = true
    }

    override func begin() {
        super.begin()

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

        gameViewController?.moveCounterLabel.isHidden = false
        gameViewController?.moveCounterLabel.text = "Воспроизведение игры"
    }

    private func computerMove() {
        guard let gameBoardView = self.gameBoardView else { return }
        gameViewController?.moveAllow(true)
        gameBoardView.onSelectPosition?(self.position)
        gameViewController?.moveAllow(false)
    }
}
