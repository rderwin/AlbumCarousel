//
//  ViewController.swift
//  AlbumCarousel
//
//  Created by Dave Erwin on 12/1/16.
//  Copyright © 2016 Dave Erwin. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

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
        
        makeRequest("David Bowie")
    }

    
    func makeRequest(_ searchTerms: String) {
        self.albums.removeAll()
        artistLabel.text = "Artist: " + searchTerms
        let urlString = "https://itunes.apple.com/search?entity=album&attribute=allArtistTerm&term=" + searchTerms.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(urlString).responseJSON { response in
            if let JSON = response.result.value {
                do {
                    
                    let stringData = JSON as! NSDictionary
                    let results = stringData.object(forKey: "results")! as! NSArray
                    for object in results {
                        let dictionary = object as! NSDictionary
                        
                        let album = Album()
                        album.pictureUrl = dictionary.object(forKey: "artworkUrl100") as! String
                        album.artistName = dictionary.object(forKey: "artistName") as! String
                        album.collectionName = dictionary.object(forKey: "collectionName") as! String
                        album.primaryGenreName = dictionary.object(forKey: "primaryGenreName") as! String
                        
                        self.albums.append(album)
                    }
                    self.collectionView.reloadData()
                }
            }
        }
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
        makeRequest(searchBar.text!)
        searchBar.endEditing(true)
    }
    
    //UISearchBarDelegate methods - end
    
    
    //UICollectionViewDelegate methods - start
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        performSegue(withIdentifier: "MoreDetailSegue", sender: album)
    }
    
    //UICollectionViewDelegate methods - end
}

