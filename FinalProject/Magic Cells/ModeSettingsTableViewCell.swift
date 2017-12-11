//
//  ModeSettingsTableViewCell.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/9/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

protocol ModeSettingsCellDelegate: NSObjectProtocol {
    func modeSettingsFrom(_ tableViewCell: ModeSettingsTableViewCell, mode: MagicSettings.Mode)
}

class ModeSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var segmentModeControl: UISegmentedControl!
    public weak var delegate: ModeSettingsCellDelegate?
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
             self.delegate?.modeSettingsFrom(self, mode: .Crash)
        } else {
            self.delegate?.modeSettingsFrom(self, mode: .AnimateCrash)
        }
    }
}
