//
//  SeriesGraph.swift
//  EconomicData
//
//  Created by Michael Magen on 3/31/23.
//

import SwiftUI

class SeriesGraph: ObservableObject {
    
    init(rawDataSeries: RawDataSeries) {
        self.rawDataSeries = rawDataSeries
        
        let array = Array(zip(rawDataSeries.data.values, rawDataSeries.data.dates))
        self.graphableData = array.map { value, date in
            identifiableDataTuple(value: value, dateString: date)
        }
    }
    
    private var rawDataSeries: RawDataSeries
    
    var graphableData: [identifiableDataTuple]
    
    var ticker: String {
        rawDataSeries.ticker
    }
    
    var description: String {
        let components = rawDataSeries.description.components(separatedBy: "-")
        return components[1]
    }
    
    var frequency: String {
        switch rawDataSeries.frequency {
        case "Q":
            return "Quarterly"
        default:
            return "Monthly"
        }
    }
    
    var geography: String {
        rawDataSeries.geography
    }
    
    var earliestDate: String {
        let dateData = graphableData.compactMap { $0.date }
        if let minDate = dateData.min() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: minDate)
        } else {
            return "Err"
        }
    }
    
    var latestDate: String {
        let dateData = graphableData.compactMap { $0.date }
        if let maxDate = dateData.max() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: maxDate)
        } else {
            return "Err"
        }
    }

    var xAxisStrings: [String] {
        let dateStrings = graphableData.map { $0.dateString }
        // select 4 data points from the strings
        let dataPoints =  selectDataPoints(dateStrings, n: 4)
        
        return dataPoints
    }
    
    // extracts specific data points from input array at regular intervals determined by the value of n.
    func selectDataPoints(_ data: [String], n: Int) -> [String] {
        let count = data.count
        let stride = count / (n + 1)
        var result: [String] = []
        
        for i in 1...n {
            let index = i * stride
            if index >= count {
                break
            }
            result.append(data[index])
        }
        
        return result
    }
}
