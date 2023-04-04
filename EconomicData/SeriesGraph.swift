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

//    private var DateData: [Date] {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateStringArray = rawDataSeries.data.dates
//
//        var yearMonthArray = [Date]()
//        for dateString in dateStringArray {
//            if let date = dateFormatter.date(from: dateString) {
//                let calendar = Calendar.current
//                let components = calendar.dateComponents([.year, .month], from: date)
//                if let yearMonthDate = calendar.date(from: components) {
//                    yearMonthArray.append(yearMonthDate)
//                }
//            }
//        }
//        return yearMonthArray
//    }
    
    var description: String {
        rawDataSeries.description
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
