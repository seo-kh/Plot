//
//  BarColorDemoView.swift
//  Plot
//
//  Created by james seo on 9/29/23.
//

import SwiftUI
import Charts

/// Bar color demo
///
/// This is an example showing how to control bar and legend entries using the *color* and *label* parameters of **bar**.
/// Note that labels with a preceding underscore won't show up in the legend.
///
/// link: [https://matplotlib.org/stable/gallery/lines_bars_and_markers/bar_colors.html#sphx-glr-gallery-lines-bars-and-markers-bar-colors-py](https://matplotlib.org/stable/gallery/lines_bars_and_markers/bar_colors.html#sphx-glr-gallery-lines-bars-and-markers-bar-colors-py)
 
struct BarColorDemoView: View {
    let fruits = ["apple", "bluebarry", "cherry", "orange"]
    let counts = [40, 100, 30, 55]
    let labels = ["red", "blue", "yellow", "orange"]
    let colors: [Color] = [.red, .blue, .yellow, .orange]
    
    var body: some View {
        Chart {
            ForEach(fruits.indices, id: \.self) { index in
                BarMark(
                    x: .value("kind", fruits[index]),
                    y: .value("count", counts[index])
                )
                .foregroundStyle(by: .value("color", labels[index]))
            }
        }
        .chartLegend(position: .overlay, alignment: .topTrailing, spacing: 4.0, content: {
            VStack(alignment: .center, spacing: 4.0, content: {
                Text("Fruit Color")
                ForEach(labels.indices, id: \.self) { idx in
                    HStack {
                        Rectangle()
                            .fill(colors[idx])
                        
                        Text(labels[idx])
                    }
                }
            })
            .foregroundStyle(.black)
            .frame(maxWidth: 120.0, maxHeight: 90.0)
            .padding(4.0)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 2.0))
        })
        .chartXAxisLabel(position: .top, alignment: .center, spacing: 16.0, content: {
            Text("Fruit supply by kind and color")
                .font(.title3)
                .fontWeight(.bold)
        })
        .chartYAxisLabel(position: .leading, spacing: 16.0) { Text("fruit supply") }
        .chartForegroundStyleScale(
            [
            labels[0]: colors[0],
            labels[1]: colors[1],
            labels[2]: colors[2],
            labels[3]: colors[3],
            ]
        )
        .padding()
    }
}

#Preview {
    BarColorDemoView()
}
