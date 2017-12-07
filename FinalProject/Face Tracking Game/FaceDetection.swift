//
//  FaceDetection.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 11/30/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage

// MARK: Delegate
@objc public protocol FaceDetectionDelegate: NSObjectProtocol {
    /* Vertical movement */
    @objc optional func faceDetection(_ faceDetection: FaceDetection, didCalibrateForNeutralRelativeVerticalEyePosition neutralPosition: Float)
     @objc optional func faceDetection(_ faceDetection: FaceDetection, didGetNewRelativeVertical eyePosition: Float)
    /* Horizontal movement */
    @objc optional func faceDetection(_ faceDetection: FaceDetection, didCalibrateForNeutralRelativeHorizontalEyePosition neutralPosition: Float)
    @objc optional func faceDetection(_ faceDetection: FaceDetection, didGetNewRelativeHorizontal eyePosition: Float)
    func hasSmile(_ faceDetection: FaceDetection, hasSmile: Bool)
    func horizontalDirection(_ faceDetection: FaceDetection, newHorizontalDirection: Float)
    func verticalDirection(_ faceDetection: FaceDetection, newVerticalDirection: Float)
}

public class FaceDetection: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public weak var delegate: FaceDetectionDelegate?
    
    private(set) var isRunning: Bool = false
    var isShouldCalibrate: Bool = false
    
    public var maxSpeed: CGFloat = 0.0
    public var deadZoneRelativeExtent: CGFloat = 0.0
    public var accelerationZoneRelativeExtent: CGFloat = 0.0
    
    var verticalOffset: Float = 0.0
    private(set) var currentVerticalSpeed: Float = 0.0
    private(set) var currentHorizontalSpeed: Float = 0.0
    // vertical ratio for which the speed is zero
    var neutralRelativeVerticalPosition: Float = 0.0
    var neutralRelativeHorizontalPosition: Float = 0.0
    
    public var captureSession: AVCaptureSession!
    var faceDetector: CIDetector!
    var lastUpdateTimestamp: CFTimeInterval = CFTimeInterval()
    
    // MARK: Intialization/Teardown
    override public init() {
        super.init()
        self.maxSpeed = 100.0
        self.neutralRelativeVerticalPosition = 0.7
        self.deadZoneRelativeExtent = 0.02
        self.accelerationZoneRelativeExtent = 0.05
    }
    deinit {
        self.stopRunning()
    }
    
    // MARK: Start / Stop
    
    public func startRunning() {
        self.isRunning = true
        self.setupFaceDetector()
        self.setupCapture()
    }
    
    func stopRunning() {
        self.isRunning = false
        self.teardownCapture()
    }
    
    // MARK: Video capture
    
    func setupCapture() {
        var _device: AVCaptureDevice!
        
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        for device in deviceDescoverySession.devices {
             _device = device
        }
       
        let captureInput = try! AVCaptureDeviceInput(device: _device)
        
        let captureOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        captureOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "cameraQueue")
        captureOutput.setSampleBufferDelegate(self, queue: queue)
        captureOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey) : Int(kCVPixelFormatType_32BGRA)]
        
        self.captureSession = AVCaptureSession()
        self.captureSession.addInput(captureInput)
        self.captureSession.addOutput(captureOutput)
        self.captureSession.canSetSessionPreset(AVCaptureSession.Preset.high)
        self.captureSession.startRunning()
    }
    
    func teardownCapture () {
        self.captureSession.stopRunning()
        self.captureSession = nil
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate) {
            let image: CIImage? = CIImage(cvPixelBuffer: pixelBuffer, options: attachments as? [String : Any])
            self.eyeTrackerFromImage(image!)
        }
    }
    
    func setupFaceDetector() {
        self.faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    }
    
    func detectFirstFaceFeatureInImage(image: CIImage) -> CIFaceFeature {
        let features = self.faceDetector.features(in: image, options: [CIDetectorImageOrientation: 6, CIDetectorSmile: true])
        if features.count > 0 {
            return features[0] as! CIFaceFeature
        }
        return CIFaceFeature()
    }
    
    func eyeTrackerFromImage(_ image: CIImage){
        // get first face feature
        let feature: CIFaceFeature? = self.detectFirstFaceFeatureInImage(image: image)
        
        // if a face feature and one of the eye position is detected
        if (feature != nil) && ((feature?.hasLeftEyePosition)! || (feature?.hasRightEyePosition)!){
            // :-)
            self.delegate?.hasSmile(self, hasSmile: (feature?.hasSmile)!)
            
            let relativeVerticalEyePosition: Float = self.relativeVerticalEyePositionFor(feature!, inImage: image)
            let relativeHorizontalEyePosition: Float = self.relativeHorizontalEyePositionFor(feature!, inImage: image)
            
            let verticalSpeed: Float = self.speedForRelativeVerticalEyePosition(relativeVerticalEyePosition)
            let horizontalSpeed: Float = self.speedForRelativeHorizontalEyePosition(relativeHorizontalEyePosition)
            
            DispatchQueue.main.async {
                self.currentVerticalSpeed = verticalSpeed
                self.currentHorizontalSpeed = horizontalSpeed
                
                if  self.isRunning {
                    self.delegate?.faceDetection?(self, didGetNewRelativeVertical: relativeVerticalEyePosition)
                    self.delegate?.faceDetection?(self, didGetNewRelativeHorizontal: relativeHorizontalEyePosition)
                    
                    if relativeHorizontalEyePosition > 0.5 {
                        self.delegate?.horizontalDirection(self, newHorizontalDirection: -1.0)
                    } else {
                        self.delegate?.horizontalDirection(self, newHorizontalDirection: 1.0)
                    }
                    
                    if relativeVerticalEyePosition > 0.62 {
                        self.delegate?.verticalDirection(self, newVerticalDirection: 1.0)
                    } else {
                        self.delegate?.verticalDirection(self, newVerticalDirection: -1.0)
                    }
                }
                
                if self.isShouldCalibrate {
                    
                    self.isShouldCalibrate = false
                    
                    self.neutralRelativeVerticalPosition = relativeVerticalEyePosition
                    self.neutralRelativeHorizontalPosition = relativeHorizontalEyePosition
                    
                    if self.isRunning {
                        self.delegate?.faceDetection?(self, didCalibrateForNeutralRelativeVerticalEyePosition: self.neutralRelativeVerticalPosition)
                        self.delegate?.faceDetection?(self, didCalibrateForNeutralRelativeHorizontalEyePosition: self.neutralRelativeHorizontalPosition)
                    }
                    
                }
                
            }
        }
    }
    
    
    // MARK: Position computations
    
    /* Vertical */
    
    func relativeVerticalEyePositionFor(_ feature: CIFaceFeature, inImage image: CIImage) -> Float {
        let leftEyePosition: CGPoint = feature.hasLeftEyePosition ? feature.leftEyePosition : feature.rightEyePosition
        let rightEyePosition: CGPoint = feature.hasRightEyePosition ? feature.rightEyePosition : feature.leftEyePosition
        let averagePosition: CGPoint = CGPoint(x: leftEyePosition.x+(rightEyePosition.x-leftEyePosition.x)/2.0, y: leftEyePosition.x+(rightEyePosition.y - leftEyePosition.y)/2.0)
        
        return Float(averagePosition.y)/Float(image.extent.size.width)
    }
    
    func speedForRelativeVerticalEyePosition(_ position: Float) -> Float {
        var speedRatio: CGFloat = CGFloat(position - self.neutralRelativeVerticalPosition)/self.accelerationZoneRelativeExtent
        let absSpeedRatio: CGFloat = fabs(speedRatio)
        let maxTreshold: CGFloat = 1.0
        let minTreshold: CGFloat = self.deadZoneRelativeExtent/self.accelerationZoneRelativeExtent
        
        speedRatio = (absSpeedRatio<minTreshold) ? 0 : (absSpeedRatio>maxTreshold ? (speedRatio/absSpeedRatio) : speedRatio)
        return Float(speedRatio) * Float(self.maxSpeed)
    }
    
    /* Horizontal */
    
    func relativeHorizontalEyePositionFor(_ feature: CIFaceFeature, inImage image: CIImage) -> Float {
        let leftEyePosition: CGPoint = feature.hasLeftEyePosition ? feature.leftEyePosition : feature.rightEyePosition
        let rightEyePosition: CGPoint = feature.hasRightEyePosition ? feature.rightEyePosition : feature.leftEyePosition
        let averagePosition: CGPoint = CGPoint(x: leftEyePosition.y+(rightEyePosition.y-leftEyePosition.y)/2.0, y: leftEyePosition.y+(rightEyePosition.x - leftEyePosition.x)/2.0)
        return Float(averagePosition.x)/Float(image.extent.size.height)
    }
    
    func speedForRelativeHorizontalEyePosition(_ position: Float) -> Float {
        var speedRatio: CGFloat = CGFloat(position - self.neutralRelativeHorizontalPosition)/self.accelerationZoneRelativeExtent
        let absSpeedRatio: CGFloat = fabs(speedRatio)
        let maxTreshold: CGFloat = 1.0
        let minTreshold: CGFloat = self.deadZoneRelativeExtent/self.accelerationZoneRelativeExtent
       
        speedRatio = (absSpeedRatio<minTreshold) ? 0 : (absSpeedRatio>maxTreshold ? (speedRatio/absSpeedRatio) : speedRatio)
        return Float(speedRatio) * Float(self.maxSpeed)
    }
}

