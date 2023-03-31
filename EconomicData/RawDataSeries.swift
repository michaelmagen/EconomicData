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
    let data: RawDataValues
    
    private enum CodingKeys: String, CodingKey {
        case description, frequency, ticker, geography, data
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
    let date: String
}
