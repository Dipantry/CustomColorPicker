//
//  ColorPickerImageView.swift
//  CustomColorPicker
//
//  Created by Auriga Aristo on 20/12/20.
//

import UIKit

protocol ColorPickerImageViewDelegate {
    func didPickColor(with color: UIColor, in imageView: UIImageView)
}

class ColorPickerImageView: UIImageView {
    var pickerStartPoint: CGPoint = CGPoint(x: 0, y: 0){
        didSet {
            
        }
    }
}

extension UIColor {
    
}
