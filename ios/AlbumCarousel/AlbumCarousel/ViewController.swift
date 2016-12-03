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
        
        query("David Bowie")
    }

    
    func query(_ queryString: String) {
        self.albums.removeAll()
        artistLabel.text = "Artist: " + queryString
        getAlbumsFromCoreData(queryString)
        if (self.albums.count != 0) {
            self.collectionView.reloadData()
        } else {
            makeRequest(queryString)
        }
    }
    
    func makeRequest(_ queryString: String) {
        let urlString = "https://itunes.apple.com/search?entity=album&attribute=allArtistTerm&term=" + queryString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(urlString).responseJSON { response in
            if let JSON = response.result.value {
                do {
                    
                    let data = JSON as! NSDictionary
                    let results = data.object(forKey: "results")! as! NSArray
                    for object in results {
                        let dictionary = object as! NSDictionary
                        
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let album = Album(context: context)
                        
                        album.pictureUrl = dictionary.object(forKey: "artworkUrl100") as? String
                        album.artistName = dictionary.object(forKey: "artistName") as? String
                        album.collectionName = dictionary.object(forKey: "collectionName") as? String
                        album.primaryGenreName = dictionary.object(forKey: "primaryGenreName") as? String
                        album.searchQuery = queryString
                        
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        
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
        let album = albums[indexPath.item]
        let url = URL(string: album.pictureUrl!)
        
        imageView.kf.setImage(with: url)
        return cell
    }

    //UICollectionViewDataSource methods - end
    
    
    //UISearchBarDelegate methods - start
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query(searchBar.text!)
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
    
    func getAlbumsFromCoreData(_ queryString: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let allAlbums = try context.fetch(Album.fetchRequest()) as! [Album]
            for album in allAlbums {
                if (album.searchQuery! == queryString) {
                    albums.append(album)
                }
            }
        } catch {
            print("Error: Album fetch failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! MoreDetailController
        nextViewController.album = sender as! Album
    }
    
}

