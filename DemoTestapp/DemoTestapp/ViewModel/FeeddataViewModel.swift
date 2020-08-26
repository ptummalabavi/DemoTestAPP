//
//  FeeddataViewModel.swift
//  DemoTestapp
//
//  Created by Prashanth reddy on 8/26/20.
//  Copyright © 2020 Prashanth reddy. All rights reserved.
//

import Foundation
import UIKit


protocol FeedDataViewModelProtocol {
    func fetchFeedListAPI()
    func getPhoto(url: String, handler: @escaping (UIImage?) -> Void)
}

protocol FeedListPresenterProtocol: NSObjectProtocol {
    func populateFeeds(_ albums: [AlbumData])
    func showError(error: NetworkError)
}

class FeedDataViewModel: FeedDataViewModelProtocol {
    
    var feedDataService: NetworkServiceProtocol?
    weak var presenter: FeedListPresenterProtocol?
    
    init(presenter: FeedListPresenterProtocol) {
        self.presenter = presenter
        self.feedDataService = NetworkService(session: URLSession.shared)
    }
    
    func fetchFeedListAPI() {
        guard let feedURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json") else {
            return
        }
        let urlReq = URLRequest(url: feedURL)
        self.feedDataService?.fetchFeedsListAPI(request: urlReq, completion: { (result) in
            switch result {
            case .success(let results):
                print("Success")
                self.prepareDataSource(results)
            case .failure(let error):
                    self.presenter?.showError(error: error)
                    print(error)
            }
        })
    }
    
    func getPhoto(url: String, handler: @escaping (UIImage?) -> Void) {
        if let fileUrl = URL(string: url) {
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: fileUrl) {
                    handler(UIImage(data: data))
                } else {
                    handler(nil)
                }
            }
        } else {
           handler(nil)
        }
    }

    func prepareDataSource(_ results: [FeedResult]) {
        var albums = [AlbumData]()
        for result in results {
            let album = AlbumData(albumUrl: result.artworkUrl100, albumName: result.name, artistName: result.artistName, releaseDate: result.releaseDate)
            albums.append(album)
        }
        self.presenter?.populateFeeds(albums)
    }
}




