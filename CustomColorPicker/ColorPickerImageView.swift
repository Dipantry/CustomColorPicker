//
//  ColorPickerImageView.swift
//  CustomColorPicker
//
//  Created by Auriga Aristo on 20/12/20.
//

import UIKit

protocol ColorPickerImageViewDelegate: class {
    func didPickColor(with color: UIColor, in imageView: UIImageView)
}

class ColorPickerImageView: UIImageView {
    var pickerStartPoint: CGPoint = CGPoint(x: 0, y: 0){
        didSet {
            pickerView.frame.origin = pickerStartPoint
        }
    }
    
    weak var delegate: ColorPickerImageViewDelegate?
    
    private lazy var pickerView: UIView = {
        let view = UIView(frame: CGRect(origin: pickerStartPoint, size: CGSize(width: 50, height: 50)))
        view.layer.cornerRadius = view.frame.width * 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.contentsScale = UIScreen.main.scale
        
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        addSubview(pickerView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        pickerColor(at: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if self.bounds.contains(location) {
            pickerColor(at: location)
        }
    }

    func pickerColor(at point: CGPoint) {
        UIView.animate(withDuration: 0.1) {
            self.pickerView.center = point
        }
        guard let convertPoint = image?.convert(viewPoint: point, for: self),
            let color = image?.pickColor(for: convertPoint)
            else { return }
        
        pickerView.backgroundColor = color
        delegate?.didPickColor(with: color, in: self)
    }
}

extension UIImage {
    func pickColor(for point: CGPoint) -> UIColor? {
        let cgImage = self.cgImage
        let colorSpace: CGFloat = 255.0
        guard let width = cgImage?.width,
            let height = cgImage?.height
            else {
                return nil
        }
        let x: Int = Int(floor(point.x) * self.scale)
        let y: Int = Int(floor(point.y) * self.scale)
        
        if (x < width) && (y < height) {
            guard let provider = cgImage?.dataProvider,
                let bitmapData = provider.data,
                let data = CFDataGetBytePtr(bitmapData)
                else { return nil }
            
            let offset = ((width * y) + x) * 4
            
            let red = CGFloat(data[offset])
            let green = CGFloat(data[offset + 1])
            let blue = CGFloat(data[offset + 2])
            let alpha = CGFloat(data[offset + 3])
            
            return UIColor(red: red/colorSpace, green: green/colorSpace, blue: blue/colorSpace, alpha: alpha/colorSpace)
        }
        
        return nil
    }
    
    func convert(viewPoint: CGPoint, for imageView: UIImageView) -> CGPoint {
        var imagePoint = viewPoint
        let imageSize = size
        let viewSize = imageView.bounds.size
        
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        
        switch imageView.contentMode {

        case .topLeft:
            break
        case .scaleAspectFit, .scaleAspectFill:
            let scale = imageView.contentMode == .scaleAspectFit ? min(ratioX, ratioY) : max(ratioX, ratioY)
            
            // Remove the x or y margin added in FitMode
            imagePoint.x -= (viewSize.width - imageSize.width * scale) / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height * scale) / 2.0
            
            imagePoint.x /= scale
            imagePoint.y /= scale
 
        case .redraw, .scaleToFill:
            imagePoint.x /= ratioX
            imagePoint.y /= ratioY
        case .center:
            imagePoint.x -= (viewSize.width - imageSize.width) / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .top:
            imagePoint.x -= (viewSize.width - imageSize.width) / 2.0
        case .bottom:
            imagePoint.x -= (viewSize.width - imageSize.width) / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height)
        case .left:
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .right:
            imagePoint.x -= (viewSize.width - imageSize.width)
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .topRight:
            imagePoint.x -= (viewSize.width - imageSize.width)
        case .bottomLeft:
            imagePoint.y -= (viewSize.height - imageSize.height)
        case .bottomRight:
            imagePoint.x -= (viewSize.width - imageSize.width)
            imagePoint.y -= (viewSize.height - imageSize.height)
        @unknown default:
            fatalError()
        }
        
        return imagePoint
    }
}
