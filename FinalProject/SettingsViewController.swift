//
//  SettingsViewController.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/9/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit
import Photos

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, MagicScreensDelegate, UINavigationControllerDelegate, SuitsChangedDelegate, BackgroundCellDelegate, UIPopoverPresentationControllerDelegate, TimeViewControllerDelegate, ModeSettingsCellDelegate {
    
    let settings = ["Mode","Screenshots","Background Style","Time of Prediction","Suit Order"]
    let imagePicker = UIImagePickerController()
    
    var mode: MagicSettings.Mode = .Crash
    var predictionDate: MagicSettings.Date = .TimeOfPerformance
    var images = [Int : Data]()
    var suits = ["♣️","♥️","♠️","♦️"]
    
    var magicSettings: MagicSettings? {
        get {
            return MagicSettings(mode: mode, date: predictionDate, images: images, suitOrder: suits)
        }
        set {
            if let settings = newValue {
                self.mode = settings.mode
                self.predictionDate = settings.time
                self.images = settings.images
                self.suits = settings.suitOrder
            }
            settingsTableView.reloadData()
        }
    }

    var colors = Colors.all
    
    @IBOutlet weak var settingsTableView: UITableView! {
        didSet {
            settingsTableView.delegate = self
            settingsTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let magicIsReal = getMagicFromDisk() {
            magicSettings = magicIsReal
        }
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
        if images.count == 3 {
            saveMagicToDisk(magic: magicSettings!)
        } else {
            alert("Missing Settings", message: "Check screenshot settings.")
        }
    }
    
    @IBAction func saveAndPerform(_ sender: UIButton) {
        if images.count == 3 {
            self.performSegue(withIdentifier: "perform", sender: self)
        } else {
            alert("Missing Settings", message: "Check screenshot settings.")
        }
    }
    
    private func alert(_ title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default
        ))
        present(alert, animated: true)
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
        let backgroundImage = UIImage(color: colors[index])
        if let image = backgroundImage {
            askToSave(image)
        }
    }
    
    private func askToSave(_ image: UIImage) {
        let alertMessage = UIAlertController(title: "Save image?", message: "", preferredStyle: .alert)

        let imgAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (success, error) in
                if success {
                    print("Saved!")
                    self.alert("Saved!", message: "")
                } else if let error = error {
                    print("error: \(error)")
                    self.alert("Error!", message: error.localizedDescription)
                } else {
                    print("failed :(")
                }
            }
        }
        let imageView = UIImageView(frame: CGRect(x: 16, y: 16, width: 40, height: 40))
        imageView.layer.cornerRadius = 3.0
        imageView.layer.masksToBounds = true
        imageView.image = image
        alertMessage.addAction(imgAction)
        alertMessage.view.addSubview(imageView)

        alertMessage.addAction(UIAlertAction(
            title: "No",
            style: .cancel
        ))
            
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    // MARK - TimeViewControllerDelegate
    
    func timeViewController(_ timeViewController: TimeViewController, timeMode: MagicSettings.Date) {
        self.predictionDate = timeMode
        settingsTableView.reloadData()
    }
    
    // MARK - ModeSettingsCellDelegate
    
    func modeSettingsFrom(_ tableViewCell: ModeSettingsTableViewCell, mode: MagicSettings.Mode) {
        self.mode = mode
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
                cell.delegate = self
                cell.segmentModeControl.selectedSegmentIndex = self.mode.rawValue
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
                cell.timeLabel.text = MagicData.timeOptions[predictionDate.rawValue]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
           performSegue(withIdentifier: "PopTimer", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
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

    // ideas based on:
    //https://stackoverflow.com/questions/31759615/how-to-center-a-popoverview-in-swift
    //https://stackoverflow.com/questions/31221588/why-is-present-as-popover-segue-covering-the-whole-screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopTimer" {
            let popoverViewController = segue.destination as! TimeViewController
            popoverViewController.currentMode = mode
            popoverViewController.delegate = self 
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.popoverPresentationController?.sourceView = self.view
            popoverViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
    }
    
    // MARK - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK - Persistent Magic Data
    // based on some ideas from https://medium.com/@sdrzn/networking-and-persistence-with-json-in-swift-4-c400ecab402d
    
    func getFileURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
    
    func saveMagicToDisk(magic: MagicSettings) {
        let url = getFileURL().appendingPathComponent("magic.json")
        do {
            let data = magic.json
            try data?.write(to: url, options: [])
        } catch {
            //fatalError(error.localizedDescription)
        }
    }
    
    func getMagicFromDisk() -> MagicSettings? {
        let url = getFileURL().appendingPathComponent("magic.json")
        do {
            let data = try Data(contentsOf: url, options: [])
            return MagicSettings(json: data)
        } catch {
            //fatalError(error.localizedDescription)
        }
        return nil
    }
    
}

// extension from : https://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift
public extension UIImage {
    public convenience init?(color: UIColor) {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
