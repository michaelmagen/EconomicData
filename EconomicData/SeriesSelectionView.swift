//
//  SeriesSelectionView.swift
//  EconomicData
//
//  Created by Michael Magen on 3/30/23.
//

import SwiftUI

struct SeriesSelectionView: View {
    @EnvironmentObject var allSeriesDataStore: DataSeriesGraph
    
    var body: some View {
        NavigationView {
            List(allSeriesDataStore.listData) { series in
                NavigationLink(destination: GraphView(seriesData: series)) {
                    seriesListItem(ticker: series.ticker, description: series.description)
                }
            }
            .navigationTitle("Macroeconomic Data")
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
