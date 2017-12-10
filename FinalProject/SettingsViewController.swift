//
//  SettingsViewController.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/9/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, MagicScreensDelegate, UINavigationControllerDelegate, SuitsChangedDelegate, BackgroundCellDelegate {
    
    let settings = ["Mode","Screenshots","Background Style","Time of Prediction","Suit Order"]
    let imagePicker = UIImagePickerController()
    var magicSettings: MagicSettings!
    var modeNormal: Bool = true
    var images = [Int : Data]()
    var predictionDate: Date = Date()
    var suitOrder = [String]()
    var suits = ["♣️","♥️","♠️","♦️"]
    var colors = Colors.all
    
    @IBOutlet weak var settingsTableView: UITableView! {
        didSet {
            settingsTableView.delegate = self
            settingsTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        magicSettings = MagicSettings(mode: 0, images: images, time: predictionDate, suitOrder: suits)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
    }
    
    @IBAction func saveAndPerform(_ sender: UIButton) {
        self.performSegue(withIdentifier: "perform", sender: self)
    }
    
    // MARK - MagicScreensDelegate
    
    var screenNumber = 0
    func didSelectButtonIn(_ tableViewCell: ScreensTableViewCell, at index: Int) {
        screenNumber = index
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK - SuitsChangedDelegate
    
    func suitsChanged(_ suitsTableViewCell: SuitsTableViewCell, newSuitOrder: [String]) {
        self.suits = newSuitOrder
    }
    
    // MARK - BackgroundCellDelegate
    
    func didSelectCellFrom(_ backgroundsTableViewCell: BackgroundsTableViewCell, at index: Int) {
        
    }
    
    // MARK - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        images[screenNumber] = UIImagePNGRepresentation(image)!
        dismiss(animated:true, completion: nil)
        settingsTableView.reloadData()
    }
    
    // MARK - UITableViewDataSource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settings[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ModeCell", for: indexPath) as! ModeSettingsTableViewCell
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScreensCell", for: indexPath) as! ScreensTableViewCell
                cell.delegate = self // MagicScreensDelegate
                for i in 0..<3 {
                    if let data = images[i] {
                        cell.allScreenButtons[i].setImage(UIImage(data: data), for: .normal)
                    }
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BackgroundCell", for: indexPath) as! BackgroundsTableViewCell
                cell.colors = colors
                cell.delegate = self
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeTableViewCell
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SuitsCell", for: indexPath) as! SuitsTableViewCell
                cell.suits = suits
                cell.delegate = self
                return cell
            default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return CGFloat(60)
            case 1:
                return CGFloat(150)
            case 2:
                return CGFloat(100)
            case 3:
                return CGFloat(60)
            case 4:
                return CGFloat(100)
            default:
                return CGFloat(60)
        }
    }

}
