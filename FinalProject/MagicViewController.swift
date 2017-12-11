//
//  MagicViewController.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/5/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

class MagicViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, MagicResultDelegate {
    
    private var magicPageViewController: UIPageViewController?
    private var realMagicData: [[String]] = [[String]]()
    private var magicalImages: [UIImage] = [UIImage]()
    private var imagesNames = ["3.PNG","2.PNG","1.PNG"]
    private var pageControl = UIPageControl()
    private var bottomImage: UIImageView!
    private var statusImage: UIImageView!
    private var controlImage: UIImageView!
    private var houdini: UIImageView!
    private var magicResult = MagicResult(with: ".PNG")
    
    // modified and updated to swift 4.0 from https://gist.github.com/kkleidal/73401405f7d5fd168d061ad0c154ea18
    private var xifDateFormatter: DateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy:MM:dd' 'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // ✨
        realMagicData =  [MagicData.crashData,
                          MagicData.cardNumbers,
                          MagicData.suits]
        for i in imagesNames {
            magicalImages.append(UIImage(named: i)!)
        }
        
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
    }
    
    func magicIndex(_ magicItemViewController: MagicItemViewController, index result: Int) {
        let index = currentControllerIndex()
        switch index {
        case 2:
            let suit = MagicData.suits[result]
            magicResult.number = "\(suit)"
        case 1:
            let num = MagicData.cardNumbers[result]
            magicResult.number = "\(num)"
        default:
            print("crash")
        }
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
