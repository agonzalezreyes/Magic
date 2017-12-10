//
//  MagicSettings.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/9/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import Foundation

struct MagicSettings: Codable {
    var mode: Int // 1 or 0
    var images = [Int : Data]()
    var time: Date
    var suitOrder = [String]()
}
