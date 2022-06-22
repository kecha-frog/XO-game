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

    /// Вызывается по завершению execute
    var complete: (([(Player, GameboardPosition)])-> Void)?

    // MARK: - Private Properties

    private let receiver = FiveMoveReceiver()
    private(set) var commands: [FiveMoveCommand]

    // MARK: - Initialization

    init() {
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

        let array: [(Player, GameboardPosition)] = moveIndex.map { index in
            let command = commands[index]
            return receiver.getTuple(command)
        }

        
        self.complete?(array)
    }
}
