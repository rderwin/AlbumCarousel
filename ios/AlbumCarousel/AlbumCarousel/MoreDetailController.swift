//
//  MoreDetailController.swift
//  AlbumCarousel
//
//  Created by Dave Erwin on 12/3/16.
//  Copyright © 2016 Dave Erwin. All rights reserved.
//

import UIKit

class MoreDetailController: UIViewController {
    
    var album: Album? = nil
    
    @IBOutlet weak var coverView: UIImageView!
    
    @IBOutlet weak var albumLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: (album?.pictureUrl)!)
        coverView.kf.setImage(with: url)
        albumLabel.text = album?.collectionName
        artistLabel.text = album?.artistName
        genreLabel.text = album?.primaryGenreName
    }
    
    
}
