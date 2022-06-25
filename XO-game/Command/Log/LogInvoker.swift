//
//  LogInvoker.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class LogInvoker {
    // MARK: - Static Properties

    public static let shared = LogInvoker()

    // MARK: - Private Properties

    private let receiver = LogReceiver()
    private var commands: [LogCommand] = []
    private let bufferSize = 6

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    func addLogCommand(command: LogCommand) {
        commands.append(command)
        execute()
    }

    // MARK: - Private Methods
    
    private func execute() {
        guard commands.count >= bufferSize else {
            return
        }
        
        commands.forEach { receiver.setMessage(message: $0.logMessage) }
        commands = []
    }
}
