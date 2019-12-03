//
//  Day3.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-03.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

struct Point {
	var x: Int
	var y: Int

	func add(_ rhs: Point) -> Point {
		Point(x: self.x + rhs.x, y: self.y + rhs.y)
	}

	func multiply(_ rhs: Int) -> Point {
		Point(x: self.x * rhs, y: self.y * rhs)
	}

	func abs() -> Int {
		return Swift.abs(self.x) + Swift.abs(self.y)
	}
}

extension Point: Hashable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
	}
}

func visitedPoints(_ path: String) -> [Point] {
	var visited: [Point] = []

	var point = Point(x: 0, y: 0)
	for segment in path.split(separator: ",") {
		let count = Int(segment.suffix(from: segment.index(segment.startIndex, offsetBy: 1)))!
		let step: Point

		switch segment[segment.startIndex] {
		case "R":
			step = Point(x: 1, y: 0)

		case "D":
			step = Point(x: 0, y: -1)

		case "L":
			step = Point(x: -1, y: 0)

		case "U":
			step = Point(x: 0, y: 1)

		default:
			assert(false, "Unknown direction \(segment[segment.startIndex])")
			abort()
		}

		let target = point.add(step.multiply(count))

		while point != target {
			point = point.add(step)
			visited.append(point)
		}
	}

	return visited
}

func closestPoint(_ points: Set<Point>) -> Point {
	points.min(by: { $0.abs() < $1.abs() })!
}

func totalPathDistanceTo(_ point: Point, paths: [[Point]]) -> Int {
	paths.map({ $0.firstIndex(of: point)! + 1 }).reduce(0, +)
}

func shortestIntersectionDistance(_ points: Set<Point>, paths: [[Point]]) -> Int {
	points.map({ totalPathDistanceTo($0, paths: paths) }).min()!
}

func day3() {
	let data = try! String(contentsOfFile: "Day3.txt")

	let lines = data.split(separator: "\n")

	let p1 = visitedPoints(String(lines[0]))
	let p2 = visitedPoints(String(lines[1]))

	let common = Set(p1).intersection(p2)
	let closest = closestPoint(common)
	let dist = closest.abs()

	print("Distance to closest intersection (part 1): \(dist)")

	let shortestDist = shortestIntersectionDistance(common, paths: [p1, p2])
	print("Distance to shortest intersection (part 2): \(shortestDist)")
}
