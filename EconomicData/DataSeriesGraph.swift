//
//  DataSeriesGraph.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI

class DataSeriesGraph: ObservableObject {
    
//    static let allAvailableSeriesTickers = ["URATEUS", "CPIUS"]
//
//    static let seriesTickerToDescription = [
//        "URATEUS": "United States - Unemployment",
//        "CPIUS": "United States - Consumer price index"]
    
    init() {
//        let APIToken = "d45a5abc6f796c2c42f728a45ed664e15f6f1f34"
//        // ?token=%s&format=json
//        let url = URL(string:"https://www.econdb.com/api/series/URATEUS/?token=\(APIToken)&format=json")
//        //print(url)
//        let urlRequst = URLRequest(url: url!)
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequst) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let decodedData = try JSONDecoder().decode(RawDataSeries.self, from: data)
//                        self.chartData = decodedData
//                    } catch let error {
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//
//        dataTask.resume()
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
    
    @Published var chartData: RawDataSeries?
    
    var listData: [RawDataSeries] {
        if let haveData = allSeriesData {
            return haveData.results
        }
        return [RawDataSeries]()
    }
    
//    func getRawDataSeries(ticker: String) -> RawDataSeries {
//        if let allData = allSeriesData {
//            if let found = allData.results.first(where: {$0.ticker == ticker}) {
//                return found
//            }
//        }
//    }
}

extension RawDataSeries {
    var graphableData: [identifiableDataTuple] {
        let array = Array(zip(data.values, data.dates))
        return array.map { value, date in
            identifiableDataTuple(value: value, date: date)
        }
    }
}














class TimerHelper {
    var startTime: DispatchTime?
    var timer: DispatchSourceTimer?
    
    func start() {
        startTime = DispatchTime.now()
        
        // Create a timer that repeats every 10 milliseconds
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: .main)
        timer?.schedule(deadline: .now(), repeating: .milliseconds(10), leeway: .milliseconds(1))
        timer?.setEventHandler(handler: { [weak self] in
            self?.printElapsedTime()
        })
        
        timer?.resume()
    }
    
    func end() {
        timer?.cancel()
        printElapsedTime()
    }
    
    private func printElapsedTime() {
        guard let startTime = startTime else {
            return
        }
        
        let endTime = DispatchTime.now()
        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let elapsedMilliseconds = Double(elapsedTime) / 1_000_000
        print("Elapsed time: \(elapsedMilliseconds) ms")
    }
}
