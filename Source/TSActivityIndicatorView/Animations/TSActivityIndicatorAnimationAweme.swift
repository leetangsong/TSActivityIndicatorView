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
    
    private let duration = 3.0
    
    private let keyTimes: [NSNumber] = [0, 0.33, 0.66, 1]
    private var displayLink: CADisplayLink?
    
    private var redBall: CALayer!
    
    private var greenBall: CALayer!
    
    private var whiteBall: CALayer!
    
    private var bottomBall: CALayer!
        
    var animationLayers: [CALayer] = []
    var ballWidth: CGFloat
    
    init(ballWidth: CGFloat) {
        self.ballWidth = ballWidth
    }
    
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSize: CGFloat = min(ballWidth, size.width)
        
        bottomBall = CALayer()
        bottomBall.backgroundColor = UIColor.black.cgColor
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
        
        
        bottomBall.frame = CGRect.init(x: (layer.frame.size.width-circleSize)/2, y: (layer.frame.size.height-circleSize)/2, width: circleSize, height: circleSize)
        redBall.frame = CGRect.init(x: circleSize/2, y: 0, width: circleSize, height: circleSize)
        greenBall.frame = CGRect.init(x: -circleSize/2, y: 0, width: circleSize, height: circleSize)
        whiteBall.frame = CGRect.init(x: 0, y: 0, width: circleSize, height: circleSize)
        
        
        
        setRedBallAnimation(circleSize: circleSize)
        setGreenBallAnimation(circleSize: circleSize)
        setWhiteBallAnimation(circleSize: circleSize)
        
        
        
        redBall.addSublayer(whiteBall)
        bottomBall.addSublayer(greenBall)
        bottomBall.addSublayer(redBall)
        
        animationLayers.append(redBall)
        animationLayers.append(greenBall)
        animationLayers.append(whiteBall)
        
        layer.addSublayer(bottomBall)
        
    }
    
    func setRedBallAnimation(circleSize: CGFloat) {
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.duration = duration
        group.repeatCount = HUGE
        group.isRemovedOnCompletion = false
        // 第一阶段 红绿重合
        // 第二阶段 红斜向右上45度
        // 第三阶段 绿球 斜向右上
        let redPostionAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        changeAnimation(redPostionAnimation, values: ["{0,0}", "{\(-circleSize/2), 0}", "{\(-circleSize/2+circleSize*(sin(.pi/180*30))),\(-circleSize*cos(.pi/180*30))}", "{0,0}"])
        redPostionAnimation.keyTimes = keyTimes
        
        
       
       
        group.animations = [redPostionAnimation]
        
        redBall.add(group, forKey: "animationTransform")
    }
    
    func setGreenBallAnimation(circleSize: CGFloat) {
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = HUGE
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction(name: .linear)
    
        let greenPostionAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        changeAnimation(greenPostionAnimation, values: ["{0,0}", "{\(circleSize/2),0}", "{\(circleSize/2),0}", "{\(circleSize/2),0}", "{0,0}"])
        greenPostionAnimation.keyTimes = [0, 0.33, 0.6, 0.8,1]
    
        ///
        ///
        
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: 0, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: 0, y: circleSize/2))
        greenPostionAnimation.keyTimes = [0, 0.33, 0.66,1]
        let ani2 =  CAKeyframeAnimation.init(keyPath: "position")
        ani2.path = path
        ani2.keyTimes = [0, 0.33, 0.66,1]
//        CGPathAddEllipseInRect(path, NULL, drawRect);
//
//        self.animation.keyTimes = @[@.0, @.25, @0.5, @0.75, @1.0];
        // self.animation.calculationMode = kCAAnimationPaced;
        
        group.animations = [ ani2]
        greenBall.add(group, forKey: "animationTransform")
    }
    
    func setWhiteBallAnimation(circleSize: CGFloat) {
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = HUGE
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let whitePostionAnimation = CAKeyframeAnimation.init(keyPath: "bounds.size.width")
        whitePostionAnimation.values = [0, circleSize, circleSize, 0]
        
        
        let whitePostionAnimation1 = CAKeyframeAnimation.init(keyPath: "transform")
        changeAnimation(whitePostionAnimation1, values: ["{-\(circleSize/2),0}", "{0,0}", "{\((circleSize*(1-sin(.pi/180*30)))),\(circleSize*cos(.pi/180*30))}", "{\((circleSize*(1-sin(.pi/180*30)))),\(circleSize*cos(.pi/180*30))}", "{-\(circleSize/2),0}"])
        whitePostionAnimation1.keyTimes = [0, 0.33, 0.5, 0.66 ,1]
        
        group.animations = [whitePostionAnimation, whitePostionAnimation1]
        whiteBall.add(group, forKey: "animationTransform")
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
        if redBallPresentation.frame.origin.y <= 0, redBallPresentation.frame.origin.y > -0.2{
            bottomBall.masksToBounds = true
        }
        if redBallPresentation.frame.origin.y == 0{
            bottomBall.masksToBounds = false
        }
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
