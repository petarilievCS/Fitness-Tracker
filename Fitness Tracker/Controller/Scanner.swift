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
}
