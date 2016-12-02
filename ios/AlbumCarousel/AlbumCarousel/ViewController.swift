//
//  ViewController.swift
//  AlbumCarousel
//
//  Created by Dave Erwin on 12/1/16.
//  Copyright © 2016 Dave Erwin. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var artistLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var albums : [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
    }

    //UICollectionViewDataSource methods - start
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        let stringUrl = albums[indexPath.item]
        let url = URL(string: stringUrl.pictureUrl)
        
        imageView.kf.setImage(with: url)
        return cell
    }

    //UICollectionViewDataSource methods - end
    
    
    //UISearchBarDelegate methods - start
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        artistLabel.text = "Artist: " + searchBar.text!
        searchBar.endEditing(true)
    }
    
    //UISearchBarDelegate methods - end
    
    
    //UICollectionViewDelegate methods - start
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    //UICollectionViewDelegate methods - end
}

