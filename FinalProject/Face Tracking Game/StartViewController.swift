//
//  ViewController.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 11/30/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController, FaceDetectionDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var tracker: FaceDetection!
    @IBOutlet weak var emojiView: BlurryView!
    @IBOutlet var starViews: [UIImageView]! // outlet collection
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var hasSmiledOnce = false
    private var isBlinking: Bool = false
    private let starSound = URL(fileURLWithPath: Bundle.main.path(forResource: "coin", ofType: "wav")!)
    private var audioPlayer: AVAudioPlayer!
    private var starCount: Int! {
        get {
            var num: Int = 0
            for view in starViews {
                if !view.isHidden {
                    num += 1
                }
            }
            return num
        }
    }
    private var isSmiling: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if !self.emojiView.emojiLabel.isHidden {
                    self.activityIndicator.stopAnimating()
                    for view in self.starViews {
                        view.alpha = 1.0
                    }
                }
                self.emojiView.emojiLabel.text = self.isSmiling ? "😀" : "😐"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: starSound)
            audioPlayer.prepareToPlay()
        } catch {
            print("can't play sound")
        }
        
        tracker = FaceDetection()
        tracker.delegate = self
        tracker.startRunning()

        let v = UIView(frame: self.view.frame)
        let captureLayer = AVCaptureVideoPreviewLayer(session: tracker.captureSession)
        captureLayer.frame = self.view.frame
        v.layer.addSublayer(captureLayer)
        
        self.view.addSubview(v)
        self.view.addSubview(emojiView)
        
        for view in starViews {
            self.emojiView.addSubview(view)
            view.alpha = 0.0
        }
   
        self.emojiView.addSubview(activityIndicator)
        
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(check), userInfo: nil, repeats: true)
       // self.gameDone() // for testing
    }

    private func gameDone(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.performSegue(withIdentifier: "nextVC", sender: self)
        }
    }
    
    @objc func check(){
        if starCount == 0 { self.gameDone() }
        
        DispatchQueue.main.async {
            
            for view in self.starViews {
                let isPointInFrame = self.emojiView.emojiLabel.frame.contains(view.center)
                if  isPointInFrame && self.isSmiling {
                    view.isHidden = true
                    if let audio = self.audioPlayer {
                        audio.play()
                    }
                }
            }

        }
        
        if isBlinking {
            for view in starViews {
                view.alpha = 0.0
            }
        } else {
            for view in starViews {
                view.alpha = 1.0
            }
        }
        isBlinking = !isBlinking
    }
    
    func hasSmile(_ faceDetection: FaceDetection, hasSmile: Bool) {
        if hasSmile { hasSmiledOnce = true }
        isSmiling = hasSmile
    }
    
    func horizontalDirection(_ faceDetection: FaceDetection, newHorizontalDirection: Float) {
        if hasSmiledOnce {
            DispatchQueue.main.async {
                self.emojiView.emojiLabel.center.x += CGFloat(newHorizontalDirection)*CGFloat(5.0)
            }
        }
    }
    func verticalDirection(_ faceDetection: FaceDetection, newVerticalDirection: Float) {
        if hasSmiledOnce {
            DispatchQueue.main.async {
                self.emojiView.emojiLabel.center.y += CGFloat(newVerticalDirection)*CGFloat(5.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
