//
//  SeriesSelectionView.swift
//  EconomicData
//
//  Created by Michael Magen on 3/30/23.
//

import SwiftUI

struct SeriesSelectionView: View {
    @EnvironmentObject var allSeriesDataStore: DataFetcher
    
    var body: some View {
        NavigationView {
            if allSeriesDataStore.fetchState == .loading {
                ProgressView()
                    .controlSize(.large)
                    .navigationTitle("US Economic Data")
            }
            else if allSeriesDataStore.fetchState == .failure {
                VStack {
                    Text("Unable to fetch data")
                        .navigationTitle("US Economic Data")
                    Button("Try again") {
                        allSeriesDataStore.fetchData()
                    }
                }
            }
            else {
                List(allSeriesDataStore.listData) { series in
                    NavigationLink(destination: SeriesDetailView(seriesData: SeriesGraph(rawDataSeries: series))) {
                        seriesListItem(ticker: series.ticker, description: series.description)
                    }
                }
                .navigationTitle("US Economic Data")
            }
            
        }
    }
}

struct seriesListItem: View {
    let ticker: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: "chart.xyaxis.line")
                .shadow(radius: 3)
                .font(.largeTitle)
                .frame(width: 65, height: 65)
                .overlay(
                    Circle().stroke(Color.purple, lineWidth: 3)
                )
            Text(description.dropFirst(16))
                .font(.title3)
        }
    }
}

struct SeriesSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesSelectionView()
    }
}
