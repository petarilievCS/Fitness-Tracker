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
    private var codeOutputHandler: (_ code: String) -> Void 
    
}
