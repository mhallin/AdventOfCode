//
//  IntCodeMachine.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-10.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

enum StopReason {
    case halted
    case output(Int64)
    case requiresInput

    func output() -> Int64? {
        switch self {
        case .output(let value):
            return value
        default:
            return nil
        }
    }

    func isHalted() -> Bool {
        switch self {
        case .halted:
            return true
        default:
            return false
        }
    }

    func requiresInput() -> Bool {
        switch self {
        case .requiresInput:
            return true
        default:
            return false
        }
    }
}

class Memory {
    private var data: [Int64]

    init(data: [Int64]) {
        self.data = data
    }

    subscript(index: Int64) -> Int64 {
        get {
            if index >= self.data.count {
                return 0
            } else {
                return self.data[Int(index)]
            }
        }
        set(value) {
            if index >= data.count {
                data.append(contentsOf: Array(repeating: Int64(0), count: Int(index + 1) - data.count))
            }

            data[Int(index)] = value
        }
    }
}

class IntCodeMachine {
    private static let operations: [Int64: (IntCodeMachine) -> (Int64) -> StopReason?] = [
        1: operationAdd,
        2: operationMultiply,
        3: operationInput,
        4: operationOutput,
        5: operationJumpIfTrue,
        6: operationJumpIfFalse,
        7: operationLessThan,
        8: operationEqual,
        9: operationAdjustRP,
        99: operationHalt,
    ]

    private var isp: Int64 = 0
    private var rp: Int64 = 0
    private var memory: Memory
    private var input: [Int64] = []

    init(memory: [Int64]) {
        self.isp = 0
        self.memory = Memory(data: memory)
    }

    func provideInput(_ input: [Int64]) {
        self.input.append(contentsOf: input)
    }

    func run(input: [Int64]) -> StopReason {
        self.input.append(contentsOf: input)

        while true {
            let opcode = self.memory[self.isp]
            if let operation = IntCodeMachine.operations[opcode % 100] {
                if let stopReason = operation(self)(opcode) {
                    return stopReason
                }
            } else {
                assert(false, "Unknown operation \(opcode % 100)")
            }
        }
    }

    func runUntilHalted(input: [Int64]) -> [Int64] {
        var result: [Int64] = []

        self.input.append(contentsOf: input)

        while true {
            let reason = self.run(input: [])
            switch reason {
            case .requiresInput:
                abort()
            case .output(let value):
                result.append(value)
            case .halted:
                return result
            }
        }
    }

    private func store(ispOffset: Int64, mode: Int64, value: Int64) {
        switch mode % 10 {
        case 0:
            self.memory[self.memory[self.isp + ispOffset]] = value
        case 1:
            abort() // Can't store with immediate mode
        case 2:
            self.memory[self.rp + self.memory[self.isp + ispOffset]] = value
        default:
            abort()
        }
    }

    private func fetch(ispOffset: Int64, mode: Int64) -> Int64 {
        switch mode % 10 {
        case 0:
            return self.memory[self.memory[self.isp + ispOffset]]
        case 1:
            return self.memory[self.isp + ispOffset]
        case 2:
            return self.memory[self.rp + self.memory[self.isp + ispOffset]]
        default:
            assert(false, "Unknown address mode \(mode % 10)")
            abort()
        }
    }

    private func operationAdd(opcode: Int64) -> StopReason? {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        self.store(ispOffset: 3, mode: opcode / 10000, value: lhs + rhs)
        self.isp += 4
        return nil
    }

    private func operationMultiply(opcode: Int64) -> StopReason? {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        self.store(ispOffset: 3, mode: opcode / 10000, value: lhs * rhs)
        self.isp += 4
        return nil
    }

    private func operationInput(opcode: Int64) -> StopReason? {
        if self.input.isEmpty {
            return .requiresInput
        }

        self.store(ispOffset: 1, mode: opcode / 100, value: self.input.removeFirst())
        self.isp += 2
        return nil
    }

    private func operationOutput(opcode: Int64) -> StopReason? {
        let result = self.fetch(ispOffset: 1, mode: opcode / 100)
        self.isp += 2
        return .output(result)
    }

    private func operationJumpIfTrue(opcode: Int64) -> StopReason? {
        let condition = self.fetch(ispOffset: 1, mode: opcode / 100)
        let destination = self.fetch(ispOffset: 2, mode: opcode / 1000)

        if condition != 0 {
            self.isp = destination
        } else {
            self.isp += 3
        }
        return nil
    }

    private func operationJumpIfFalse(opcode: Int64) -> StopReason? {
        let condition = self.fetch(ispOffset: 1, mode: opcode / 100)
        let destination = self.fetch(ispOffset: 2, mode: opcode / 1000)

        if condition == 0 {
            self.isp = destination
        } else {
            self.isp += 3
        }
        return nil
    }

    private func operationLessThan(opcode: Int64) -> StopReason? {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        self.store(ispOffset: 3, mode: opcode / 10000, value: lhs < rhs ? 1 : 0)
        self.isp += 4
        return nil
    }

    private func operationEqual(opcode: Int64) -> StopReason? {
        let lhs = self.fetch(ispOffset: 1, mode: opcode / 100)
        let rhs = self.fetch(ispOffset: 2, mode: opcode / 1000)
        self.store(ispOffset: 3, mode: opcode / 10000, value: lhs == rhs ? 1 : 0)
        self.isp += 4
        return nil
    }

    private func operationAdjustRP(opcode: Int64) -> StopReason? {
        let offset = self.fetch(ispOffset: 1, mode: opcode / 100)
        self.rp += offset
        self.isp += 2
        return nil
    }

    private func operationHalt(opcode: Int64) -> StopReason? {
        return .halted
    }
}
