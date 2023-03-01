//
//  TSActivityIndicatorShape.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 2023/2/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#if canImport(UIKit)
import UIKit

enum TSActivityIndicatorShape {
    case line
    
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        
        switch self {
        case .line:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                cornerRadius: size.width / 2)
            layer.fillColor = color.cgColor
        }
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }

}

#endif
