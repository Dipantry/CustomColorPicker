//
//  ViewController.swift
//  CustomColorPicker
//
//  Created by Auriga Aristo on 20/12/20.
//

import UIKit

class ViewController: UIViewController, ColorPickerImageViewDelegate {
    
    @IBOutlet weak var imageView: ColorPickerImageView!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.delegate = self
    }
    
    func didPickColor(with color: UIColor, in imageView: UIImageView) {
        colorView.backgroundColor = color
    }
}

