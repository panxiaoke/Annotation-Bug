//
//  FXLineAnnotation.swift
//  FXChat
//
//  Created by bailun on 2019/6/13.
//  Copyright © 2019 PengZhihao. All rights reserved.
//

import UIKit
import SciChart

class FXLineAnnotation: SCILineAnnotation {
    var selectedActionHandler: ((SCIAnnotationBase, Bool) -> Void)?
    override var isSelected: Bool {
        willSet {
            if !newValue {
                return
            }
            
            let annotations = self.parentSurface.annotations
            let count = UInt32(annotations.count())
            for index in 0..<count {
                let annotation = annotations[index]
                let isFXAnnotation = FXAnnotationManager.shared.isFXAnnotation(annotation!)
                if !(annotation?.annotationName == self.annotationName)  && isFXAnnotation {
                    annotation!.isSelected = false
                }
            }
        }
        
        didSet {
            self.selectedActionHandler?(self, isSelected)
        }
    }
    
}
