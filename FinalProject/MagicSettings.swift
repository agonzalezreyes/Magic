//
//  MagicSettings.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/9/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import Foundation

struct MagicSettings: Codable {
    var mode: Mode = .Crash // 1 or 0
    var time: Date = .TimeOfPerformance
    var images = [Int : Data]()
    var suitOrder = [String]()
    
    public enum Mode: Int, Codable {
        case Crash
        case AnimateCrash
    }
    public enum Date: Int, Codable {
        case TimeOfPerformance
        case OneHourAgo
        case TwoHoursAgo
        case OneDayAgo
        case OneWeekAgo
        case OneMonthAgo
        case Custom
    }
    
    init(mode: Mode, date: Date, images: [Int : Data], suitOrder: [String]) {
        self.mode = mode
        self.time = date
        self.images = images
        self.suitOrder = suitOrder
    }
    
    init?(json: Data) // take some JSON and try to init an MagicSettings from it
    {
        if let newValue = try? JSONDecoder().decode(MagicSettings.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? // return this MagicSettings as a JSON data
    {
        return try? JSONEncoder().encode(self)
    }
    
}
