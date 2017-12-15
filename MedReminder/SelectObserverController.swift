//
//  SelectObserverController.swift
//  MedReminder
//
//  Created by Borislav Hristov on 27.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SelectObserver: BasicController, AVCaptureMetadataOutputObjectsDelegate{
    var side = true
    var crp: CreateReminderProtocol?
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input: AnyObject! = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input as! AVCaptureInput)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            
            
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView?.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView!)
            view.bringSubview(toFront: qrCodeFrameView!)
            //view.bringSubviewToFront(messageLabel)
        } catch let error{
            print ("\(error.localizedDescription)")
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let create = self.crp else {
            self.pop()
            return
        }

        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect()
            print ("No QR code is detected")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                let user = MedReminder.fromJSonString(data: metadataObj.stringValue!)
                
                if self.side{
                    create.updateObserverA(user)
                } else {
                    create.updateObserverB(user)
                }
            }
        }
        
        self.pop()
    }
    
    func pop(){
        _ = navigationController?.popViewController(animated: true)
    }
}
