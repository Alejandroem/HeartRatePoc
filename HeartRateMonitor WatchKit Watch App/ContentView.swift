//
//  ContentView.swift
//  HeartRateMonitor WatchKit Watch App
//
//  Created by Alejandro Enríquez on 26/10/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()

        var body: some View {
            VStack {
                Text("Heart Rate")
                    .font(.title)
                Text("\(Int(healthKitManager.lastHeartRate)) BPM")
                    .font(.title2)
                    .padding()
            }
            .onAppear {
                healthKitManager.requestAuthorization()
            }
        }
}

#Preview {
    ContentView()
}
