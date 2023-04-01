//
//  DataSeries.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import Foundation

struct AllDataSeries: Codable {
    let results: [RawDataSeries]
}

struct RawDataSeries: Codable, Identifiable {
    let id = UUID()
    let description: String
    let frequency: String
    let ticker: String
    let geography: String
    let units: String?
    let data: RawDataValues
    
    private enum CodingKeys: String, CodingKey {
        case description, frequency, ticker, geography, data, units
    }
}

struct RawDataValues: Codable, Identifiable {
    let id = UUID()
    let values: [Double]
    let dates: [String]
    
    private enum CodingKeys: String, CodingKey {
        case values, dates
    }
}

struct identifiableDataTuple: Identifiable {
    let id = UUID()
    let value: Double
    let dateString: String
    let date: Date?
    
    init(value: Double, dateString: String) {
        self.value = value
        
        // format the data string
        let components = dateString.components(separatedBy: "-")
        let year = components[0]
        let month = components[1]
        self.dateString = "\(month)/\(year)"
        
        
        // get the Date from the date string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            self.date = date
        } else {
            self.date = nil
        }
    }
}
