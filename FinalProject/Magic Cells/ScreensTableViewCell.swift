//
//  ScreensTableViewCell.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/9/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

protocol MagicScreensDelegate: NSObjectProtocol {
    func didSelectButtonIn(_ tableViewCell: ScreensTableViewCell, at index: Int)
}

class ScreensTableViewCell: UITableViewCell {
    public weak var delegate: MagicScreensDelegate?
    @IBOutlet weak var screen1: UIButton!
    @IBOutlet weak var screen2: UIButton!
    @IBOutlet weak var screen3: UIButton!
    var allScreenButtons = [UIButton]()
    override func awakeFromNib() {
        super.awakeFromNib()
        allScreenButtons.append(screen1)
        allScreenButtons.append(screen2)
        allScreenButtons.append(screen3)
        for i in 0..<allScreenButtons.count {
            allScreenButtons[i].tag = i
            allScreenButtons[i].imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        self.delegate?.didSelectButtonIn(self, at: sender.tag)
    }
    
}
