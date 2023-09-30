//
//  PlottingTheCoherenceOfTwoSignalsView.swift
//  Plot
//
//  Created by james seo on 9/30/23.
//

import SwiftUI
import Charts

fileprivate struct Noise: Identifiable {
    var id = UUID()
    let time: Double
    let signal: Double
    let series: String
    
    static let dummy: [Noise] = stride(from: 0, through: 30, by: 0.1).map {
        let nse = Double.random(in: -30 ..< 30)
        let signal = cos(2.0 * .pi * 10 * $0) + nse
        return Noise(time: $0, signal: signal, series: "S1")
    }
}

struct PlottingTheCoherenceOfTwoSignalsView: View {
    var body: some View {
        ScrollView {
            VStack {
                Chart(Noise.dummy) { noise in
                    LineMark(
                        x: .value("time", noise.time),
                        y: .value("signal", noise.signal)
                    )
                }
                .chartYAxisLabel("S1 and S2")
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    PlottingTheCoherenceOfTwoSignalsView()
}
