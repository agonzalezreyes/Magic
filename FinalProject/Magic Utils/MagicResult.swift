//
//  MagicResult.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/8/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import Foundation

struct MagicResult {
    var suit = "♠️"
    var number = "A"
    //var fileType = ".PNG" // screenshots are PNG
    
//    init(with fileExtension: String) {
//        fileType = fileExtension
//    }
    
    public func cardFileName() -> String {
        return suit + number //+ fileType
    }
}
