//
//  File.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 2023/3/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit

class TSActivityIndicatorAnimationAweme: TSActivityIndicatorAnimationable {
    
    private let duration = 5.0
    
    private let keyTimes: [NSNumber] = [0, 0.2, 0.4, 0.6, 0.8, 1]
    private var displayLink: CADisplayLink?
    
    private var redBall: CALayer!
    
    private var greenBall: CALayer!
    
    private var whiteBall: CALayer!
    
    private var bottomBall: CALayer!
    
    private var redShapeLayer: CALayer!
        
    var animationLayers: [CALayer] = []
    var ballWidth: CGFloat
    
    init(ballWidth: CGFloat) {
        self.ballWidth = ballWidth
    
    }
    
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSize: CGFloat = min(ballWidth, size.width)
        
        bottomBall = CALayer()
        bottomBall.cornerRadius = circleSize/2
        
        redBall = TSActivityIndicatorShape.circle.layerWith(size: CGSize.init(width: circleSize, height: circleSize), color: UIColor.init(red: 227/255.0, green: 80/255.0, blue: 101/255.0, alpha: 1))
        redBall.cornerRadius = circleSize/2
        redBall.masksToBounds = true
        
        greenBall = TSActivityIndicatorShape.circle.layerWith(size: CGSize.init(width: circleSize, height: circleSize), color: UIColor.init(red: 133/255.0, green: 242/255.0, blue: 239/255.0, alpha: 1))
        greenBall.cornerRadius = circleSize/2
        
        whiteBall = CALayer()
        whiteBall.backgroundColor = UIColor.white.cgColor
        whiteBall.cornerRadius = circleSize/2
        whiteBall.masksToBounds = true
        
        
        redShapeLayer = CALayer()
//        redShapeLayer.backgroundColor =
        
        bottomBall.frame = CGRect.init(x: (layer.frame.size.width-circleSize)/2, y: (layer.frame.size.height-circleSize)/2, width: circleSize, height: circleSize)
        redBall.frame = CGRect.init(x: circleSize/2, y: 0, width: circleSize, height: circleSize)
        greenBall.frame = CGRect.init(x: -circleSize/2, y: 0, width: circleSize, height: circleSize)
        whiteBall.frame = CGRect.init(x: 0, y: 0, width: circleSize, height: circleSize)
        
        
        
        setRedBallAnimation(circleSize: circleSize)
        setGreenBallAnimation(circleSize: circleSize)
        setWhiteBallAnimation(circleSize: circleSize)
        setBottomBallAnimation()
        
        
        redBall.addSublayer(whiteBall)
        bottomBall.addSublayer(greenBall)
        bottomBall.addSublayer(redBall)
        
        animationLayers.append(redBall)
        animationLayers.append(greenBall)
        animationLayers.append(whiteBall)
        animationLayers.append(bottomBall)
        
