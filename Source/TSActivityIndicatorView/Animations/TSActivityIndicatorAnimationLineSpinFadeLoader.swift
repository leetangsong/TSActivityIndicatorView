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
        duration = 5
        let lineSpacing: CGFloat = 2
        let lineSize = CGSize(width: (size.width - 4 * lineSpacing) / 5, height: (size.height - 2 * lineSpacing) / 3)
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1.2
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84, 0.96]
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
        for i in 0 ..< 8 {
            let line = lineAt(angle: CGFloat(Double.pi / 4 * Double(i)),
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
        let radius = containerSize.width / 2 - max(size.width, size.height) / 2
        let lineContainerSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
        let lineContainer = CALayer()
        let lineContainerFrame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: lineContainerSize.width,
            height: lineContainerSize.height)
        let line = TSActivityIndicatorShape.line.layerWith(size: size, color: color)
        let lineFrame = CGRect(
            x: (lineContainerSize.width - size.width) / 2,
            y: (lineContainerSize.height - size.height) / 2,
            width: size.width,
            height: size.height)

        lineContainer.frame = lineContainerFrame
        line.frame = lineFrame
        lineContainer.addSublayer(line)
        lineContainer.sublayerTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 2) + angle, 0, 0, 1)

        return lineContainer
    }
}

#endif
