//
//  TimeViewController.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/10/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

protocol TimeViewControllerDelegate: NSObjectProtocol {
    func timeViewController(_ timeViewController: TimeViewController, timeMode: MagicSettings.Date)
}

class TimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var timesTableView: UITableView! {
        didSet {
            timesTableView.delegate = self
            timesTableView.dataSource = self
        }
    }
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    let timeOptions = MagicData.timeOptions
    
    var currentMode: MagicSettings.Mode?
    
    public weak var delegate: TimeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        timePicker.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setButton(_ sender: UIButton) {
        let timeCustom = timePicker.date
        let defaults = UserDefaults.standard
        defaults.set(timeCustom, forKey: "custom")
        defaults.synchronize()
        self.delegate?.timeViewController(self, timeMode: MagicSettings.Date.Custom)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            if indexPath.row == timeOptions.count - 1 {
                saveButton.isEnabled = true
                timePicker.isEnabled = true
                return
            } else {
                self.delegate?.timeViewController(self, timeMode: MagicSettings.Date.all[indexPath.row])
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    // MARK - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath)
        cell.textLabel?.text = timeOptions[indexPath.row]
        if let modeSaved = currentMode, modeSaved.rawValue == indexPath.row {
            cell.isSelected = true
        }
        return cell
    }
    
}
