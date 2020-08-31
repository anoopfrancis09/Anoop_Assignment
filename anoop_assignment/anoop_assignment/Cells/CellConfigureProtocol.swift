//
//  CellConfigureProtocol.swift
//  anoop_assignment
//
//  Created by Apple on 27/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

/// Will be helpfull if we have multiple cells...
protocol CellConfigureProtocol: UITableViewCell {
    
    /// pass data to cell through config, set delegate if any call back is required
    /// - Parameters:
    ///   - config: pass data to update cell info
    ///   - delegate: set delegatae if any call back is required, then the cell must implement it
    func configureCell(config: [String: Any], delegate: NSObject?)
}

