//
//  TSActivityIndicatorAnimationable.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 2023/2/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public protocol TSActivityIndicatorAnimationable {
    
    var duration: CFTimeInterval { get set }
    
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor)
    
}


#endif