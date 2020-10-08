//
//  AccessibleSlider.swift
//  AccessibleSlider
//
//  Created by Max Trauboth on 08.10.20.
//  Copyright © 2020 Max Trauboth. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import SwiftUI

struct AccessibleSlider: View {
    
    // MARK: Initial Parameters
    @Environment(\.colorScheme) var colorScheme
    @State var currentValue: CGFloat                    // the current selected value of the slider
    var maxValue: CGFloat                               // the maximum selectable value
    var unit: String                                    // the unit that is shown next to the current value
    var snapInterval: CGFloat                           // the interval the draggable frame can snap two
    var sliderLabel: String                             // the label of the slider
    
    // MARK: Computed properties
    var sliderCounter: Int {
        Int(round(multiple(of: snapInterval, for: currentValue)))
    }
    var amountSnapPoints: Int {
        Int(self.maxValue/self.snapInterval)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .foregroundColor(Color.init(.systemGray6))
                    .frame(height: 70)
                    .cornerRadius(12)
                
                HStack() {
                    ForEach(0..<self.amountSnapPoints) { id in
                        Rectangle()
                            .foregroundColor(self.color(for: id, amountSnaps: self.amountSnapPoints))
                            .frame(width: 2, height: 8)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
                
                ZStack {
                    HStack {
                        Rectangle()
                            .frame(width: min(geo.size.width * CGFloat(self.currentValue / self.maxValue), geo.size.width-8), height: 62, alignment: .center)
                            .foregroundColor(self.colorScheme == .dark ? Color.init(.systemGray5) : .white)
                            .cornerRadius(12)
                            .padding(.leading, 3)
                            .shadow(color: self.colorScheme == .dark ? Color.init(.systemGray6) : Color.init(.systemGray5), radius: 5, x: 3)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        self.currentValue = min(max(5, (gesture.location.x / geo.size.width * self.maxValue)), geo.size.width)
                                    }
                                    .onEnded { gesture in
                                        withAnimation(.interactiveSpring()) {
                                            self.currentValue = self.multiple(of: self.snapInterval, for: self.currentValue)
                                        }
                                    }
                            )
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(self.sliderLabel)
                            .padding()
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(self.sliderCounter) \(self.unit)")
                            .padding()
                            .foregroundColor(.pink)
                    }
                }
            }
        }
    }
    
    // returns the value after the frame snaps to a certain snap point
    private func multiple(of divisor: CGFloat, for value: CGFloat) -> CGFloat {
        
        let dist = value.remainder(dividingBy: divisor)
        
        if dist < (divisor/2) {
            return value - dist
        } else {
            return value + (divisor - dist)
        }
    }
    
    // returns the color for the snap points
    private func color(for snapId: Int, amountSnaps: Int) -> Color {
        
        if (snapId < Int(0.3 * Double(amountSnaps))) || (snapId > Int(0.8 * Double(amountSnaps))) {
            return Color.init(.systemGray6)
        }
        return Color.init(.systemGray4)
    }
}

struct AccessibleSlider_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccessibleSlider(currentValue: 40.0, maxValue: 120.0, unit: "s", snapInterval: 5, sliderLabel: "Duration").previewLayout(.sizeThatFits)
        }
    }
}
