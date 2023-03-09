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
        
        // 第一阶段 红绿重合
        // 第二阶段 红斜向右上45度
        // 第三阶段 绿球 斜向右上
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: circleSize, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2+cos(.pi/180*60)*circleSize,
                                      y: -(sin(.pi/180*60)*circleSize-circleSize/2)))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize, y: circleSize/2))
        
        let redPostionAnimation = CAKeyframeAnimation.init(keyPath: "position")
        redPostionAnimation.path = path
        redPostionAnimation.duration = duration
        redPostionAnimation.repeatCount = HUGE
        redPostionAnimation.isRemovedOnCompletion = false

        redPostionAnimation.keyTimes = [0, 0.2, 0.4, 0.4, 0.8, 1]
        
       
        redBall.add(redPostionAnimation, forKey: "animationTransform")
    }
    
    func setGreenBallAnimation(circleSize: CGFloat) {
        
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: 0, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        //斜着
        path.addArc(
            center: .init(x: circleSize*cos(.pi/180*30)+circleSize/2, y: circleSize),
            radius: circleSize,
            startAngle: -.pi/180*120,
            endAngle: -.pi/180*90,
            clockwise: false)
        path.move(to: CGPoint.init(x: circleSize/2*3, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: circleSize/2, y: circleSize/2))
        path.addLine(to: CGPoint.init(x: 0, y: circleSize/2))

        
        let greenPostionAnimation =  CAKeyframeAnimation.init(keyPath: "position")
        greenPostionAnimation.path = path
        greenPostionAnimation.duration = duration
        greenPostionAnimation.repeatCount = HUGE
        greenPostionAnimation.isRemovedOnCompletion = false
        greenPostionAnimation.keyTimes = [0, 0.2, 0.36, 0.6, 0.6, 0.8, 1]

        greenBall.add(greenPostionAnimation, forKey: "animationTransform")
    }
    
    func setWhiteBallAnimation(circleSize: CGFloat) {
 
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
        whitePostionAnimation.duration = duration
        whitePostionAnimation.repeatCount = HUGE
        whitePostionAnimation.isRemovedOnCompletion = false
      
        whiteBall.add(whitePostionAnimation, forKey: "animationTransform")
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
        if redBallPresentation.frame.origin.y <= 0,
            bottomBall.masksToBounds == false {
            bottomBall.masksToBounds = true
        }
        if redBallPresentation.frame.origin.y == 0{
            bottomBall.masksToBounds = false
        }
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
