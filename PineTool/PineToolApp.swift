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
    @AppStorage("sleepTimeout") private var sleepTimeoutRawValue: Int = SleepTimeout.off.rawValue

    var sleepTimeout: SleepTimeout {
        get { SleepTimeout(rawValue: sleepTimeoutRawValue) ?? .off }
        set { sleepTimeoutRawValue = newValue.rawValue }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PinecilManager())
                .onAppear {
                    self.applySleepSettings()
                }
                .onChange(of: keepAwake) { _ in
                    self.applySleepSettings()
                }
                .onChange(of: sleepTimeoutRawValue) { _ in
                    self.applySleepSettings()
                }
        }
    }

    func applySleepSettings() {
        if sleepTimeout == .off {
            UIApplication.shared.isIdleTimerDisabled = keepAwake
        } else if sleepTimeout == .infinite {
            UIApplication.shared.isIdleTimerDisabled = true
        } else {
            // Placeholder for timer logic
            // For now, we'll just disable idle timer immediately if a timeout is set.
            // In a real implementation, a timer would be started here.
            UIApplication.shared.isIdleTimerDisabled = true
            print("Sleep timeout set to \(sleepTimeout.description). Timer logic to be implemented.")
        }
    }
}
