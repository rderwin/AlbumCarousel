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

}
