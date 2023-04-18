//
//  ContentView.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI
import Charts

struct SeriesDetailView: View {
    @ObservedObject var seriesData: SeriesGraph
    
    var body: some View {
        VStack {
            Text(seriesData.description)
                .font(.title)
                .padding(.bottom)
            VStack(alignment: .leading) {
                HStack {
                    GraphDetailItem(header: "Frequency", text: seriesData.frequency)
                    Spacer()
                    GraphDetailItem(header: "Geography", text: seriesData.geography)
                }
                .padding(.bottom)
                GraphDetailItem(header: "Date Range", text: "\(seriesData.earliestDate) - \(seriesData.latestDate)")
                
            }
            .padding(.horizontal, 30)
            Spacer()
            DataChartView(seriesData: seriesData)
                .padding(.leading)
        }
        .navigationBarTitle(seriesData.ticker, displayMode: .inline)
    }
}

struct GraphDetailItem: View {
    var header: String
    var text: String
    
    var body: some View  {
        VStack(alignment: .leading) {
            Text(header)
                .foregroundColor(.gray)
            Text(text)
        }
    }
}
