//
//  DataSeriesGraph.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI

class DataFetcher: ObservableObject {
    
    init() {
        // Declare a state variable to track the data fetch state
        self.fetchState =  .loading
        self.fetchData()
    }
    
    @Published var allSeriesData: AllDataSeries?
    
    @Published var fetchState: DataFetchState
    
    // Define an enum to represent the different states
    enum DataFetchState {
        case loading
        case success
        case failure
    }
    
    func fetchData() {
        // update fetch state to reflect attempt to fetch data
        self.fetchState =  .loading
        
        // get the data from the public API
        let url = URL(string: "https://www.econdb.com/api/series/?tickers=CPIUS,URATEUS,RGDPUS,IPUS,GDEBTUS,RPUCUS,RPRCUS,GDPUS,HOUUS,PPIUS&format=json")
        
        let urlRequst = URLRequest(url: url!)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequst) { (data, response, error) in
            if error != nil {
                // update fetchState on main thread
                DispatchQueue.main.async {
                    self.fetchState = .failure
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedData = try JSONDecoder().decode(AllDataSeries.self, from: data)
                        self.allSeriesData = decodedData
                        self.fetchState = .success
                    } catch _ {
                        self.fetchState = .failure
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    // data for displaying in navigation list
    var listData: [RawDataSeries] {
        if let haveData = allSeriesData {
            return haveData.results
        }
        return [RawDataSeries]()
    }
}
