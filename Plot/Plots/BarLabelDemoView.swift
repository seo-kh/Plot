//
//  BarLabelDemoView.swift
//  Plot
//
//  Created by james seo on 9/29/23.
//

import SwiftUI
import Charts

/// link: [https://matplotlib.org/stable/gallery/lines_bars_and_markers/bar_label_demo.html](https://matplotlib.org/stable/gallery/lines_bars_and_markers/bar_label_demo.html)
///
/// Customizing axes in swift charts
///
/// improve the clarity of your chart by configuring the appearance of its axes.
///
/// **overview**
///  swift charts automatyily configures the axes in your charts based on the data that you specify.
///  sometimes you can communicate the data more clearly by customizing the axis configuration.
///  For example, you can:
///  - specify a range for an axis.
///  - choose the specific values - like categories, dates or numbers - the axes display.
///  - set the visual style of grid lines, ticks, or labels that represent each value.
///
///  this article demonstrates how to use these features to create the following chart that displays battery levels over the course of a day
///
///  ## start with default axes
///  generating a chart using the framework default axis configuration typically provides a good foundation to start from.
/// For example, the following code creates a basic battery chart from an array of data points:
///

fileprivate struct BatteryData {
    let date: Date
    let level: Int
    
    static let data: [BatteryData]  = [
        BatteryData(date: .now, level: 100),
        BatteryData(date: .now.addingTimeInterval(1 * 60 * 60), level: 100 - 1),
        BatteryData(date: .now.addingTimeInterval(2 * 60 * 60), level: 100 - 3),
        BatteryData(date: .now.addingTimeInterval(3 * 60 * 60), level: 100 - 5),
        BatteryData(date: .now.addingTimeInterval(4 * 60 * 60), level: 100 - 9),
        BatteryData(date: .now.addingTimeInterval(5 * 60 * 60), level: 100 - 11),
        BatteryData(date: .now.addingTimeInterval(6 * 60 * 60), level: 100 - 21),
        BatteryData(date: .now.addingTimeInterval(7 * 60 * 60), level: 100 - 24),
        BatteryData(date: .now.addingTimeInterval(8 * 60 * 60), level: 100 - 28),
        BatteryData(date: .now.addingTimeInterval(9 * 60 * 60), level: 100 - 30),
        BatteryData(date: .now.addingTimeInterval(10 * 60 * 60), level: 100 - 31),
        BatteryData(date: .now.addingTimeInterval(11 * 60 * 60), level: 100 - 32),
        BatteryData(date: .now.addingTimeInterval(12 * 60 * 60), level: 100 - 33),
        BatteryData(date: .now.addingTimeInterval(13 * 60 * 60), level: 100 - 49),
        BatteryData(date: .now.addingTimeInterval(14 * 60 * 60), level: 100 - 50),
        BatteryData(date: .now.addingTimeInterval(15 * 60 * 60), level: 100 - 52),
        BatteryData(date: .now.addingTimeInterval(16 * 60 * 60), level: 100 - 53),
        BatteryData(date: .now.addingTimeInterval(17 * 60 * 60), level: 100 - 55),
        BatteryData(date: .now.addingTimeInterval(18 * 60 * 60), level: 100 - 58),
        BatteryData(date: .now.addingTimeInterval(19 * 60 * 60), level: 100 - 59),
        BatteryData(date: .now.addingTimeInterval(20 * 60 * 60), level: 100 - 80),
        BatteryData(date: .now.addingTimeInterval(21 * 60 * 60), level: 100 - 85),
        BatteryData(date: .now.addingTimeInterval(22 * 60 * 60), level: 100 - 88),
        BatteryData(date: .now.addingTimeInterval(23 * 60 * 60), level: 100 - 90),
    ]
}

fileprivate struct Species: Identifiable {
    let name: String
    let sex: String
    let number: Int
    var id = UUID()
    
    static let dummy: [Species] = [
        Species(name: "Adelie", sex: "male", number: 73),
        Species(name: "Adelie", sex: "female", number: 73),
        Species(name: "Chinstrap", sex: "male", number: 34),
        Species(name: "Chinstrap", sex: "female", number: 34),
        Species(name: "Gentoo", sex: "male", number: 61),
        Species(name: "Gentoo", sex: "female", number: 58),
    ]
}

