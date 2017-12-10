//
//  TimeViewController.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/10/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var timesTableView: UITableView! {
        didSet {
            timesTableView.delegate = self
            timesTableView.dataSource = self
        }
    }
    @IBOutlet weak var timePicker: UIDatePicker!
    let timeOptions = ["1 hour before",
                       "2 hours before",
                       "1 day before",
                       "1 week ago",
                       "1 month ago"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func setButton(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
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
        return cell
    }
    
}
