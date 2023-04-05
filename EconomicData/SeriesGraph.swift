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
        
//        // convert the raw string to only include month and year
//        var monthYearStrings = [String]()
//        for dateString in rawDataSeries.data.dates {
//            let components = dateString.components(separatedBy: "-")
//            let year = components[0]
//            let month = components[1]
//            let monthYearString = "\(month)/\(year)"
//            monthYearStrings.append(monthYearString)
//        }
//        self.stringDatesMonthYearOnly = monthYearStrings
        //let numberOfGraphsToCreate = graphableData.count / 100
        //print("this data is being split into \(numberOfGraphsToCreate) graphs")
        
        // this is not needed, runs fine on phone, only runs slow on simulator
        //self.setsOfGraphableData = graphableData.chunked(into: 1000)
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
        return selectDataPoints(dateStrings, n: 5)
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
    
    
    
    // MARK: INTENT
}

// used to chunk an array into seperate array of specified size
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
