//
//  GroupedBarChartWithLabels.swift
//  Plot
//
//  Created by james seo on 9/30/23.
//

import Charts
import SwiftUI
/// link: [https://matplotlib.org/stable/gallery/lines_bars_and_markers/barchart.html#sphx-glr-gallery-lines-bars-and-markers-barchart-py](https://matplotlib.org/stable/gallery/lines_bars_and_markers/barchart.html#sphx-glr-gallery-lines-bars-and-markers-barchart-py)
///  This example shows a how to create a grouped bar chart and how to annotate bars with labels.

fileprivate struct Penguin {
    let name: String
    let attribute: String
    let measurment: Double
    
    var offset: CGFloat {
        if attribute == "Bill Depth" {
            return -50.0
        } else if attribute == "Bill Length" {
            return 0.0
        } else {
            return 50.0
        }
    }
    
    static let dummy: [Penguin] = [
        Penguin(name: "Adelie", attribute: "Bill Depth", measurment: 18.35),
        Penguin(name: "Chinstrap", attribute: "Bill Depth", measurment: 18.43),
        Penguin(name: "Gentoo", attribute: "Bill Depth", measurment: 14.98),
        Penguin(name: "Adelie", attribute: "Bill Length", measurment: 38.79),
        Penguin(name: "Chinstrap", attribute: "Bill Length", measurment: 48.83),
        Penguin(name: "Gentoo", attribute: "Bill Length", measurment: 47.50),
        Penguin(name: "Adelie", attribute: "Flipper Length", measurment: 189.95),
        Penguin(name: "Chinstrap", attribute: "Flipper Length", measurment: 195.82),
        Penguin(name: "Gentoo", attribute: "Flipper Length", measurment: 217.19),
    ]
}


struct GroupedBarChartWithLabels: View {
    var body: some View {
        ScrollView {
            LazyVStack {
               Text("Penguin attributes by species")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Chart(Penguin.dummy, id: \.name) { penguin in
                    BarMark(
                        x: .value("name", penguin.name),
                        y: .value("measurment", penguin.measurment),
                        width: .fixed(50.0),
                        stacking: .unstacked
                    ) // BAR
                    .foregroundStyle(by: .value("attribute", penguin.attribute))
                    .offset(x: penguin.offset)
                    .annotation {
                        Text(String(format: "%.2f", penguin.measurment))
                    }
                } // CHART
                .frame(minHeight: 300.0)
                .chartXAxis(content: {
                    AxisMarks { (value: AxisValue) in
                        AxisTick(centered: true, length: .label(extendPastBy: -12.0), stroke: .init(lineWidth: 1.0))
                        
                        AxisValueLabel(verticalSpacing: 4.0) {
                            Text(value.as(String.self) ?? "hi")
                        }
                        
                    }
                })
                .chartYAxis {
                    AxisMarks(preset: .aligned, position: .leading, values: [0, 50, 100, 150, 200, 250]) { (value: AxisValue) in
                        AxisValueLabel(horizontalSpacing: 2.0) {
                            Text("\(value.index * 50)")
                        }
                        AxisTick(centered: true, length: .automatic, stroke: .init(lineWidth: 1.0))
                    }
                }
            } // VSTACK
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    GroupedBarChartWithLabels()
}
