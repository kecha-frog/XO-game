//
//  FiveMoveInvoker.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveMoveInvoker {
    let receiver = FiveMoveReceiver()

    /// Вызывается по завершению execute
    var complete: (([(Player, GameboardPosition)])-> Void)?

    private(set) var commands: [FiveMoveCommand]

    private var bufferSize: Int {
        moveIndex.count
    }

    /// Очередность ходов
    private var moveIndex: [Int] {
        [0,5,1,6,2,7,3,8,4,9]
    }
    
    init() {
        self.commands = []
    }

    func addLogCommand(command: FiveMoveCommand) {
        commands.append(command)
        execute()
    }

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
