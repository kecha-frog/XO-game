//
//  Prototype.swift
//  XO-game
//
//  Created by Ke4a on 20.06.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

protocol Copying: AnyObject {
    init(_ protype: Self)
}

extension Copying  {
    // MARK: - Public Methods
    
    func copy() -> Self {
        return type(of: self).init(self)
    }
}
