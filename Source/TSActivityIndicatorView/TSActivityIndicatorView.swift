//
//  TSActivityIndicatorView.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 2023/2/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//
#if canImport(UIKit)
import UIKit

public typealias FadeInAnimation = (_ view: UIView) -> Void

public typealias FadeOutAnimation = (_ view: UIView, _ completion: @escaping () -> Void) -> Void

public final class TSActivityIndicatorView: UIView {

    public static var DEFAULT_TYPE: TSActivityIndicatorType = .lineSpinFadeLoader()
    
    public static var DEFAULT_COLOR = UIColor.white
    
    public static var DEFAULT_TEXT_COLOR = UIColor.white
    
    public static var DEFAULT_PADDING: CGFloat = 0
    
    public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
    
    var type: TSActivityIndicatorType = TSActivityIndicatorView.DEFAULT_TYPE
       
    @IBInspectable public var color: UIColor = TSActivityIndicatorView.DEFAULT_COLOR
    
    @IBInspectable public var padding: CGFloat = TSActivityIndicatorView.DEFAULT_PADDING
    
    
    private var beginProgress: CGFloat?
    private var pausedTimes: [[String: CFTimeInterval]]?
    
    private(set) public var isAnimating: Bool = false
    private var animater: TSActivityIndicatorAnimationable?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    
    
    public init(frame: CGRect, type: TSActivityIndicatorType? = nil, color: UIColor? = nil, padding: CGFloat? = nil) {
        self.type = type ?? TSActivityIndicatorView.DEFAULT_TYPE
        self.color = color ?? TSActivityIndicatorView.DEFAULT_COLOR
        self.padding = padding ?? TSActivityIndicatorView.DEFAULT_PADDING
        super.init(frame: frame)
        isHidden = true
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    public override var bounds: CGRect {
        didSet {
            // setup the animation again for the new bounds
            if oldValue != bounds && isAnimating {
                setupAnimation()
            }
        }
    }
    
    /**
     Start animating.
     */
    public final func startAnimating() {
        guard !isAnimating else {
            return
        }
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation()
        animater?.startAnimating?()
    }
    
    public final func stopAnimating() {
        guard isAnimating else {
            return
        }
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
        animater?.stopAnimating?()
        
    }
    
    ///暂停动画
    public final func pauseAnimating(){
        guard let sublayers = animater?.animationLayers ?? layer.sublayers else { return }
        isAnimating = false
        if pausedTimes == nil{
            pausedTimes = []
            for sublayer in sublayers{
                let pausedTime = sublayer.convertTime(CACurrentMediaTime() , from: nil)
                let animationKeys = sublayer.animationKeys() ?? []
                for key in animationKeys {
                    if let _ = sublayer.animation(forKey: key){
                        pausedTimes?.append([key: pausedTime])
                    }else{ continue }
                }
                sublayer.speed = 0
                sublayer.timeOffset = pausedTime
            }
        }
        animater?.pauseAnimating?()
    }
    ///继续动画
    public final func resumeAnimating(){
        if pausedTimes == nil { return }
        guard let sublayers = animater?.animationLayers ?? layer.sublayers else { return }
        for sublayer in sublayers{
            let pausedTime = sublayer.timeOffset
            sublayer.speed = 1
            sublayer.beginTime = 0
            let timeSincePause = sublayer.convertTime(CACurrentMediaTime() , from: nil) - pausedTime
            sublayer.beginTime = timeSincePause
        }
        beginProgress = nil
        pausedTimes = nil
        isAnimating = true
        animater?.resumeAnimating?()
    }
    
    
    /// 设置进度（不需要设置进度的时候 需要调用resumeAnimating，否则动画无效）
    /// - Parameters:
    ///   - progress: 进度值 0 - 1
    public final func setProgress(progress: CGFloat){
        guard let sublayers = animater?.animationLayers ?? layer.sublayers else { return }
        if layer.speed == 1{
            pauseAnimating()
        }
        if beginProgress == nil{
            beginProgress = progress
        }
        
        let _progress = progress - beginProgress!
        
        for (i, sublayer) in sublayers.enumerated(){
            let pausedTimes = pausedTimes?[i]
            let animationKeys = sublayer.animationKeys() ?? []
            for key in animationKeys {
                if  let pausedTime = pausedTimes?[key]{
                    let animation = sublayer.animation(forKey: key)
                    sublayer.timeOffset = pausedTime + _progress*(animation?.duration ?? 0)
                }else{ continue }
            }
        }
    }
    
    private final func setupAnimation() {
        let animation: TSActivityIndicatorAnimationable = type.animation()
        var animationRect = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        let minEdge = min(animationRect.width, animationRect.height)
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setupAnimation(in: layer, size: animationRect.size, color: color)
        self.animater = animation
    }

}


#endif
