//
//  ImageViewExt.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/2.
//  Copyright © 2020 maichao. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func setImage(urlStr: String?, placeholder: UIImage? = placeholder_square) {
        if let url = urlStr {
            sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: .retryFailed, context: nil)
        } else {
            image = placeholder
        }
    }
}
