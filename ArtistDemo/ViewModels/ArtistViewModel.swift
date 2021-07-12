//
//  ArtistViewModel.swift
//

import Foundation

//MARK:- Artist view model
class ArtistViewModel {
    
    var text: String = ""
    var arrArtist = [ArtistModel]()
    
    //MARK:- Fetch data from server
    func fetchData(completion: @escaping (_ status: Bool) -> Void) {
        
        let sURL = API_URL + text
        let url = sURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(url)
        
        ServiceManager.getRequest(url: url) { (dict, status) in
            
            // check for success
            if status {
                
                if let arr = dict["results"] as? NSArray {
                    
                    print(arr)
                    do {
                        // JSON object to Data conversion
                        let data = try JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted)
                        let result = try JSONDecoder().decode([ArtistModel].self, from: data)
                        self.arrArtist = result
                        completion(true)
                    } catch {
                        print(error)
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
}
