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

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(handleSegmentedControlChange(_: )), for: .valueChanged)
        return control
    }()
    
    var counter = 0
    private let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)

    private var isComputerPlayer = true
    private var isMoveAllowed = true
    
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

            if self.isMoveAllowed{
                self.currentState.addSign(at: position)
                self.counter += 1

                if self.currentState.isMoveCompleted {
                    self.nextPlayerTurn()
                }
            }
        }

        setupSegmentControl()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton?) {
        Logger.shared.log(action: .restartGame)
        
        gameboardView.clear()
        gameBoard.clear()
        counter = 0
        
        firstPlayerTurn()
    }

    func moveAllow(_ allow: Bool) {
        isMoveAllowed = allow
    }
    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        
        let markView = getMarkView(player: firstPlayer)
        if isComputerPlayer {
            currentState = ComputerGameState(player: firstPlayer,
                                             gameViewController: self,
                                             gameBoard: gameBoard,
                                             gameBoardView: gameboardView, markView: markView)
        } else {
            currentState = PlayerGameState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        }

    }
    
    private func nextPlayerTurn() {
        if let winner = referee.determineWinner() {
            currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
            return
        }
        
        if counter >= 9 {
            Logger.shared.log(action: .gameFinished(won: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewController: self)
            return
        }

        if let playerState = currentState as? ComputerGameState{
            switch playerState.player {
            case .first:
                moveAllow(false)
            case .second:
                moveAllow(true)
            }

            let next = playerState.player.next
            let markView = getMarkView(player: next)
            currentState = ComputerGameState(player: next,
                                             gameViewController: self,
                                             gameBoard: gameBoard,
                                             gameBoardView: gameboardView, markView: markView)
        } else if let playerState = currentState as? PlayerGameState{
            let next = playerState.player.next
            let markView = getMarkView(player: next)
            currentState = PlayerGameState(player: next,
                                           gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
        }
    }
    
    private func getMarkView(player: Player) -> MarkView {
        switch player {
        case .first:
            return XView()
        case .second:
            return OView()
        }
    }

    private func setupSegmentControl() {
        view.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: firstPlayerTurnLabel.topAnchor, constant: -10),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])

        segmentedControl.insertSegment(withTitle: "Player vs Player", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Player vs Computer", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 1
    }

    // MARK: - Actions

    @objc private func handleSegmentedControlChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.isComputerPlayer = false
            self.secondPlayerTurnLabel.text = "2nd player"
        } else if sender.selectedSegmentIndex == 1 {
            self.isComputerPlayer = true
            self.secondPlayerTurnLabel.text = "Computer"
        }

        restartButtonTapped(nil)
    }
}

