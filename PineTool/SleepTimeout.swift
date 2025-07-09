//
//  SleepTimeout.swift
//  PineTool
//
//  Created by Jules on 29/7/2024.
//  Copyright © 2024 Lachlan Bell. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation

enum SleepTimeout: Int, CaseIterable, Identifiable {
    case off = 0
    case m1 = 1
    case m2 = 2
    case m5 = 5
    case m10 = 10
    case m30 = 30
    case infinite = 999 // Using 999 for infinite as per discussion

    var id: Int { rawValue }

    var description: String {
        switch self {
        case .off: return "Off"
        case .m1: return "1 min"
        case .m2: return "2 mins"
        case .m5: return "5 mins"
        case .m10: return "10 mins"
        case .m30: return "30 mins"
        case .infinite: return "Infinite (∞)" // Mapped to 999 minutes
        }
    }

    // Helper to explicitly show what value is sent to device
    var minutesForDevice: UInt16 {
        return UInt16(self.rawValue)
    }
}
