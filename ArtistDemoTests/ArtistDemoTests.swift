//
//  ArtistDemoTests.swift
//  ArtistDemoTests
//

import XCTest
@testable import ArtistDemo

class ArtistDemoTests: XCTestCase {

    let artistViewModel = ArtistViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApiResponse() throws {
        
        // search text
        let searchText: String = "Taylor Swift" // replace text for search
        
        // for test api response
        let sURL = API_URL + searchText
        let URL = NSURL(string: sURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        let exp = self.expectation(description: "GET \(URL)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: URL as URL) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? HTTPURLResponse,
               let responseURL = HTTPResponse.url
            {
                XCTAssertEqual(responseURL.absoluteString, URL.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
    func testAlbums() throws {

        // search text
        let searchText: String = "David" // replace text for search
        
        // for test api response
        let sURL = API_URL + searchText
        let URL = NSURL(string: sURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        let exp = self.expectation(description: "GET \(URL)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: URL as URL) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                XCTAssertNotNil(jsonResult, "response not in json object")
                
                let results = jsonResult!["results"] as? NSArray
                XCTAssertNotNil(results, "results should not be nil")

                let data = try JSONSerialization.data(withJSONObject: results as Any, options: .prettyPrinted)
                XCTAssertNotNil(data, "results not converted in data")

                let result = try JSONDecoder().decode([ArtistModel].self, from: data)
                XCTAssertNotNil(result, "model conversion failed")
                self.artistViewModel.arrArtist = result

            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            task.cancel()
            
            // to check single data
            let model = self.artistViewModel.arrArtist[0]
            self.checkItem(artist: model)
            
            // to check all data
//            for artist in self.artistViewModel.arrArtist {
//                self.checkItem(artist: artist)
//            }
        }
    }
    
    //MARK:- Check single item
    func checkItem(artist: ArtistModel) {
        
        XCTAssertNotNil(artist.artistName, "Artist name is nil")
        XCTAssertNotNil(artist.trackName, "Track name is nil")
        XCTAssertNotNil(artist.currency, "Currency is nil")
        XCTAssertNotNil(artist.trackPrice, "Track price is nil")
        XCTAssertNotNil(artist.primaryGenreName, "Genres is nil")
        XCTAssertNotNil(artist.releaseDate, "Release date is nil")

        XCTAssertTrue(artist.trackPrice! > 0.0)

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        let date = dateformatter.date(from: artist.releaseDate ?? "")
        XCTAssertNotNil(date, "Different date format")

        dateformatter.dateFormat = "d MMM, YYYY"
        let strDate = dateformatter.string(from: date!)
        XCTAssertNotEqual(strDate, "")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
