//
//  PineToolApp.swift
//  PineTool
//
//  Created by Lachlan Bell on 22/4/2023.
//  Copyright © 2023 Lachlan Bell. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import SwiftUI

@main
struct PineToolApp: App {
    @AppStorage("keep-awake") var keepAwake = true
    // Default to .off (0 minutes) if not set previously
    @AppStorage("sleepTimeout") var sleepTimeoutRawValue: Int = SleepTimeout.off.rawValue

    var sleepTimeout: SleepTimeout {
        get { SleepTimeout(rawValue: sleepTimeoutRawValue) ?? .off }
        set { sleepTimeoutRawValue = newValue.rawValue }
    }

    // Access to PinecilManager
    // We need to ensure PinecilManager is available here to call writeSleepTimeout
    // One way is to instantiate it if ContentView isn't up yet, or pass it around.
    // For now, let's assume it will be accessible via environment or direct instantiation when needed.
    // This part might need refinement based on how PinecilManager is typically accessed for writes.

    var body: some Scene {
        let pinecilManager = PinecilManager() // Instantiate for use in this scope
        WindowGroup {
            ContentView()
                .environmentObject(pinecilManager)
                .onAppear {
                    self.applyAppIdleSettings()
                }
                .onChange(of: keepAwake) { _ in
                    self.applyAppIdleSettings()
                }
                .onChange(of: sleepTimeoutRawValue) { newRawValue in
                    self.applyAppIdleSettings()
                    let newTimeout = SleepTimeout(rawValue: newRawValue) ?? .off
                    // Check if PinecilManager is connected before writing
                    if case .connected = pinecilManager.state {
                        pinecilManager.writeSleepTimeout(newTimeout)
                    } else {
                        print("Pinecil not connected. SleepTimeout change will be applied locally and sent upon next connection (if implemented).")
                        // Future enhancement: Could queue this write for when connection is established.
                    }
                }
        }
    }

    // Renamed to reflect it's about the app's idle timer, not the device's sleep settings directly
    func applyAppIdleSettings() {
        let currentSleepTimeout = SleepTimeout(rawValue: sleepTimeoutRawValue) ?? .off
        if currentSleepTimeout == .off {
            // If Pinecil sleep is off, app's keepAwake setting dictates screen lock
            UIApplication.shared.isIdleTimerDisabled = keepAwake
        } else {
            // If Pinecil has any sleep timeout (including infinite), keep app display awake
            // so user can see Pinecil status until Pinecil itself sleeps.
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}
