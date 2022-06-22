//
//  FiveMoveReceiver.swift
//  XO-game
//
//  Created by Ke4a on 21.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveMoveReceiver {
    func getTuple(_ command: FiveMoveCommand) -> (Player, GameboardPosition){
        return command.getCommand
    }
}
