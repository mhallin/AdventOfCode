//
//  Day7.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-07.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

let DAY7_PUZZLE_INPUT = [3,8,1001,8,10,8,105,1,0,0,21,30,55,76,97,114,195,276,357,438,99999,3,9,102,3,9,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,2,9,1001,9,2,9,102,2,9,9,4,9,99,3,9,1002,9,5,9,1001,9,2,9,102,5,9,9,1001,9,4,9,4,9,99,3,9,1001,9,4,9,102,5,9,9,101,4,9,9,1002,9,4,9,4,9,99,3,9,101,2,9,9,102,4,9,9,1001,9,5,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99]

func runSingleAmplifierSequence(data: [Int], phases: [Int]) -> Int {
    var output = 0
    for phase in phases {
        let amp = IntCodeMachine(memory: data)
        let result = amp.run(input: [phase, output])
        output = result.output()!
    }
    return output
}

func runFeedbackAmplifierSequence(data: [Int], phases: [Int]) -> Int {
    var output = 0

    let ampA = IntCodeMachine(memory: data)
    let ampB = IntCodeMachine(memory: data)
    let ampC = IntCodeMachine(memory: data)
    let ampD = IntCodeMachine(memory: data)
    let ampE = IntCodeMachine(memory: data)

    let _ = ampA.run(input: [phases[0]])
    let _ = ampB.run(input: [phases[1]])
    let _ = ampC.run(input: [phases[2]])
    let _ = ampD.run(input: [phases[3]])
    let _ = ampE.run(input: [phases[4]])

    while true {
        let outA = ampA.run(input: [output])
        if outA.isHalted() {
            break
        }

        output = ampB.run(input: [outA.output()!]).output()!
        output = ampC.run(input: [output]).output()!
        output = ampD.run(input: [output]).output()!
        output = ampE.run(input: [output]).output()!
    }

    return output
}

func findMaxSequence(data: [Int], from: Int, to: Int, by: ([Int], [Int]) -> Int) -> ([Int], Int) {
    var max = 0
    var maxSequence = [0, 0, 0, 0, 0]
    for a in from...to {
        for b in from...to {
            if b == a {
                continue
            }
            for c in from...to {
                if c == a || c == b {
                    continue
                }
                for d in from...to {
                    if d == a || d == b || d == c {
                        continue
                    }
                    for e in from...to {
                        if e == a || e == b || e == c || e == d {
                            continue
                        }

                        let phases = [a, b, c, d, e]

                        let output = by(data, phases)
                        if output > max {
                            maxSequence = phases
                            max = output
                        }
                    }
                }
            }
        }
    }

    return (maxSequence, max)
}

func day7part1() {
//    let code = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
//    let code = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
//    let code = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
    let sequence = findMaxSequence(data: DAY7_PUZZLE_INPUT, from: 0, to: 4, by: runSingleAmplifierSequence)
    print("Result (part 1): \(sequence)")
}

func day7part2() {
//    let code = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
//    let code = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]
    let sequence = findMaxSequence(data: DAY7_PUZZLE_INPUT, from: 5, to: 9, by: runFeedbackAmplifierSequence(data:phases:))
    print("Result (part 2): \(sequence)")
}

func day7() {
    day7part1()
    day7part2()
}
