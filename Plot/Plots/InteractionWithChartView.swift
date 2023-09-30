//
//  InteractionWithChartView.swift
//  Plot
//
//  Created by james seo on 9/30/23.
//

import SwiftUI
import Charts

fileprivate struct Site: Identifiable {
    var id = UUID()
    var hour: Date
    var views: Double
    var animate: Bool = false
    
    static let sample_analytics: [Site] = [
        Site(hour: .now.updateHour(value: 8), views: 1500),
        Site(hour: .now.updateHour(value: 9), views: 2625),
        Site(hour: .now.updateHour(value: 10), views: 7599),
        Site(hour: .now.updateHour(value: 11), views: 3499),
        Site(hour: .now.updateHour(value: 12), views: 5813),
        Site(hour: .now.updateHour(value: 13), views: 4885),
        Site(hour: .now.updateHour(value: 14), views: 1103),
        Site(hour: .now.updateHour(value: 15), views: 4458),
        Site(hour: .now.updateHour(value: 16), views: 4870),
        Site(hour: .now.updateHour(value: 17), views: 9874),
        Site(hour: .now.updateHour(value: 18), views: 7841),
        Site(hour: .now.updateHour(value: 19), views: 129),
        Site(hour: .now.updateHour(value: 20), views: 879),
    ]
}

extension Date {
    func updateHour(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

extension Double {
    var stringFormat: String {
        if self >= 1000 && self < 999999 {
            return String(format: "%.1fk", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999 {
            return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)
    }
}

struct InteractionWithChartView: View {
    @State fileprivate var sampleAnalytics: [Site] = Site.sample_analytics
    @State var currentTab: String = "7 Days"
    @State fileprivate var currentActiveItem: Site?
    @State var plotWidth = 0.0
    @State var isLineGraph: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - NEW CHART API
                VStack(alignment: .leading, spacing: 12, content: {
                    HStack {
                        Text("Views")
                            .fontWeight(.semibold)
                        
                        Picker("", selection: $currentTab) {
                            ForEach(["7 Days", "Week", "Month"], id: \.self) { calendar in
                                Text(calendar).tag(calendar)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading, 80)
                    }
                    
                    let totalValue = sampleAnalytics.reduce(0.0, { $0 + $1.views })
                    
                    Text(totalValue.stringFormat)
                        .font(.largeTitle.bold())
                    
                    AnumatedChart()
                })
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                )
                
                Toggle("Line Graph", isOn: $isLineGraph)
                    .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle("Swift Charts")
            .onChange(of: currentTab) { oldValue, newValue in
                let sample = sampleAnalytics
                if newValue != "7 Days" {
                    for (index, _) in sample.enumerated() {
                        sampleAnalytics[index].views = .random(in: 1500 ... 10000)
                    }
                }
                
                animateGraph(fromChange: true)
                
            }
        }
    }
    
    @ViewBuilder
    func AnumatedChart() -> some View {
        let max = sampleAnalytics.max { item1, item2 in
            return item2.views > item1.views
        }?.views ?? 0
        Chart {
            ForEach(sampleAnalytics) { item in
                
                if isLineGraph {
                    LineMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(.blue.gradient)
                    .interpolationMethod(.catmullRom(alpha: 0.3))
                    
                } else {
                    // BAR GRAPH
                    BarMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                    // MARK: - Rule Mark For Currently Dragging Item
                    if let currentActiveItem, currentActiveItem.id == item.id {
                        RuleMark(x: .value("Hour", currentActiveItem.hour))
                            .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        // MARK: - Setting In Middle Of Each Bars
                            .offset(x: (plotWidth / CGFloat(sampleAnalytics.count)) / 2.0)
                            .annotation(position: .top, spacing: 6) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Views")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    
                                    Text(currentActiveItem.views.stringFormat)
                                        .font(.title3.bold())
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(.white.shadow(.drop(radius: 2)))
                                }
                            }
                    
                }
            }
        }
        .chartOverlay(alignment: .center, content: { proxy in
            GeometryReader(content: { geometry in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                // MARK: Getting Current Location
                                let location = value.location
                                // Extracting Value From The Location
                                // Swift Charts Gives The Direct Ability to do that
                                // We're going to extract the Dae In A-Axis Then with the help of That Date
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: date)
                                    if let currentItem = sampleAnalytics.first(where: { item in
                                        calendar.component(.hour, from: item.hour) == hour
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotSize.width
                                    }
                                }
                            })
                            .onEnded({ value in
                                self.currentActiveItem = nil
                            })
                    )
                    
            })
        })
        .chartYScale(domain: 0...(max + 5000))
        .frame(height: 250)
        .onAppear(perform: {
            animateGraph()
        })
    }
        
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in sampleAnalytics.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
}

#Preview {
    InteractionWithChartView()
}
