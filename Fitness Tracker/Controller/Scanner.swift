//
//  Scanner.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 18.8.22.
//

import Foundation
import AVFoundation
import UIKit

class Scanner: NSObject {
    
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession?
    private var outputHandler: (_ code: String) -> Void
    
    init(withViewController viewController: UIViewController, view: UIView,
         codeOutputHandler: @escaping (String) -> Void) {
        self.viewController = viewController
        self.outputHandler = codeOutputHandler
        super.init()
        
        if let captureSession = self.createCaptureSession() {
            self.captureSession = captureSession
            let previewLayer = self.createPreviewLayer(withCaptureSession: captureSession, view: view)
            view.layer.addSublayer(previewLayer)
        }
    }
    
    func createCaptureSession() -> AVCaptureSession? {
        
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metadataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            } else {
                return nil
            }
            
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                
                if let viewController = self.viewController as? AVCaptureMetadataOutputObjectsDelegate {
                    metadataOutput.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = self.metaObjectTypes()
                }
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
        return captureSession
    }
    
    func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [.qr,
                .code128,
                .code39,
                .code39Mod43,
                .code93,
                .ean8,
                .ean13,
                .interleaved2of5,
                .itf14,
                .pdf417,
                .upce
        ]
    }
    
    func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession, view: UIView) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
    
    // Start session
    func requestCaptureSessionStartRunning() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    // Stop session
    func requestCaptureSessionStopRunning() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func scannerDelegate(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
                         from connection: AVCaptureConnection) {
        self.requestCaptureSessionStopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            guard let stringValue = readableObject.stringValue else {
                return
            }
            
            self.outputHandler(stringValue)
        }
    }
   
}
