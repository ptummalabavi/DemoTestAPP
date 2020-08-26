//
//  DemoTestappTests.swift
//  DemoTestappTests
//
//  Created by Prashanth reddy on 8/26/20.
//  Copyright © 2020 Prashanth reddy. All rights reserved.
//

import XCTest
@testable import DemoTestapp

class DemoTestappTests: XCTestCase {
    
    var feedListViewController: FeedListCollectionViewController?
    let window = UIWindow()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.feedListViewController = sb.instantiateViewController(withIdentifier: "FeedListCollectionViewController") as? FeedListCollectionViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.feedListViewController = nil
    }

    func loadView() {
        window.addSubview((feedListViewController?.view)!)
    }
    
    func testViewDidLoad() {
        loadView()
        let view = self.feedListViewController?.viewIfLoaded
        XCTAssertNotNil(view, "View not loaded properly")
    }
    
    func testAlbumData() {
        let feedDataService: NetworkServiceProtocol = NetworkService(session: URLSession.shared)
        guard let feedURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json") else {
            return
        }
        let urlReq = URLRequest(url: feedURL)
        let expectation = self.expectation(description: "Fetch request")
        feedDataService.fetchFeedsListAPI(request: urlReq, completion: { (result) in
            switch result {
            case .success(let results):
                XCTAssertTrue(results.count > 0)
            case .failure(let error):
                let errDesc = error.errorDescription()
                XCTAssertNotNil(errDesc)
                XCTFail("Request failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testAlbumFetchRequestFail() {
        let feedDataService: NetworkServiceProtocol = NetworkService(session: URLSession.shared)
        guard let inValidURL = URL(string: "https://rss.itunes.appe.com/api/v1/us/apple-music/top-albums/all/25/explicit.json") else {
            return
        }
        let urlReq = URLRequest(url: inValidURL)
        let expectation = self.expectation(description: "Fetch request")
        feedDataService.fetchFeedsListAPI(request: urlReq, completion: {[weak self] (result) in
            switch result {
            case .success(let results):
                XCTAssertTrue(results.count > 0)
            case .failure(let error):
                //XCTFail("Request failed: \(error.localizedDescription)")
                let errDesc = error.errorDescription()
                XCTAssertNotNil(errDesc)
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAlbumURL() {
        let imgURLString = "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/14/4a/8f/144a8f2c-c723-2413-291b-ba2fe2819456/20UMGIM71728.rgb.jpg/200x200bb.png"
        let expectation = self.expectation(description: "Fetch album avatar")
        let vm: FeedDataViewModelProtocol = FeedDataViewModel(presenter: self)
        vm.getPhoto(url: imgURLString) { (image) in
            if let aImage = image {
                XCTAssertNotNil(aImage)
            } else {
                XCTAssertNotNil(UIImage(named: "DefaultProfilePicuture"))
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAlbumAvatarFetchFail() {
        let inValidImgURLString = "https://is4-ssl.c.com/image/thumb/Music124/v4/14/4a/8f/144a8f2c-c723-2413-291b-ba2fe2819456/20UMGIM71728.rgb.jpg/200x200bb.png"
        let expectation = self.expectation(description: "Fetch album avatar")
        let vm: FeedDataViewModelProtocol = FeedDataViewModel(presenter: self)
        vm.getPhoto(url: inValidImgURLString) { (image) in
            if let aImage = image {
                XCTAssertNotNil(aImage)
            } else {
                XCTAssertNotNil(UIImage(named: "DefaultProfilePicuture"))
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension DemoTestappTests: FeedListPresenterProtocol {
    func populateFeeds(_ albums: [AlbumData]) {
        
    }
    
    func showError(error: NetworkError) {
    }
}
