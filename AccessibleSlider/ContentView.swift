//
//  ContentView.swift
//  AccessibleSlider
//
//  Created by Max Trauboth on 08.10.20.
//  Copyright © 2020 Max Trauboth. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
         AccessibleSlider(currentValue: 40.0, maxValue: 120.0, unit: "s", snapInterval: 5, sliderLabel: "Duration")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
