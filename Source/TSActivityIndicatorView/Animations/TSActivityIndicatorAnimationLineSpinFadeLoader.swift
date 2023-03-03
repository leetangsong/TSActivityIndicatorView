//
//  TSActivityIndicatorAnimationLineSpinFadeLoader.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 2023/2/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#if canImport(UIKit)
import UIKit
class TSActivityIndicatorAnimationLineSpinFadeLoader: TSActivityIndicatorAnimationable {

    var duration: CFTimeInterval
    
    var lineCount: Int
    
    var innerScale: CGFloat
    init(lineCount: Int = 8, innerScale: CGFloat = 0.35, duration: CFTimeInterval = 1.2) {
        self.lineCount = lineCount
        self.duration = duration
        self.innerScale = innerScale
    }
    
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let width = size.width*(1-innerScale)/2
        let lineSpacing: CGFloat = 2
        let lineSize = CGSize(width: (size.width - 4 * lineSpacing) / 5, height: (size.height - 2 * lineSpacing) / 3)
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let beginTime = CACurrentMediaTime()
        let off = duration/Double(lineCount + 2)
        var beginTimes: [CFTimeInterval] = []
        for i in 0..<lineCount{
            beginTimes.append(off * Double(i+1))
        }
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "opacity")

        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw lines
        for i in 0 ..< lineCount {
            let line = lineAt(angle: CGFloat(Double.pi / (Double(lineCount) / 2) * Double(i)),
                              size: lineSize,
                              origin: CGPoint(x: x, y: y),
                              containerSize: size,
                              color: color)

            animation.beginTime = beginTime + beginTimes[i]
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
    
    
    func lineAt(angle: CGFloat, size: CGSize, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2
        let line = TSActivityIndicatorShape.line.layerWith(size: size, color: color)
        var lineFrame = CGRect.init(x: origin.x-size.width/2, y: 0, width: size.width, height: size.height)
        lineFrame.origin.x += radius * (sin(angle)+1)
        lineFrame.origin.y += radius * (1 - cos(angle))
        line.frame = lineFrame
//        line.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        return line
    }
}

#endif
