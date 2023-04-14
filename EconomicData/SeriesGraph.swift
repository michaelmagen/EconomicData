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
        switch rawDataSeries.frequency{
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
        //Calendar.current.dateComponents([.day, .year, .month], from: date)
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
        //Calendar.current.dateComponents([.day, .year, .month], from: date)
        if let maxDate = dateData.max() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: maxDate)
        } else {
            return "Err"
        }
    }

    // TODO: remove as many computed values as possible since these are recomputed everytime
    var xAxisStrings: [String] {
        let dateStrings = graphableData.map { $0.dateString }
        // select 5 data points from the strings
        let dataPoints =  selectDataPoints(dateStrings, n: 5)
        // drop the first data point and keep the other 4 since the first is not needed
        return Array(dataPoints.dropFirst())
    }
    
    func selectDataPoints(_ data: [String], n: Int) -> [String] {
        let count = data.count
        let stride = Double(count) / Double(n)
        //var index = 0
        var result: [String] = []
        
        for i in 0..<n {
            let newIndex = Int(Double(i) * stride)
            if newIndex >= count {
                break
            }
            result.append(data[newIndex])
        }
        
        return result
    }
}
