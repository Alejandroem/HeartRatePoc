import HealthKit
import WatchConnectivity
import SwiftUI

class HealthKitManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var lastHeartRate: Double = 0.0
    private let healthStore = HKHealthStore()

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func requestAuthorization() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let typesToRead: Set = [heartRateType]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            } else {
                self.startHeartRateQuery()
            }
        }
    }

    private func startHeartRateQuery() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { _, samples, _, _, _ in
            self.handleHeartRateSamples(samples)
        }

        query.updateHandler = { _, samples, _, _, _ in
            self.handleHeartRateSamples(samples)
        }

        healthStore.execute(query)
    }

    private func handleHeartRateSamples(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }

        for sample in heartRateSamples {
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self.lastHeartRate = heartRate
                self.sendHeartRateToPhone(heartRate)
            }
        }
    }

    private func sendHeartRateToPhone(_ heartRate: Double) {
        if WCSession.default.isReachable {
            let message = ["heartRate": heartRate]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Error sending heart rate to iPhone: \(error.localizedDescription)")
            })
        }
    }

    // WCSessionDelegate methods
    func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
