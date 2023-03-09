//
//  TSActivityIndicatorAnimationable.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 2023/2/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#if canImport(UIKit)

import UIKit

@objc public protocol TSActivityIndicatorAnimationable {
    
    @objc optional var duration: CFTimeInterval { get set }
    
    @objc optional var animationLayers: [CALayer] { get set }
    
    @objc optional func startAnimating()
    
    @objc optional func stopAnimating()
    
    @objc optional func pauseAnimating()
    
    @objc optional func resumeAnimating()

    
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor)
    
}




#endif