        layer.addSublayer(bottomBall)
        
    }
    
    
    func setBottomBallAnimation(){
        let color = UIColor.init(red: 227/255.0, green: 80/255.0, blue: 101/255.0, alpha: 1)
        let animation =  CAKeyframeAnimation.init(keyPath: "backgroundColor")
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.keyTimes = [0, 0.3, 0.3, 0.8, 0.8, 1]
        animation.values = [color.withAlphaComponent(0).cgColor,
                            color.withAlphaComponent(0).cgColor,
                            color.cgColor,
                            color.cgColor,
                            color.withAlphaComponent(0).cgColor,
                            color.withAlphaComponent(0).cgColor]

        bottomBall.add(animation, forKey: "animation")
    }
    
    func setRedBallAnimation(circleSize: CGFloat) {
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = HUGE
        group.isRemovedOnCompletion = false
       
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: circleSize, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2+cos(.pi/180*60)*circleSize,
                                      y: -(sin(.pi/180*60)*circleSize-circleSize/2)))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize, y: circleSize/2))
        
        let postionAnimation = CAKeyframeAnimation.init(keyPath: "position")
        postionAnimation.path = path
       
        postionAnimation.keyTimes = [0, 0.2, 0.4, 0.4, 0.8, 1]
        
        let opacityAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
        
        opacityAnimation.values = [1, 1, 0, 0 , 1 , 1]
        opacityAnimation.keyTimes = [0, 0.4, 0.4, 0.8, 0.8, 1]
        
        group.animations = [postionAnimation, opacityAnimation]
        redBall.add(group, forKey: "groupAnimation")

    }
    
    func setGreenBallAnimation(circleSize: CGFloat) {
        
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: 0, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addQuadCurve(to: CGPoint(x: circleSize*cos(.pi/180*30)+circleSize/3, y: 0), control: CGPoint(x: circleSize/2*(1+cos(.pi/180*30)), y: circleSize/3))
        path.addLine(to: CGPoint.init(x: circleSize/2*3, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: 0, y: circleSize/2))

        
        
        let greenPostionAnimation =  CAKeyframeAnimation.init(keyPath: "position")
        greenPostionAnimation.path = path
        greenPostionAnimation.duration = duration
        greenPostionAnimation.repeatCount = HUGE
        greenPostionAnimation.isRemovedOnCompletion = false
        greenPostionAnimation.keyTimes = [0, 0.2, 0.35, 0.6, 0.6, 0.8, 1]

        greenBall.add(greenPostionAnimation, forKey: "animationTransform")
    }
    
    func setWhiteBallAnimation(circleSize: CGFloat) {
 
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = HUGE
        group.isRemovedOnCompletion = false
        
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: -circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize*sin(.pi/180*60)+circleSize/2, y: circleSize*cos(.pi/180*60)+circleSize/2))
        path.addLine(to: CGPoint.init(x: -circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: -circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: -circleSize/2, y: circleSize/2))
        
        
        let whitePostionAnimation =  CAKeyframeAnimation.init(keyPath: "position")
        whitePostionAnimation.path = path
        whitePostionAnimation.keyTimes = [0, 0.2, 0.4, 0.4, 0.8, 0.8, 1]
        
        
        
        let color = UIColor.init(red: 133/255.0, green: 242/255.0, blue: 239/255.0, alpha: 1)
        let colorAnimation =  CAKeyframeAnimation.init(keyPath: "backgroundColor")
        colorAnimation.keyTimes = [0, 0.8, 0.8, 0.81, 1]
        colorAnimation.values = [UIColor.white.cgColor,
                            UIColor.white.cgColor,
                            color.cgColor,
                            UIColor.white.cgColor,
                            UIColor.white.cgColor]

        group.animations = [whitePostionAnimation,  colorAnimation]
        whiteBall.add(group, forKey: "animation")
    }
    
    
    
    
    func changeAnimation(_ animation: CAKeyframeAnimation, values rawValues: [String]) {
        var values: [NSValue] = []
        for rawValue in rawValues {
            let point = NSCoder.cgPoint(for: rawValue)
            values.append(NSValue(caTransform3D: CATransform3DMakeTranslation(point.x, point.y, 0)))
        }
        animation.values = values
    }

    
    
    @objc private func animationUpdate(){
        guard let redBallPresentation = redBall.presentation() else { return }
        print(redBallPresentation.frame.origin)
//        if redBallPresentation.frame.origin.y <= 0,
//            bottomBall.masksToBounds == false {
//            bottomBall.masksToBounds = true
//        }
//        if redBallPresentation.frame.origin.y == 0{
//            bottomBall.masksToBounds = false
//        }
//        if redBallPresentation.frame.origin == .zero{
//            redBall.isHidden = true
//        }else{
//            redBall.isHidden = false
//        }
//
//        let height = sqrt(square(redBall.frame.size.width)-square(redBall.frame.size.width-width/2))
//
//        whiteBall.frame = CGRect.init(x: 0, y: (redBall.frame.size.height-height)/2, width: width, height: height)
//        whiteBall.masksToBounds = true
//        whiteBall.cornerRadius = height/2
    }
    
    
    private func square(_ num: CGFloat) -> CGFloat {
        return num*num
    }
    func startAnimating() {
        displayLink = CADisplayLink.init(target: self, selector: #selector(animationUpdate))
        displayLink?.add(to: RunLoop.main, forMode: .common)
        displayLink?.isPaused = false
    }
    func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    func pauseAnimating() {
    }
    
    func resumeAnimating() {
        
    }
}


#endif
