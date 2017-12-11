//
//  MagicViewController.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/5/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit
import Photos

class MagicViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, MagicResultDelegate {
    
    private var magicPageViewController: UIPageViewController?
    private var realMagicData: [[String]] = [[String]]()
    var magicalImages: [UIImage] = [UIImage]()
    var suitOder = [String]()
    var mode: MagicSettings.Mode = .Crash
    var predictionDate: MagicSettings.Date = .TimeOfPerformance

    private var pageControl = UIPageControl()
    private var bottomImage: UIImageView!
    private var statusImage: UIImageView!
    private var controlImage: UIImageView!
    private var houdini: UIImageView!
    private var magicResult = MagicResult() {
        didSet {
            if let label = cardInfoLabel {
                label.text = "\(magicResult.cardFileName())"
            }
        }
    }
    private var suitData = [String]()
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardViewBehavior(in: animator)
    private var cardInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        for i in suitOder {
            for _ in 0...3{
                suitData.append(i)
            }
        }
        print(suitData)
         // ✨
        realMagicData =  [["this line is just a placeholder for crash screen"],
                          MagicData.cardNumbers,
                          suitData]
        
        let mostMagicalImage = magicalImages[0]
        let houdiniImage = getColorImage(from: mostMagicalImage)
        
        houdini = UIImageView(frame: self.view.frame)
        houdini.image = houdiniImage
        view.addSubview(houdini)
        
        let magicPageVC = self.storyboard!.instantiateViewController(withIdentifier: "MagicPageViewController") as! UIPageViewController
        magicPageVC.dataSource = self
        magicPageVC.delegate = self
        if realMagicData.count > 0 {
            let firstMagicController = getItemController(at: realMagicData.count - 1)!//realMagicData.count - 1
            let firstMagicViewController = [firstMagicController]
            magicPageVC.setViewControllers(firstMagicViewController,
                                           direction: .reverse,
                                           animated: false,
                                           completion: nil)
        }
        magicPageViewController = magicPageVC
        addChildViewController(magicPageViewController!)
        view.addSubview(magicPageViewController!.view)
        magicPageViewController!.didMove(toParentViewController: self)
        
        addMagic()
        