fileprivate struct Reproducibility {
    let name: String
    let performance: Int
    
    static let dummy: [Reproducibility] = [
        Reproducibility(name: "Tom", performance: Int.random(in: 5..<15)),
        Reproducibility(name: "Dick", performance: Int.random(in: 5..<15)),
        Reproducibility(name: "Harrt", performance: Int.random(in: 5..<15)),
        Reproducibility(name: "Slim", performance: Int.random(in: 5..<15)),
        Reproducibility(name: "Jim", performance: Int.random(in: 5..<15)),
    ]
}

struct BarLabelDemoView: View {
    let width = 0.6
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 32.0) {
                
                Chart(BatteryData.data, id: \.date) {
                    BarMark(
                        x: .value("Time", $0.date ..< $0.date.advanced(by: 1800)),
                        y: .value("Battery Level", $0.level)
                    )
                    .foregroundStyle(by: .value("level", $0.level))
                }
                .chartOverlay(alignment: .top, content: { proxy in
                    Text("Battery per hour")
                        .font(.headline)
                })
                .chartForegroundStyleScale(mapping: { (value: Int) -> Color in
                    if value > 60 {
                        return .green
                    } else if value > 20 {
                        return .yellow
                    } else {
                        return .red
                    }
                })
                .frame(minHeight: 300.0)
                .chartXAxis(content: {
                    AxisMarks(preset: .automatic, position: .automatic, values: .stride(by: .hour, count: 3)) { value in
                        if let date = value.as(Date.self) {
                            let hour = Calendar.current.component(.hour, from: date)
                            AxisValueLabel {
                                VStack(alignment: .leading) {
                                    switch hour {
                                    case 0, 12:
                                        Text(date, format: .dateTime.hour())
                                    default:
                                        Text(date, format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
                                    }
                                    
                                    if value.index == 0 || hour == 0 {
                                        Text(date, format: .dateTime.month().day())
                                    }
                                }
                            }
                            
                            if hour == 0 {
                                AxisGridLine(stroke: .init(lineWidth: 0.5))
                                AxisTick(stroke: .init(lineWidth: 0.5))
                            } else {
                                AxisGridLine()
                                AxisTick()
                            }
                        }
                        
                    }
                })
                .chartYScale(domain: [0, 100])
                .chartYAxis {
                    AxisMarks(values: [0, 50, 100]) {
                        AxisValueLabel(format: Decimal.FormatStyle.Percent.percent.scale(1))
                            .font(.headline)
                    }
                    
                    AxisMarks(values: [0, 25, 50, 75, 100]) {
                        AxisGridLine()
                    }
                    
                    AxisMarks(values: [20, 40, 60, 80]) {
                        AxisTick(centered: true, length: .label(extendPastBy: 16.0), stroke: .init(lineWidth: 2))
                    }
                }
                
                Chart(Reproducibility.dummy, id: \.name) { person in
                    BarMark(
                        x: .value("performance", person.performance),
                        y: .value("name", person.name)
                    )
                    
                    RuleMark(
                        xStart: .value("performance-lowerbound", person.performance - 1),
                        xEnd: .value("performance-upperbound", person.performance + 1),
                        y: .value("name", person.name)
                    )
                    .foregroundStyle(.gray)
                    .annotation(position: .trailing, alignment: .center, spacing: 8.0) {
                        Text("\(person.performance)")
                    }
                }
                .frame(minHeight: 300.0)
                .chartYScale(range: .plotDimension(startPadding: 30.0, endPadding: 0.0))
                .chartOverlay(alignment: .top) { _ in
                    Text("How fast do you want to go today?")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Chart(Species.dummy) { species in
                    BarMark(
                        x: .value("name", species.name),
                        y: .value("number", species.number)
                    ) // BARMARK
                    .foregroundStyle(by: .value("sex", species.sex))
                    .annotation(position: .overlay, alignment: .center, spacing: 0.0) {
                        Text("\(species.number)")
                            .fontWeight(.bold)
                    }
                } // CHART
                .frame(minHeight: 300.0)
                .chartForegroundStyleScale(mapping: { (value: String) -> Color in
                    if value == "male" { return .blue }
                    else { return .orange }
                })
                .chartYScale(range: .plotDimension(startPadding: 0, endPadding: 30.0))
                .chartOverlay(alignment: .top, content: { proxy in
                    Text("Number of penguins by sex")
                        .font(.title2)
                        .fontWeight(.bold)
                })
            } // VSTACK
            .padding()
        } // SCROLL
    }
}

#Preview {
    BarLabelDemoView()
}
