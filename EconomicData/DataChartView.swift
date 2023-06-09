//
//  DataChartView.swift
//  EconomicData
//
//  Created by Michael Magen on 4/17/23.
//

import SwiftUI
import Charts

struct DataChartView: View {
    @ObservedObject var seriesData: SeriesGraph

    @State private var isDragging = false

    private var showSelectionBarAndValues: Bool {
        isDragging && selectedDate != "-"
    }

    @State private var barOffsetX = 0.0

    @State private var selectedDate = ""
    @State private var selectedValue = 0.0

    var body: some View {
        Chart {
            ForEach(seriesData.graphableData) { item in
                LineMark(
                    x: .value("Date", item.dateString),
                    y: .value("Value", item.value)
                )
            }
        }
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

    }
    
    func chartOverlay(pr: ChartProxy) -> some View {
        return GeometryReader { geoProxy in
            Rectangle()
                .foregroundStyle(.orange.gradient)
                .frame(width: 2, height: geoProxy.size.height * 0.97)
                .opacity(showSelectionBarAndValues ? 1.0 : 0.0)
                .offset(x: barOffsetX)

            Rectangle().fill(.clear).contentShape(Rectangle())
                .gesture(graphDragGesture(pr: pr, geoProxy: geoProxy))
            
            Text("\(selectedDate): \(formatSelectedValue(value: selectedValue))")
                .offset(y: -20)
                .foregroundStyle(.orange.gradient)
                .opacity(showSelectionBarAndValues ? 1 : 0)
                .font(.footnote)
        }
    }
    
    func graphDragGesture(pr: ChartProxy, geoProxy: GeometryProxy) -> some Gesture {
        return DragGesture()
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                }
                let origin = geoProxy[pr.plotAreaFrame].origin
                let location = CGPoint(x: value.location.x - origin.x, y: value.location.y - origin.y)
                
                // update bar location
                barOffsetX = location.x
                
                let (date, _) = pr.value(at: location, as: (String, Int).self) ?? ("-", 0)
                
                let pointValue = seriesData.graphableData.first(where: {$0.dateString == date})?.value ?? 0
                selectedValue = pointValue
                selectedDate = date
            }
            .onEnded { _ in
                isDragging = false
            }
    }
    
    // this function takes the double that will be the axis value and properly formats it into a string that is smaller and indicates the unit of value.
    private func formatYAxisValues(value: Double) -> String {
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
    
    private func formatSelectedValue(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}
