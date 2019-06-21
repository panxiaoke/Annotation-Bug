//
//  FXAnnotationManager.swift
//  FXChat
//
//  Created by bailun on 2019/6/13.
//  Copyright © 2019 PengZhihao. All rights reserved.
//

import UIKit
import SciChart

class FXAnnotationManager {
    static let shared = FXAnnotationManager()
    private init() {
        
    }
    
    func isFXAnnotation(_ annotation: SCIAnnotationProtocol) -> Bool {
        return (annotation is FXHorizontalLineAnnotation) || (annotation is FXVerticalLineAnnotation) || (annotation is FXLineAnnotation) || (annotation is FXTextAnnotation)
    }
}
