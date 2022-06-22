//
//  FiveMoveGameState.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveMoveGameState: PlayGameState {
    // MARK: - Computed Properties
    
    private var commands: [FiveMoveCommand] {
        return invoker.commands
    }

    private var getPlayerName: String {
        switch player {
        case .first:
            return "1nd player"
        case .second:
            return "2nd player"
        }
    }

    private var markView: MarkView {
        switch player {
        case .first:
            return XView()
        case .second:
            return OView()
        }
    }

    // MARK: - Public Properties

    var isMoveCompleted: Bool = false
    let invoker = FiveMoveInvoker()

    // MARK: - Private Properties

    private(set) var player: Player
    private var moveCounter = 5

    private weak var gameViewController: GameViewController?
    private weak var gameBoard: Gameboard?
    private weak var gameBoardView: GameboardView?

    // MARK: - Initialization

    init(player: Player, gameViewController: GameViewController?, gameBoardView: GameboardView?, gameBoard: Gameboard?) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoardView = gameBoardView
        self.gameBoard = gameBoard
    }

    // MARK: - Public Methods

    func addSign(at position: GameboardPosition) {
        guard let gameBoardView = gameBoardView,
              gameBoardView.canPlaceMarkView(at: position)
        else { return }

        moveCounter -= 1

        switch player {
        case .first:
            gameViewController?.moveCounterLabel.text = "выберите еще \(moveCounter)"
        case .second:
            gameViewController?.moveCounterLabel.text = "выберите еще \(5 + moveCounter)"
        }

        invoker.addLogCommand(command: .init(self.player, position))

        gameBoardView.placeMarkView(markView.copy(), at: position)

        if invoker.commands.count >= 5 && player == .first {
            gameViewController?.moveAllow(false)
            if #available(iOS 13.0, *) {
                Task {
                    sleep(1)
                    await MainActor.run {
                        beginSwitchPLayer()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.beginSwitchPLayer()
                }
            }
        }else if invoker.commands.count >= 10 && player == .second {
            gameViewController?.moveAllow(false)
        }
    }

    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }

        gameViewController?.winnerLabel.isHidden = true
        gameViewController?.moveCounterLabel.isHidden = false
        gameViewController?.moveCounterLabel.text = "\(getPlayerName) сделайте 5 ходов"
    }

    // MARK: - Private Methods

    private func beginSwitchPLayer(){
        player = player.next
        gameViewController?.moveCounterLabel.text = "\(getPlayerName) сделайте 5 ходов"
        gameBoardView?.clear()
        gameViewController?.moveAllow(true)
    }
}
