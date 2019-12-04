//
//  Day4.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-04.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

func isValid(_ value: Int) -> Bool {
    var value = value
    var hasRepeats = false
    var repeatCount = 1
    var lastDigit: Int? = nil
    for _ in 0..<6 {
        let digit = value % 10
        value = value / 10
        if let lastDigit = lastDigit {
            if digit > lastDigit {
                return false
            }
            if digit == lastDigit {
                repeatCount += 1
            } else {
                if repeatCount == 2 {
                    hasRepeats = true
                }
                repeatCount = 1
            }
        }
        lastDigit = digit
    }
    return hasRepeats || repeatCount == 2
}

func day4() {
    print("Count: \((124075...580769).filter(isValid).count)")
}
