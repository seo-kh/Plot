//
//  ContentView.swift
//  Plot
//
//  Created by james seo on 9/29/23.
//

import SwiftUI

enum PlotSection: String, Identifiable, Hashable, CaseIterable {
    case barColorDemo = "Bar Color demo"
    case barLabelDemo = "Bar Label Demo"
    case groupedBarChartWithLabels = "Grouped bar chart with labels"
    case plottingCategoricalVariables = "Plotting categorical variables"
    case plottingTheCoherenceOfTowSignals = "Plotting the coherence of two signals"
    case interactionWithChart = "Interaction with chart"
    
    var id: Int { self.hashValue }
}

struct ContentView: View {
    @State private var selection: PlotSection = .barColorDemo
    
    var body: some View {
        NavigationSplitView {
            List(PlotSection.allCases, selection: $selection) { section in
                Text(section.rawValue).tag(section)
            }
        } detail: {
            switch selection {
            case .barColorDemo:
                BarColorDemoView()
                    .navigationTitle(selection.rawValue)
            case .barLabelDemo:
                BarLabelDemoView()
                    .navigationTitle(selection.rawValue)
            case .groupedBarChartWithLabels:
                GroupedBarChartWithLabels()
                    .navigationTitle(selection.rawValue)
            case .plottingCategoricalVariables:
                PlottingCategoricalVariablesView()
                    .navigationTitle(selection.rawValue)
            case .plottingTheCoherenceOfTowSignals:
                PlottingTheCoherenceOfTwoSignalsView()
                    .navigationTitle(selection.rawValue)
            case .interactionWithChart:
                InteractionWithChartView()
                    .navigationTitle(selection.rawValue)
            }
        }

    }
}

#Preview {
    ContentView()
}
