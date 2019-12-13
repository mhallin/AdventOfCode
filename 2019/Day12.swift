//
//  Day12.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-12.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

func velocityDifference(from: Int, to: Int) -> Int {
    if from < to {
        return -1
    } else if from > to {
        return 1
    } else {
        return 0
    }
}

struct Moon {
    let x: Int
    let y: Int
    let z: Int

    let vx: Int
    let vy: Int
    let vz: Int

    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.vx = 0
        self.vy = 0
        self.vz = 0
    }

    init(x: Int, y: Int, z: Int, vx: Int, vy: Int, vz: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.vx = vx
        self.vy = vy
        self.vz = vz
    }

    func withInfluence(_ from: Moon) -> Moon {
        return Moon(
            x: self.x,
            y: self.y,
            z: self.z,
            vx: self.vx + velocityDifference(from: from.x, to: self.x),
            vy: self.vy + velocityDifference(from: from.y, to: self.y),
            vz: self.vz + velocityDifference(from: from.z, to: self.z)
        )
    }

    func tick() -> Moon {
        return Moon(
            x: self.x + self.vx,
            y: self.y + self.vy,
            z: self.z + self.vz,
            vx: self.vx,
            vy: self.vy,
            vz: self.vz
        )
    }

    var kineticEnergy: Int { abs(self.vx) + abs(self.vy) + abs(self.vz) }
    var potentialEnergy: Int { abs(self.x) + abs(self.y) + abs(self.z)}
    var energy: Int { kineticEnergy * potentialEnergy }
}

let DAY12_SAMPLE_1: [Moon] = [
    Moon(x: -1, y: 0, z: 2),
    Moon(x: 2, y: -10, z: -7),
    Moon(x: 4, y: -8, z: 8),
    Moon(x: 3, y: 5, z: -1)
]

let DAY12_SAMPLE_2: [Moon] = [
    Moon(x: -8, y: -10, z: 0),
    Moon(x: 5, y: 5, z: 10),
    Moon(x: 2, y: -7, z: 3),
    Moon(x: 9, y: -8, z: -3)
]

let DAY12_PUZZLE_INPUT: [Moon] = [
    Moon(x: -7, y: 17, z: -11),
    Moon(x: 9, y: 12, z: 5),
    Moon(x: -9, y: 0, z: -4),
    Moon(x: 4, y: 6, z: 0)
]

func applyInfluences(_ moons: [Moon]) -> [Moon] {
    moons.map({ moons.reduce($0, { $0.withInfluence($1) }) })
}

func tick(_ moons: [Moon]) -> [Moon] {
    moons.map({ $0.tick() })
}

func day12part1() {
    var result = DAY12_PUZZLE_INPUT
    for _ in 0..<1000 {
        result = tick(applyInfluences(result))
    }
    print("Result: \(result)")
    let energy = result.reduce(0, { $0 + $1.energy })
    print("Total energy (part 1): \(energy)")
}

func day12part2() {
}

func day12() {
    day12part1()
    day12part2()
}
