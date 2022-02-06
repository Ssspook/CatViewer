//
//  CatViewerTests.swift
//  CatViewerTests
//
//  Created by Meritocrat on 1/11/22.
//

import XCTest
@testable import CatViewer

class CatViewer_Tests: XCTestCase {

    private var _catListViewModel: CatsListViewModel?
    private let catsData = [
        "[{\"breeds\":[],\"id\":\"4ji\",\"url\":\"https://cdn2.thecatapi.com/images/4ji.gif\",\"width\":500,\"height\":225}]",
        "[{\"breeds\":[],\"id\":\"e6o\",\"url\":\"https://cdn2.thecatapi.com/images/e6o.jpg\",\"width\":500,\"height\":448}]",
        "[{\"breeds\":[],\"id\":\"KXVo5br4c\",\"url\":\"https://cdn2.thecatapi.com/images/KXVo5br4c.jpg\",\"width\":750,\"height\":1334}]"
    ]
    
    override func setUp() {
      // Try to run tests before any commit to main/develop branch (usually it controls by CI process and branch permissions and code review on PR to these branches)
        _catListViewModel = CatsListViewModel(networkManager: MockNetworkManager(catsData: catsData))
    }

    override func tearDown() {
        _catListViewModel = nil
       
    }
    
    func test_CatViewModel_dataFetched_shouldBeTrue() {
        
        let catViewModel = CatViewModel(catDTO: Cat(breeds: nil, id: "1234", url: "url1", width: 344, height: 123), networkManager: MockNetworkManager(catsData: catsData))
        catViewModel.fetchImage()
        
        XCTAssertTrue(catViewModel.dataFetched)
    }
    
    func test_CatListViewModel_fetchCats_catsFetched() {
        guard let _catListViewModel = _catListViewModel else {
            return
        }        
        
        _catListViewModel.fetchCats()
        
        XCTAssertTrue(_catListViewModel.cats.count == 3)
    }
}
