//
//  ContentView.swift
//  HeartRatePoc
//
//  Created by Alejandro Enríquez on 26/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var watchManager = WatchManager()

    var body: some View {
        VStack {
            Text("Heart Rate Monitor")
                .font(.largeTitle)
                .padding()

            // Assuming a heart rate of 0 means no data
            Text("Heart Rate: \(watchManager.heartRate > 0 ? "\(Int(watchManager.heartRate)) BPM" : "No data available")")
                .font(.title2)
                .padding()

            // Check if lastUpdateTime is empty or not
            Text("Last Update: \(watchManager.lastUpdateTime.isEmpty ? "No data available" : watchManager.lastUpdateTime)")
                .font(.caption)
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
