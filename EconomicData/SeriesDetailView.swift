//
//  ContentView.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI

struct SeriesDetailView: View {
    @ObservedObject var seriesData: SeriesGraph
    
    var body: some View {
        VStack {
            Text(seriesData.description)
                .font(.title)
                .padding(.bottom)
            VStack(alignment: .leading) {
                HStack {
                    InfoDetailItem(header: "Frequency", text: seriesData.frequency)
                    Spacer()
                    InfoDetailItem(header: "Geography", text: seriesData.geography)
                }
                .padding(.bottom)
                InfoDetailItem(header: "Date Range", text: "\(seriesData.earliestDate) - \(seriesData.latestDate)")
                
            }
            .padding(.horizontal, 30)
            Spacer()
            DataChartView(seriesData: seriesData)
                .padding(.leading)
        }
        .navigationBarTitle(seriesData.ticker, displayMode: .inline)
    }
}

struct InfoDetailItem: View {
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
