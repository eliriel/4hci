//
//  ProvideObservationController.swift
//  MedReminder
//
//  Created by Borislav Hristov on 27.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

class ProvideObservationController: BasicController {
    @IBOutlet weak var imgQRCode: UIImageView!
    var qrcodeImage: CIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = MedReminder.getInstance().getUser()
        var data = [String: String]()
        
        data["names"] = user.names ?? "undefined"
        data["number"] = user.number ?? "undefined"
        data["token"] = user.token ?? "undefined"
        
        let encrypted = MedReminder.toJSonString(data: data)
        
        let encryptedData = encrypted.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(encryptedData, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        
        let scaleX = imgQRCode.frame.size.width / (filter?.outputImage?.extent.size.width)!
        let scaleY = imgQRCode.frame.size.height / (filter?.outputImage?.extent.size.height)!
        
        let transformedImage = filter?.outputImage?.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        qrcodeImage = transformedImage
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imgQRCode.image = UIImage(ciImage: self.qrcodeImage)
    }
    
}
