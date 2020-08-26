//
//  FeedListCollectionViewController.swift
//  DemoTestapp
//
//  Created by Prashanth reddy on 8/26/20.
//  Copyright © 2020 Prashanth reddy. All rights reserved.
//

import UIKit

class FeedListCollectionViewController: UICollectionViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 0)
    private let itemsPerRow: CGFloat = 1
    private let reuseIdentifier = "FeedCollectionViewCellIdentifer"
    private var albums = [AlbumData]()
    var viewModel: FeedDataViewModelProtocol?
    
    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndictor.style = .large
        activityIndictor.hidesWhenStopped = true
        self.view.bringSubviewToFront(activityIndictor)
        setupCollectionFlowLayout()
        
        self.viewModel = FeedDataViewModel(presenter: self)
        
        activityIndictor.startAnimating()
        viewModel?.fetchFeedListAPI()
        
        // Do any additional setup after loading the view.
        self.title = "Apple Feeds"
    }
    
    private func setupCollectionFlowLayout() {
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = CGSize(width: screenWidth, height: 130)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        self.collectionView.collectionViewLayout = layout
    }
    

    // MARK: UICollectionViewDataSource
    
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1
   }
   
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of items
       return self.albums.count
   }
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCollectionViewCell else {
           return UICollectionViewCell()
       }
       // Configure the cell
       let albumData = self.albums[indexPath.row]
       cell.mainTitleLabel.text = albumData.albumName
       cell.subTitleLabel.text = albumData.artistName
       cell.dateFieldLabel.text = albumData.releaseDate
       
       //Load album
       self.viewModel?.getPhoto(url: albumData.albumUrl, handler: { (image) in
           DispatchQueue.main.async {
               if let aImage = image {
                   cell.thumbnailImageView.image = aImage
               } else {
                   cell.thumbnailImageView.image = UIImage(named: "DefaultProfilePicuture")
               }
           }
       })
       cell.layoutIfNeeded()
       return cell
   }
    
}

extension FeedListCollectionViewController: FeedListPresenterProtocol {
    func populateFeeds(_ albums: [AlbumData]) {
        DispatchQueue.main.async { [weak self] in
            if let blockSelf = self {
                blockSelf.activityIndictor.stopAnimating()
                blockSelf.albums = albums
                blockSelf.collectionView.reloadData()
            }
        }
    }
    
    func showError(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndictor.stopAnimating()
            let alert = UIAlertController(title: "Error", message: error.errorDescription(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)
        }
        
    }
}

