//
//  File.swift
//  TSActivityIndicatorType
//
//  Created by leetangsong on 2023/3/4.
//  Copyright © 2023 CocoaPods. All rights reserved.
//
#if canImport(UIKit)

import UIKit
public enum TSActivityIndicatorType {
    
    ///  lineCount 线个数  innerScale  内径占整个比例  
    ///   (lineCount  8, lineSpacing 2,  innerScale 0.4, duration:  1.2)
    case lineSpinFadeLoader(_ lineCount: Int = 12, _ lineSpacing: CGFloat = 1.4, _ innerScale: CGFloat = 0.54 , _ duration: CFTimeInterval = 1.2)
    
    case audioEqualizer
       
    case aweme(_ ballWidth: CGFloat = 15)
    
    func animation() -> TSActivityIndicatorAnimationable {
        switch self {
        case let .lineSpinFadeLoader(lineCount, lineSpacing, innerScale, duration):
            return TSActivityIndicatorAnimationLineSpinFadeLoader(lineCount: lineCount, lineSpacing: lineSpacing, innerScale: innerScale, duration: duration)
        case .audioEqualizer:
            return TSActivityIndicatorAnimationAudioEqualizer()
        case let .aweme(ballWidth):
            return TSActivityIndicatorAnimationAweme(ballWidth: ballWidth)
        }
    }
}

#endif
