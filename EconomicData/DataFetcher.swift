//
//  DataSeriesGraph.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI

class DataFetcher: ObservableObject {
    
    init() {
        // get the data from the public API
        // TODO: Handle errors when unable to fetch data
        let url = URL(string: "https://www.econdb.com/api/series/?tickers=CPIUS,URATEUS,RGDPUS,IPUS,GDEBTUS,RPUCUS,RPRCUS,GDPUS,HOUUS,PPIUS&format=json")
        
        let urlRequst = URLRequest(url: url!)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequst) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedData = try JSONDecoder().decode(AllDataSeries.self, from: data)
                        self.allSeriesData = decodedData
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    @Published var allSeriesData: AllDataSeries?
    
    // data for displaying in navigation list
    var listData: [RawDataSeries] {
        if let haveData = allSeriesData {
            return haveData.results
        }
        return [RawDataSeries]()
    }
}
