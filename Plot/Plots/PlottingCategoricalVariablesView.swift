//
//  PlottingCategoricalVariablesView.swift
//  Plot
//
//  Created by james seo on 9/30/23.
//

import SwiftUI
import Charts

/// link: [https://matplotlib.org/stable/gallery/lines_bars_and_markers/categorical_variables.html#sphx-glr-gallery-lines-bars-and-markers-categorical-variables-py](https://matplotlib.org/stable/gallery/lines_bars_and_markers/categorical_variables.html#sphx-glr-gallery-lines-bars-and-markers-categorical-variables-py)
///
/// You can pass categorical values (i.e. strings) directly as x- or y-values to many plotting functions.
///
/// TODO: making chart to `subplot` style in matplotlib

fileprivate struct Fruit {
    let name: String
    let count: Int
    
    static let dummy: [Fruit] = [
        Fruit(name: "apple", count: 10),
        Fruit(name: "orange", count: 15),
        Fruit(name: "lemon", count: 5),
        Fruit(name: "lime", count: 20),
    ]
}

struct PlottingCategoricalVariablesView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size.width / 3.2
            Text("Categorical Plotting")
                .font(.title2)
                .padding(.top, 8.0)
                .frame(maxWidth: .infinity, alignment: .center)
            
            LazyHStack {
                Chart(Fruit.dummy, id: \.name) { fruit in
                    BarMark(
                        x: .value("name", fruit.name),
                        y: .value("count", fruit.count)
                    ) // BAR
                } // CHART
                .frame(minWidth: size, maxHeight: size)
                
                Chart(Fruit.dummy, id: \.name) { fruit in
                    PointMark(
                        x: .value("name", fruit.name),
                        y: .value("count", fruit.count)
                    ) // POINT
                } // CHART
                .frame(minWidth: size, maxHeight: size)
                
                Chart(Fruit.dummy, id: \.name) { fruit in
                    LineMark(
                        x: .value("name", fruit.name),
                        y: .value("count", fruit.count)
                    ) // LINE
                } // CHART
                .frame(minWidth: size, maxHeight: size)
            } // HSTACK
            .padding()
        })
    }
}

#Preview {
    PlottingCategoricalVariablesView()
}
