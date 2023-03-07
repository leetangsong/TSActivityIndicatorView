//
//  TSActivityIndicatorAnimationAudioEqualizer.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 2023/3/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#if canImport(UIKit)
import UIKit
class TSActivityIndicatorAnimationAudioEqualizer: TSActivityIndicatorAnimationable {
    
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSize = size.width / 9
        let x = (layer.bounds.size.width - lineSize * 7) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: [CFTimeInterval] = [1, 2.5, 1.5, 1]
        let values = [
            [0.1, 0.5, 0.1],
            [0, 0.7, 0.4, 0.05, 0.95, 0.3, 0.9, 0.4, 0.15, 0.18, 0.75, 0.01],
            [0.2, 0.7, 0.4, 0.2, 0.5, 0.15],
            [0, 0.7, 0.4, 0.05, 0.95, 0.3, 0.01]
        ]
        
        // Draw lines
        for i in 0 ..< 4 {
            let animation = CAKeyframeAnimation()

            animation.keyPath = "path"
            animation.isAdditive = true
            animation.values = []

            for j in 0 ..< values[i].count {
                let heightFactor = values[i][j]
                let height = size.height * CGFloat(heightFactor)
                let point = CGPoint(x: 0, y: size.height - height)
                let path = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: lineSize, height: height)))

                animation.values?.append(path.cgPath)
            }
            animation.duration = duration[i]
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false

            let line = TSActivityIndicatorShape.line.layerWith(size: CGSize(width: lineSize, height: size.height), color: .red)
            let frame = CGRect(x: x + lineSize * 2 * CGFloat(i),
                               y: y,
                               width: lineSize,
                               height: size.height)

            line.frame = frame
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
}


#endif
