//
//  Reward.swift
//  SpinTheWheelGame
//
//  Created by Shane Bersiek on 8/2/21.
//

import Foundation

let halfSector = 360.0 / 37.0 / 2.0

struct Reward: Codable, Equatable {
    var id: String?
    var displayText: String?
    var value: Int?
    var currency: String?
}



