//
//  Double+BytesToMBit.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 08.04.2024.
//

import Foundation

extension Double {
    // Easy syntax used to show the speed in Mbit/per second
    func bytesToMbit() -> Double {
        self / 1024 / 1024 * 8
    }
}
