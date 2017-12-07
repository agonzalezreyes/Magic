//
//  Level.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/3/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import Foundation

struct Level: Codable {
    
    let hintTitle: String
    let name: String
    let location: Coordinates
    var completed: Bool
    
    struct Coordinates: Codable {
        let latitude: String
        let longitude: String
    }
    
    init(hintTitle: String, name: String, location: Coordinates, completed: Bool) {
        self.hintTitle = hintTitle
        self.name = name
        self.location = location
        self.completed = completed
    }
    
}
