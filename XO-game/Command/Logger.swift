//
//  Logger.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class Logger {
    public static var shared = Logger()
    
    
    private init() {}
    
    public func log(action: LogAction) {
        let command = LogCommand(action: action)
        LogInvoker.shared.addLogCommand(command: command)
    }
}