        cardInfoLabel = UILabel(frame: CGRect(x: 100, y: 5, width: 70, height: 10))
        cardInfoLabel.adjustsFontSizeToFitWidth = true
        cardInfoLabel.font = UIFont(name: "Helvetica", size: 10.0)
        self.view.addSubview(cardInfoLabel)
    }
    
    func magicIndex(_ magicItemViewController: MagicItemViewController, index result: Int) {
        let index = currentControllerIndex()
        switch index {
        case 2:
            let suit = suitData[result]
            magicResult.suit = "\(suit)"
            print(suit)
        case 1:
            let num = MagicData.cardNumbers[result]
            magicResult.number = "\(num)"
            print(num)
        default:
            print("nothing")
        }
    }

    private func image() -> UIImage {
        return UIImage(named: magicResult.cardFileName())!
    }
    
    private func saveAndCrash(){
        print("saveAndCrash")
        saveImage(image())
    }
    
    private func saveImage(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            request.creationDate = self.getCreationDate() // MAGIC PREDICTION
        }) { (success, error) in
            if success {
                print("Saved!")
                fatalError()// YAY WE CRASH OUR OWN APP FOR THE SAKE OF MAGIC ✨
            } else if let error = error {
                print("error: \(error)")
            } else {
                print("failed :(")
            }
        }
    }
    
    private func animateAndCrash() {
        print("animateAndCrash")
        let imageCard = image()
        let cardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        cardImageView.center = self.view.center
        cardImageView.image = imageCard
        self.view.addSubview(cardImageView)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3.0, delay: 0, options: [], animations: {
            cardImageView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        }) { (position) in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 6.0, delay: 0, options: [], animations: {
                self.cardBehavior.addItem(cardImageView)
            }, completion: { (position) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
                    self.cardBehavior.removeItem(cardImageView)
                    self.saveImage(imageCard)
                })
            })
        }
    }
    
    
    func getCreationDate() -> Date {
        let rightNow = Date()
        var date = rightNow
        switch predictionDate {
        case .TimeOfPerformance:
            date = rightNow
        case .OneHourAgo:
            date = rightNow.addingTimeInterval(-3600)
        case .TwoHoursAgo:
            date = rightNow.addingTimeInterval(-3600)
        case .OneDayAgo:
            date = rightNow.addingTimeInterval(-86400.0)
        case .OneWeekAgo:
            date = rightNow.addingTimeInterval(-1209600.0)
        case .OneMonthAgo:
            date = rightNow.addingTimeInterval(-5259487.66)
        case .Custom:
            let defaults = UserDefaults.standard
            date = defaults.object(forKey: "custom") as! Date
        }
        return date
    }
    
    private func addMagic(){
        
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        let mostMagicalImage = magicalImages[0]
        let houdiniImage = getColorImage(from: mostMagicalImage)
        
        statusImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        statusImage.image = houdiniImage
        view.addSubview(statusImage)
        
        controlImage = UIImageView(frame: CGRect(x: 0, y: height - 128, width: width, height: 50))
        controlImage.image = houdiniImage
        view.addSubview(controlImage)
        
        pageControl = UIPageControl(frame: CGRect(x: 0,y: height - 140, width: width,height: 50))
        pageControl.numberOfPages = realMagicData.count + 1
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.currentPage = realMagicData.count
        view.addSubview(pageControl)
        
        
        bottomImage = UIImageView()
        bottomImage.frame = CGRect(x: 0, y: height - height/7, width: width, height: height/7)
        bottomImage.image = imageBottom(from: mostMagicalImage)
        bottomImage.backgroundColor = .white
        view.addSubview(bottomImage)
    }
    
    private func imageBottom(from image: UIImage) -> UIImage {
        let imgWidth = image.size.width
        let imgHeight = image.size.height / 7
        let cutRect = CGRect(x: 0, y: image.size.height - imgHeight, width: imgWidth, height: imgHeight)
        let bottomImage = image.cgImage?.cropping(to: cutRect)
        let cutImage = UIImage(cgImage: bottomImage!)
        return cutImage
    }
    
    private func getColorImage(from image: UIImage) -> UIImage {
        let imgWidth = image.size.width
        let imgHeight = image.size.height
        let cutRect = CGRect(x: 0.0, y: Double(imgHeight - imgHeight/7 - 4), width: Double(imgWidth), height: 3.0)
        let img = image.cgImage?.cropping(to: cutRect)
        let cutImage = UIImage(cgImage: img!)
        return cutImage
    }
    
    private func getItemController(at index: Int) -> MagicItemViewController? {
        
        if index < realMagicData.count {
            let magicItemController = self.storyboard!.instantiateViewController(withIdentifier: "MagicItemController") as! MagicItemViewController
            magicItemController.delegate = self
            magicItemController.magicIndex = index
            magicItemController.magicData = realMagicData[index]
            magicItemController.magicImageBackground = magicalImages[index]
            return magicItemController
        }
        return nil
    }
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let magicItemController = viewController as! MagicItemViewController
        
        if magicItemController.magicIndex > 0 {
            return getItemController(at: magicItemController.magicIndex - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let magicItemController = viewController as! MagicItemViewController
        if magicItemController.magicIndex+1 < realMagicData.count {
            return getItemController(at: magicItemController.magicIndex+1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = currentControllerIndex()
        if index == 0 { // we reached the end, here we decide what to do with the card
            if mode == .Crash {
                saveAndCrash()
            } else if mode == .AnimateCrash {
                animateAndCrash()
            }
        }
        pageControl.currentPage = index + 1
    }
    
    func currentControllerIndex() -> Int {
        let magicItemController = self.currentController()
        if let controller = magicItemController as? MagicItemViewController {
            return controller.magicIndex
        }
        return -1
    }
    
    func currentController() -> UIViewController? {
        if (self.magicPageViewController?.viewControllers?.count)! > 0 {
            return self.magicPageViewController?.viewControllers![0]
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return realMagicData.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
