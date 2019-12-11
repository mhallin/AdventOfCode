//
//  Day11.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-11.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

let DAY11_PUZZLE_INPUT: [Int64] = [3,8,1005,8,315,1106,0,11,0,0,0,104,1,104,0,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,101,0,8,29,2,1006,16,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,55,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,76,1,101,17,10,1006,0,3,2,1005,2,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,101,0,8,110,1,107,8,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,135,1,108,19,10,2,7,14,10,2,104,10,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,170,1,1003,12,10,1006,0,98,1006,0,6,1006,0,59,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,205,1,4,18,10,1006,0,53,1006,0,47,1006,0,86,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,1001,8,0,239,2,9,12,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,101,0,8,266,1006,0,8,1,109,12,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,294,101,1,9,9,1007,9,1035,10,1005,10,15,99,109,637,104,0,104,1,21102,936995730328,1,1,21102,1,332,0,1105,1,436,21102,1,937109070740,1,21101,0,343,0,1106,0,436,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,1,179410308187,1,21101,0,390,0,1105,1,436,21101,0,29195603035,1,21102,1,401,0,1106,0,436,3,10,104,0,104,0,3,10,104,0,104,0,21102,825016079204,1,1,21102,1,424,0,1105,1,436,21102,1,825544672020,1,21102,435,1,0,1106,0,436,99,109,2,21202,-1,1,1,21102,1,40,2,21102,467,1,3,21101,0,457,0,1105,1,500,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,462,463,478,4,0,1001,462,1,462,108,4,462,10,1006,10,494,1102,0,1,462,109,-2,2106,0,0,0,109,4,1202,-1,1,499,1207,-3,0,10,1006,10,517,21102,1,0,-3,22101,0,-3,1,22101,0,-2,2,21101,1,0,3,21101,0,536,0,1106,0,541,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,564,2207,-4,-2,10,1006,10,564,21202,-4,1,-4,1105,1,632,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21101,583,0,0,1106,0,541,22102,1,1,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,602,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,624,21202,-1,1,1,21101,624,0,0,106,0,499,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0]

enum Direction {
    case up
    case right
    case down
    case left

    var vector: Point {
        switch self {
        case .up: return Point(x: 0, y: 1)
        case .right: return Point(x: 1, y: 0)
        case .down: return Point(x: 0, y: -1)
        case .left: return Point(x: -1, y: 0)
        }
    }

    func turn(_ leftOrRight: Int64) -> Direction {
        switch (self, leftOrRight) {
        case (.up, 0): return .left
        case (.up, 1): return .right

        case (.right, 0): return .up
        case (.right, 1): return .down

        case (.down, 0): return .right
        case (.down, 1): return .left

        case (.left, 0): return .down
        case (.left, 1): return .up

        default: abort()
        }
    }
}

func runRobotProgram(machine: IntCodeMachine, startColor: Int64) -> [Point: Int64] {
    var direction = Direction.up
    var position = Point(x: 0, y: 0)
    var colors: [Point: Int64] = [position: startColor]

    while true {
        switch machine.run(input: [colors[position] != nil ? colors[position]! : Int64(0)]) {
        case .halted:
            return colors
        case .requiresInput:
            abort()
        case .output(let color):
            let turn = machine.run(input: []).output()!
            colors[position] = color

            direction = direction.turn(turn)
            position += direction.vector
        }
    }
}

func day11part1() {
    let colors = runRobotProgram(machine: IntCodeMachine(memory: DAY11_PUZZLE_INPUT), startColor: 0)

    print("Covered panels (part 1): \(colors.count)")
}

func day11part2() {
    let colors = runRobotProgram(machine: IntCodeMachine(memory: DAY11_PUZZLE_INPUT), startColor: 1)

    let minX = colors.map({ $0.0.x }).min()!
    let maxX = colors.map({ $0.0.x }).max()!
    let minY = colors.map({ $0.0.y }).min()!
    let maxY = colors.map({ $0.0.y }).max()!

    let width = maxX - minX
    let height = maxY - minY
    
    var lines = (0...height).map({ _ in Array(repeating: " ", count: width + 1) })

    for point in colors.filter({ $0.1 == 1 }).keys {
        lines[point.y - minY][point.x - minX] = "X"
    }

    let mergedLines = lines.reversed().map({ $0.joined() }).joined(separator: "\n")
    print("Registration plate (part 2): \n\(mergedLines)")
}

func day11() {
    day11part1()
    day11part2()
}
