//
//  Levels.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/3/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import Foundation

struct Levels: Codable {
    
    let levels: [Level]
    
    init?(json: Data) // take some JSON and try to init an Level from it
    {
        if let newValue = try? JSONDecoder().decode(Levels.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? // return this Level as a JSON data
    {
        return try? JSONEncoder().encode(self)
    }
    
    init(levels: [Level]) {
        self.levels = levels
    }
    
}
