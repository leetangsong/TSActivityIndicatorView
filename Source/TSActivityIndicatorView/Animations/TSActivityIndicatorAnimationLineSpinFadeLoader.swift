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
    
    var lineSpacing: CGFloat
    
    var innerScale: CGFloat
    
    init(lineCount: Int = 8, lineSpacing: CGFloat = 2, innerScale: CGFloat = 0.4, duration: CFTimeInterval = 1.2) {
        self.lineCount = lineCount
        self.duration = duration
        self.innerScale = innerScale
        self.lineSpacing = lineSpacing
    }
    
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let height = size.height*(1-innerScale)/2
        let lineSize = CGSize(width: (size.width - CGFloat(lineCount) / 2 * lineSpacing) / (CGFloat(lineCount) / 2 + 1), height: height)
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
        animation.values = [1, 0.1, 1]
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
        var lineFrame = CGRect.init(x: origin.x+radius-size.width/2, y: 0, width: size.width, height: size.height)
        let distance = radius - size.height/2
        lineFrame.origin.x += distance * sin(angle)
        lineFrame.origin.y += distance * (1-cos(angle))
        line.frame = lineFrame
        line.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        return line
    }
}

#endif
