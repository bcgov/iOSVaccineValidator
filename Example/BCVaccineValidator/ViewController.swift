//
//  ViewController.swift
//  BCVaccineValidator
//
//  Created by amirshayegh on 11/02/2021.
//  Copyright (c) 2021 amirshayegh. All rights reserved.
//

import UIKit
import BCVaccineValidator

import UIKit
import BCVaccineValidator
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: Variables
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var codeHighlightTags: [Int] = []
    fileprivate var invalidScannedCodes: [String] = []
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.showCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            pauseCamera()
        }
    }
    
    private func reStartCamera() {
        DispatchQueue.main.async {
            self.setupCaptureSession()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) { [weak self] in
                guard let `self` = self else {return}
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func showCamera() {
        self.reStartCamera()
    }

    
    // MARK: Camera Permissions
    func isCameraUsageAuthorized()-> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined, .denied:
            return false
        case .restricted,.authorized:
            return true
        @unknown default:
            return false
        }
    }
    
    func askForCameraPermission(completion: @escaping(Bool)-> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {(granted: Bool) in
            DispatchQueue.main.async {
                return completion(granted)
            }
        })
    }
    
}

// MARK: Camera
extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    private func removeCameraPreview() {
        if let existingPreview = self.previewLayer {
            existingPreview.removeFromSuperlayer()
            self.previewLayer = nil
        }
        
        if let existingSession = self.captureSession {
            existingSession.stopRunning()
            captureSession = nil
        }
    }
    
    // MARK: Setup
    private func setupCaptureSession() {
        
        removeCameraPreview()
        
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        // Setup Video input
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        // Setup medatada delegate to capture QR codes
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        // Setup Preview
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.frame = self.view.layer.bounds
        preview.videoGravity = .resizeAspectFill
        preview.isAccessibilityElement = true
        
        self.view.layer.addSublayer(preview)
        self.previewLayer = preview
        
        // Begin Capture Session
        captureSession.startRunning()
    }
    
    
    /// Medatada Delegate function - called when a QR is found
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Remove boxes for previous qr codes
        clearQRCodeLocations()
        
        // get data from single code in view
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue
        else {
            return
        }
        if !invalidScannedCodes.contains(stringValue) {
            validate(code: stringValue, object: metadataObject)
        } else {
            showQRCodeLocation(for: metadataObject, isInValid: true, tag: 100)
        }
    }
    
    fileprivate func validate(code: String, object: AVMetadataObject) {
        pauseCamera()
        BCVaccineValidator.shared.validate(code: code) { [weak self] result in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                guard let data = result.result, result.status == .ValidCode else {
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    self.showQRCodeLocation(for: object, isInValid: true, tag: 1001)
                    self.invalidScannedCodes.append(code)
                    self.startCamera()
                    return
                }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.showQRCodeLocation(for: object, isInValid: false, tag: 1001)
                print(data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.startCamera()
                }
            }
        }
    }
    
    public func startCamera() {
        DispatchQueue.main.async {
            self.clearQRCodeLocations()
            self.captureSession?.startRunning()
        }
    }
    
    public func pauseCamera() {
        captureSession?.stopRunning()
    }
    
    fileprivate func showQRCodeLocation(for object: AVMetadataObject, isInValid: Bool, tag: Int) {
        guard let preview =  previewLayer, let metadataLocation = preview.transformedMetadataObject(for: object) else {
            return
        }
        if let existing = view.viewWithTag(tag) {
            existing.removeFromSuperview()
        }
        let container = UIView(frame: metadataLocation.bounds)
        container.tag = tag
        container.layer.borderWidth =  2
        container.layer.borderColor = isInValid ? UIColor.red.cgColor : UIColor.green.cgColor
        container.layer.cornerRadius =  8
        container.backgroundColor = .clear
        
        codeHighlightTags.append(tag)
        view.addSubview(container)
    }
    
    fileprivate func clearQRCodeLocations() {
        for tag in codeHighlightTags {
            if let box = view.viewWithTag(tag) {
                box.removeFromSuperview()
            }
        }
    }
    
}
