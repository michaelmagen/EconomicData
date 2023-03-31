//
//  EconomicDataApp.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI

@main
struct EconomicDataApp: App {
    @StateObject var seriesInfo = DataSeriesGraph()
    var body: some Scene {
        WindowGroup {
            SeriesSelectionView()
                .environmentObject(seriesInfo)
        }
    }
}
