//
//  QRGenerator.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/20.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class QRGenerator: NSObject {
    
    static func generate(from string: String) -> UIImage? {
        let context = CIContext()
        //        let data = string.data(using: String.Encoding.ascii)
        let data = string.data(using: String.Encoding.utf8)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            
            if let output = filter.outputImage?.transformed(by: transform), let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
