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
    case off = 0, s10 = 1, s20 = 2, s30 = 3, s40 = 4, infinite = 5
    var id: Int { rawValue }
    var description: String {
        switch self {
        case .off: return "Off"
        case .s10: return "10s"
        case .s20: return "20s"
        case .s30: return "30s"
        case .s40: return "40s"
        case .infinite: return "∞"
        }
    }
}
