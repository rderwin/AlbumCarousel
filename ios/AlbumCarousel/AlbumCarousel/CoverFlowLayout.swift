//
//  CoverFlowLayout.swift
//  AlbumCarousel
//
//  Created by Dave Erwin on 12/2/16.
//  Copyright © 2016 Dave Erwin. All rights reserved.
//

import Foundation
import UIKit

class CoverFlowLayout : UICollectionViewFlowLayout {
    
    override func prepare() {
        self.scrollDirection = .horizontal
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)!
        
        var visibleRect = CGRect()
        visibleRect.origin = self.collectionView!.contentOffset
        visibleRect.size = self.collectionView!.bounds.size
        
        let halfViewSize = visibleRect.width/2.0
        
        for layoutAttributes in attributes {
            let distance = visibleRect.midX - layoutAttributes.center.x;
            let normalizedDistance = distance / halfViewSize;
            
            if (abs(distance) < halfViewSize) {
                let zoom = 1 + 0.3*(1 - abs(normalizedDistance))
                let rotationTransform = CATransform3DMakeRotation(normalizedDistance * CGFloat(M_PI_2) * 0.8, 0, 0.2, 0)
                
                let zoomTransform = CATransform3DMakeScale(zoom, zoom, 1.0)
                layoutAttributes.transform3D = CATransform3DConcat(zoomTransform, rotationTransform);
                layoutAttributes.zIndex = Int(abs(normalizedDistance) * 10.0)
                
                var alpha = (1 - abs(normalizedDistance)) + 0.05
                if (alpha > 1.0) {
                    alpha = 1.0
                }
                layoutAttributes.alpha = alpha
            } else {
                layoutAttributes.alpha = 0.0
            }
        }
    
        return attributes;
    }
}
