import WatchConnectivity
import SwiftUI

class WatchManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var heartRate: Double = 0.0
    @Published var lastUpdateTime: String = "No data received"

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_: WCSession, didReceiveMessage message: [String: Any]) {
        if let heartRate = message["heartRate"] as? Double {
            DispatchQueue.main.async {
                self.heartRate = heartRate
                self.lastUpdateTime = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            }
        }
    }

    // WCSessionDelegate required methods
    func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_: WCSession) {}
    func sessionDidDeactivate(_: WCSession) {}
}
