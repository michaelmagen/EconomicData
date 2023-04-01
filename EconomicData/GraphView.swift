//
//  ContentView.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI
import Charts

struct GraphView: View {
    @State var seriesData: SeriesGraph

    @State private var showSelectionBar = false

    @State private var barOffsetX = 0.0

    @State private var capsuleOffsetX = 0.0
    @State private var capsuleOffsetY = 0.0

    @State private var selectedDate = ""
    @State private var selectedValue = 0.0

    var body: some View {
        VStack {
            Button {
                seriesData.goToNextSliceOfData()
            } label: {
                Text("Next")
            }
            if let minDate = seriesData.earliestDate {
                Text("Date Range: \(minDate)")
            }
            Chart {
                ForEach(seriesData.currentDataSliceDisplayed) { item in
                    LineMark(
                        x: .value("Date", item.dateString),
                        y: .value("Value", item.value)
                    )
                }
            }
            .navigationBarTitle(Text(seriesData.description), displayMode: .inline)
            .frame(height: 400)
            // this line removes the X axis from the graph
            .chartXAxis {}
            .chartOverlay { pr in
                GeometryReader { geoProxy in
                    Rectangle()
                        .foregroundStyle(.orange.gradient)
                        .frame(width: 2, height: geoProxy.size.height )//* 0.95)
                        .opacity(showSelectionBar ? 1.0 : 0.0)
                        .offset(x: barOffsetX)
                    Capsule()
                        .foregroundStyle(.orange.gradient)
                        .frame(width: 100, height: 50)
                        .overlay {
                            VStack {
                                Text("\(String(format: "%.2f", selectedValue))%")
                                Text("\(selectedDate)")
                            }
                            .font(.body)
                            .foregroundStyle(.white.gradient)
                        }
                        .opacity(showSelectionBar ? 1.0 : 0.0)
                        .offset(x: capsuleOffsetX - 50, y: capsuleOffsetY - 50)
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture()
                            .onChanged { value in
                                if !showSelectionBar {
                                    showSelectionBar = true
                                }
                                let origin = geoProxy[pr.plotAreaFrame].origin
                                let location = CGPoint(x: value.location.x - origin.x, y: value.location.y - origin.y)

                                if location.x < 35.0 {
                                    capsuleOffsetX = 35.0
                                } else if location.x > 325 {
                                    capsuleOffsetX = 325.0
                                } else {
                                    capsuleOffsetX = location.x
                                }
                                barOffsetX = location.x
                                // the height of the whole chart is 400, pill is 50 hieght so this ensures pill always inside the graph no matter the offset
                                if location.y > 50 && location.y < 400 {
                                    capsuleOffsetY = location.y
                                }

                                let (date, _) = pr.value(at: location, as: (String, Int).self) ?? ("-", 0)
                                
                                let pointValue = seriesData.graphableData.first(where: {$0.dateString == date})?.value ?? 0
                                selectedValue = pointValue
                                selectedDate = date

                                // this is the bottom of the gesture
                            }
                            .onEnded { _ in
                                showSelectionBar = false
                            })
                }
            }
            .padding()
        }
    }
}


//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView(viewModel: DataSeriesGraph() )
//    }
//}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
