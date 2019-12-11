//
//  Day10.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-10.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

func parseMap(filename: String) -> (Set<Point>, Int, Int) {
    let textMap = try! String(contentsOfFile: filename)

    var map = Set<Point>()
    var width = 0
    var height = 0

    for (y, line) in textMap.split(separator: "\n").enumerated() {
        for (x, char) in line.enumerated() {
            if char == "#" {
                map.insert(Point(x: x, y: y))
                width = max(width, x + 1)
                height = max(height, y + 1)
            }
        }
    }

    return (map, width, height)
}

func gcd(_ a: Int, _ b: Int) -> Int {
    if b == 0 {
        return a
    } else {
        return gcd(b, a % b)
    }
}

func minimize(_ point: Point) -> Point {
    assert(point.x != 0 || point.y != 0)
    if point.x == 0 {
        return Point(x: 0, y: point.y < 0 ? -1 : 1)
    } else if point.y == 0 {
        return Point(x: point.x < 0 ? -1 : 1, y: 0)
    } else {
        let divisor = abs(gcd(point.x, point.y))
        return Point(x: point.x / divisor, y: point.y / divisor)
    }
}

func removeOccluded(map: Set<Point>, width: Int, height: Int, from: Point) -> Set<Point> {
    var resultMap = map
    resultMap.remove(from)

    for target in map {
        if !resultMap.contains(target) {
            continue
        }

        if target != from {
            let delta = minimize(target - from)
            var occluded = target + delta
            while occluded.x >= 0 && occluded.y >= 0 && occluded.x < width && occluded.y < height {
                if resultMap.contains(occluded) {
                    resultMap.remove(occluded)
                }
                occluded += delta
            }
        }
    }

    return resultMap
}

func findMaximumVisible(map: Set<Point>, width: Int, height: Int) -> (Point, Int) {
    map
        .map({ ($0, removeOccluded(map: map, width: width, height: height, from: $0).count) })
        .max(by: { $0.1 < $1.1 })!
}

func day10part1() {
    let (map, width, height) = parseMap(filename: "Day10.txt")

    let maximumVisible = findMaximumVisible(map: map, width: width, height: height)
    print("Maximum visible count (part 1): \(maximumVisible)")
}

func day10part2() {
    var (map, width, height) = parseMap(filename: "Day10.txt")
    let (origin, _) = findMaximumVisible(map: map, width: width, height: height)

    var i = 0
    while !map.isEmpty {
        let visible = removeOccluded(map: map, width: width, height: height, from: origin)
        map = map.symmetricDifference(visible)

        let destroyedInOrder = visible
            .map({ ($0, ($0 - origin).angle * 180.0 / Float.pi) })
            .sorted(by: { $0.1 > $1.1 })

        if i + destroyedInOrder.count > 200 {
            print("200th destroyed at (part 2): \(destroyedInOrder[200 - i - 1])")
            break
        }

        i += destroyedInOrder.count
    }
}

func day10() {
    day10part1()
    day10part2()
}
