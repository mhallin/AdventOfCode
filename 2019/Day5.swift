//
//  Day5.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-07.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

let PUZZLE_INPUT: [Int] = [3,225,1,225,6,6,1100,1,238,225,104,0,1,191,196,224,1001,224,-85,224,4,224,1002,223,8,223,1001,224,4,224,1,223,224,223,1101,45,50,225,1102,61,82,225,101,44,39,224,101,-105,224,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,102,14,187,224,101,-784,224,224,4,224,102,8,223,223,101,7,224,224,1,224,223,223,1001,184,31,224,1001,224,-118,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1102,91,18,225,2,35,110,224,101,-810,224,224,4,224,102,8,223,223,101,3,224,224,1,223,224,223,1101,76,71,224,1001,224,-147,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,1101,7,16,225,1102,71,76,224,101,-5396,224,224,4,224,1002,223,8,223,101,5,224,224,1,224,223,223,1101,72,87,225,1101,56,77,225,1102,70,31,225,1102,29,15,225,1002,158,14,224,1001,224,-224,224,4,224,102,8,223,223,101,1,224,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1007,226,226,224,1002,223,2,223,1006,224,329,1001,223,1,223,8,226,677,224,1002,223,2,223,1005,224,344,1001,223,1,223,107,226,677,224,1002,223,2,223,1006,224,359,1001,223,1,223,8,677,677,224,1002,223,2,223,1005,224,374,1001,223,1,223,1108,226,226,224,1002,223,2,223,1005,224,389,1001,223,1,223,7,677,226,224,1002,223,2,223,1005,224,404,101,1,223,223,7,226,226,224,102,2,223,223,1006,224,419,1001,223,1,223,1108,226,677,224,102,2,223,223,1005,224,434,1001,223,1,223,1107,226,226,224,1002,223,2,223,1006,224,449,1001,223,1,223,1007,677,677,224,102,2,223,223,1006,224,464,1001,223,1,223,107,226,226,224,1002,223,2,223,1005,224,479,101,1,223,223,1107,677,226,224,1002,223,2,223,1005,224,494,1001,223,1,223,1008,677,677,224,102,2,223,223,1005,224,509,101,1,223,223,107,677,677,224,102,2,223,223,1005,224,524,1001,223,1,223,1108,677,226,224,1002,223,2,223,1005,224,539,1001,223,1,223,7,226,677,224,102,2,223,223,1006,224,554,1001,223,1,223,8,677,226,224,1002,223,2,223,1006,224,569,101,1,223,223,108,226,226,224,1002,223,2,223,1006,224,584,1001,223,1,223,1107,226,677,224,1002,223,2,223,1006,224,599,101,1,223,223,1008,226,226,224,102,2,223,223,1005,224,614,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,629,1001,223,1,223,108,677,226,224,102,2,223,223,1005,224,644,101,1,223,223,1008,226,677,224,1002,223,2,223,1005,224,659,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,674,1001,223,1,223,4,223,99,226]

class IntCodeMachine {
    private static let operations: [Int: (IntCodeMachine) -> (Int) -> ()] = [
        1: operationAdd,
        2: operationMultiply,
        3: operationInput,
        4: operationOutput,
        5: operationJumpIfTrue,
        6: operationJumpIfFalse,
        7: operationLessThan,
        8: operationEqual,
        99: operationHalt,
    ]

    private var isp: Int = 0
    private var memory: [Int]
    private var isRunning: Bool = false
    private var input: [Int] = []
    private var output: [Int] = []

    init(memory: [Int]) {
        self.memory = memory
    }

    func run(input: [Int]) -> [Int] {
        self.isRunning = true
        self.isp = 0
        self.input = input
        self.output.removeAll()

        while self.isRunning {
            let opcode = self.memory[self.isp]
            if let operation = IntCodeMachine.operations[opcode % 100] {
                operation(self)(opcode)
            } else {
                assert(false, "Unknown operation \(opcode % 100)")
            }
        }

        return self.output
    }

    private func fetch(ispOffset: Int, mode: Int) -> Int {
        switch mode % 10 {
        case 0:
            return self.memory[self.memory[self.isp + ispOffset]]
        case 1:
            return self.memory[self.isp + ispOffset]
        default:
            assert(false, "Unknown address mode \(mode % 10)")
            abort()
        }
    }

    private func operationAdd(opcode: Int) {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        let resultPtr = self.memory[self.isp + 3]
        self.isp += 4
        self.memory[resultPtr] = lhs + rhs
    }

    private func operationMultiply(opcode: Int) {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        let resultPtr = self.memory[self.isp + 3]
        self.isp += 4
        self.memory[resultPtr] = lhs * rhs
    }

    private func operationInput(opcode: Int) {
        let resultPtr = self.memory[self.isp + 1]
        self.isp += 2
        self.memory[resultPtr] = self.input.removeFirst()
    }

    private func operationOutput(opcode: Int) {
        let result = self.fetch(ispOffset: 1, mode: opcode / 100)
        self.isp += 2
        self.output.append(result)
    }

    private func operationJumpIfTrue(opcode: Int) {
        let condition = self.fetch(ispOffset: 1, mode: opcode / 100)
        let destination = self.fetch(ispOffset: 2, mode: opcode / 1000)

        if condition != 0 {
            self.isp = destination
        } else {
            self.isp += 3
        }
    }

    private func operationJumpIfFalse(opcode: Int) {
        let condition = self.fetch(ispOffset: 1, mode: opcode / 100)
        let destination = self.fetch(ispOffset: 2, mode: opcode / 1000)

        if condition == 0 {
            self.isp = destination
        } else {
            self.isp += 3
        }
    }

    private func operationLessThan(opcode: Int) {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        let resultPtr = self.memory[self.isp + 3]

        self.memory[resultPtr] = lhs < rhs ? 1 : 0
        self.isp += 4
    }

    private func operationEqual(opcode: Int) {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        let resultPtr = self.memory[self.isp + 3]

        self.memory[resultPtr] = lhs == rhs ? 1 : 0
        self.isp += 4
    }

    private func operationHalt(opcode: Int) {
        self.isRunning = false
    }
}

func day5part1() {
    let machine = IntCodeMachine(memory: PUZZLE_INPUT)
    let output = machine.run(input: [1])
    print("Output (part 1): \(output)")
}

func day5part2() {
    let machine = IntCodeMachine(memory: PUZZLE_INPUT)
    let output = machine.run(input: [5])
    print("Output (part 2): \(output)")
}

func day5() {
    day5part1()
    day5part2()
}
