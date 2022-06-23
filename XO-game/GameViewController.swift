//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!

    var moveCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        let font: [AnyHashable : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)]
        control.setTitleTextAttributes(font as? [NSAttributedString.Key : Any], for: .normal)
        control.addTarget(self, action: #selector(handleSegmentedControlChange(_: )), for: .valueChanged)
        return control
    }()

    private var counter = 0
    var gameChoice:GameChoice = .vsComputer()

    private let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)

    private var currentState: PlayGameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPlayerTurn()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }

            // Ограничение хода
            if self.gameChoice.isMoveAllowed{
                self.currentState.addSign(at: position)

                if self.currentState.isMoveCompleted {
                    self.nextPlayerTurn()
                }
            }
        }

        setupUI()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton?) {
        Logger.shared.log(action: .restartGame)
        
        gameboardView.clear()
        gameBoard.clear()
        counter = 0

        firstPlayerTurn()
    }

    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        
        let markView = getMarkView(player: firstPlayer)

        // выбор исходя из игры
        switch gameChoice{
        case .vsPlayer:
            currentState = PlayerGameState(
                player: firstPlayer,
                gameViewController: self,
                gameBoard: gameBoard,
                gameBoardView: gameboardView, markView: markView)
        case .vsComputer(_):
            currentState = ComputerGameState(
                player: firstPlayer,
                gameViewController: self,
                gameBoard: gameBoard,
                gameBoardView: gameboardView, markView: markView)
        case .fiveMoves:
            currentState = FiveMoveGameState(
                player: firstPlayer,
                gameViewController: self,
                gameBoardView: gameboardView, gameBoard: gameBoard)
        }

    }
    
    func nextPlayerTurn() {
        if let winner = referee.determineWinner() {
            currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
            return
        }


        if counter >= 9 {
            Logger.shared.log(action: .gameFinished(won: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewController: self)
            return
        }

        switch gameChoice {
        case .vsPlayer:
            guard let playerState = currentState as? PlayerGameState else { return }

            let next = playerState.player.next
            let markView = getMarkView(player: next)

            currentState = PlayerGameState(player: next,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView,
                                           markView: markView)
        case .fiveMoves:
            guard let playerState = currentState as? FiveMoveGameState else { return }

            let next = playerState.player.next

            currentState = FiveMoveGameState(player: next,
                                             gameViewController: self,
                                             gameBoardView: gameboardView,
                                             gameBoard: gameBoard)
        case .vsComputer(_):
            guard let computerGame = currentState as? ComputerGameState else { return }

            switch computerGame.player {
            case .first:
                gameChoice.moveAllow(false)
            case .second:
                gameChoice.moveAllow(true)
            }

            let next = computerGame.player.next
            let markView = getMarkView(player: next)

            currentState = ComputerGameState(player: next,
                                             gameViewController: self,
                                             gameBoard: gameBoard,
                                             gameBoardView: gameboardView,
                                             markView: markView)
        }
    }

    func counterMove(){
        self.counter += 1
    }

    func moveAllow(_ move: Bool) {
        gameChoice.moveAllow(move)
    }
    
    private func getMarkView(player: Player) -> MarkView {
        switch player {
        case .first:
            return XView()
        case .second:
            return OView()
        }
    }

    private func setupUI() {
        view.addSubview(moveCounterLabel)
        NSLayoutConstraint.activate([
            moveCounterLabel.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 10),
            moveCounterLabel.heightAnchor.constraint(equalToConstant: 20),
            moveCounterLabel.centerXAnchor.constraint(equalTo: winnerLabel.centerXAnchor)
        ])

        view.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: firstPlayerTurnLabel.topAnchor, constant: -10),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])

        segmentedControl.insertSegment(withTitle: "Player vs Player", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Player vs Player (5x5)", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Player vs Computer", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 2
    }


    // MARK: - Actions

    @objc private func handleSegmentedControlChange(_ sender: UISegmentedControl) {
        self.secondPlayerTurnLabel.text = "2nd player"

        if sender.selectedSegmentIndex == 0  {
            self.gameChoice = .vsPlayer()
        } else if sender.selectedSegmentIndex == 1 {
            self.gameChoice = .fiveMoves()
        } else if sender.selectedSegmentIndex == 2 {
            self.gameChoice = .vsComputer()
            self.secondPlayerTurnLabel.text = "Computer"
        }

        restartButtonTapped(nil)
    }
}

