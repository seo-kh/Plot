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
            case .barLabelDemo:
                BarLabelDemoView()
                    .navigationTitle("Plot")
            }
        }

    }
}

#Preview {
    ContentView()
}
