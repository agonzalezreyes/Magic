////
////  SecondViewController.swift
////  FinalProject
////
////  Created by Alejandrina Gonzalez on 12/3/17.
////  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
////
//
//import UIKit
//import MapKit
//
////IGNORE THIS FILE
//
//class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    @IBOutlet weak var map: MKMapView!
//    @IBOutlet weak var levelsCollectionView: UICollectionView! {
//        didSet {
//            levelsCollectionView.delegate = self
//            levelsCollectionView.dataSource = self
//        }
//    }
//    
//   // var levels: [Level]!
//    
//    @IBOutlet weak var segmentControl: UISegmentedControl! {
//        didSet {
//            segmentControl.addTarget(self, action: #selector(changeView), for: .touchUpInside)
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if UserDefaults.standard.bool(forKey: "hasLaunched") {// get data previosuly saved
//            
//        } else {
//            UserDefaults.standard.set(true, forKey: "hasLaunched") // get data from initial json
//            UserDefaults.standard.synchronize()
//            
//            if let path = Bundle.main.url(forResource: "Levels", withExtension: "json") {
//                do {
//                    let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
//                    //let dict = try JSONDecoder().decode([Level].self, from: jsonData)
//                    levels = dict
//                    
//                } catch let error as NSError {
//                    print("Error: \(error)")
//                }
//            }
//            
//        }
//        
//       
//    }
//    
//    @objc private func changeView() {
//        if segmentControl.selectedSegmentIndex == 0 {
//            levelsCollectionView.isHidden = false
//            map.isHidden = true
//        } else {
//            levelsCollectionView.isHidden = true
//            map.isHidden = false
//        }
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 6
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LevelCollectionViewCell
//        cell.image.image = #imageLiteral(resourceName: "question_mark")
//        cell.titleLabel.text = "\(indexPath.row)"
//        return cell
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//
//}

