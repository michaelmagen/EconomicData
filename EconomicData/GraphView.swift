//
//  ContentView.swift
//  EconomicData
//
//  Created by Michael Magen on 3/29/23.
//

import SwiftUI
import Charts

struct GraphView: View {
    @ObservedObject var seriesData: SeriesGraph
    
    @State private var showSelectionBar = false
    
    @State private var barOffsetX = 0.0
    
    @State private var capsuleOffsetX = 0.0
    @State private var capsuleOffsetY = 0.0
    
    @State private var selectedDate = ""
    @State private var selectedValue = 0.0
    
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
            Chart {
                ForEach(seriesData.graphableData) { item in
                    LineMark(
                        x: .value("Date", item.dateString),
                        y: .value("Value", item.value)
                    )
                }
                
            }
            .padding(.leading)
            .navigationBarTitle(seriesData.ticker, displayMode: .inline)
            // this line removes the X axis from the graph
            .chartXAxis {
                AxisMarks(preset: .aligned ,values: seriesData.xAxisStrings)
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    if let val = value.as(Double.self) {
                        AxisValueLabel { Text(formatYAxisValues(value: val)) }
                    }
                    AxisGridLine()
                    AxisTick()
                }
            }
            .chartOverlay { pr in
                chartOverlay(pr: pr)
            }
            .padding()
            Spacer()
        }
    }
    
    func chartOverlay(pr: ChartProxy) -> some View {
        return GeometryReader { geoProxy in
            Rectangle()
                .foregroundStyle(.orange.gradient)
                .frame(width: 2, height: geoProxy.size.height )//* 0.95)
                .opacity(showSelectionBar ? 1.0 : 0.0)
                .offset(x: barOffsetX)
            Capsule()
                .foregroundStyle(.orange.gradient)
                .frame(width: 100, height: 50)
                .overlay {
                    capsuleOverlay
                }
                .opacity(showSelectionBar ? 1.0 : 0.0)
                .offset(x: capsuleOffsetX - 50, y: capsuleOffsetY - 50)
            Rectangle().fill(.clear).contentShape(Rectangle())
                .gesture(graphDragGesture(pr: pr, geoProxy: geoProxy))
        }
    }
    
    var capsuleOverlay: some View {
        VStack {
            Text("\(String(format: "%.2f", selectedValue))%")
            Text("\(selectedDate)")
        }
        .font(.body)
        .foregroundStyle(.white.gradient)
    }
    
    func graphDragGesture(pr: ChartProxy, geoProxy: GeometryProxy) -> some Gesture {
        return DragGesture()
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
            }
    }
    
    // this function takes the double that will be the axis value and properly formats it into a string that is smaller and indicates the unit of value.
    func formatYAxisValues(value: Double) -> String {
        // initialize the number formatter
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.numberStyle = .decimal
        
        // we take each number and divide by unit to make it smaller, then add a letter indicating the unit for that number (trillion, billion, million, thousand, or percentage).
        if value >= 1000000000000 {
            let number = value / 1000000000000
            return formatter.string(from: NSNumber(value: number))! + "T"
        } else if value >= 1000000000 {
            let number = value / 1000000000
            return formatter.string(from: NSNumber(value: number))! + "B"
        } else if value >= 1000000 {
            let number = value / 1000000
            return formatter.string(from: NSNumber(value: number))! + "M"
        } else if value >= 1000 {
            let number = value / 1000
            return formatter.string(from: NSNumber(value: number))! + "K"
        } else if value <= 100 && false {
            formatter.numberStyle = .percent
            return formatter.string(from: NSNumber(value: value))!
        }
        
        return formatter.string(from: NSNumber(value: value))!
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
