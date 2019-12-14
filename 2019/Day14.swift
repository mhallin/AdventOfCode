//
//  Day14.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-14.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

enum Chemical {
    case ore
    case fuel
    case element(String)

    static func parse(_ string: String) -> Chemical {
        switch string {
        case "ORE": return .ore
        case "FUEL": return .fuel
        default: return .element(string)
        }
    }
}

extension Chemical: Hashable {
    static func ==(lhs: Chemical, rhs: Chemical) -> Bool {
        switch (lhs, rhs) {
        case (.ore, .ore):
            fallthrough
        case (.fuel, .fuel):
            return true
        case (.element(let lhs), .element(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .ore:
            hasher.combine(0)
        case .fuel:
            hasher.combine(1)
        case .element(let element):
            hasher.combine(element)
        }
    }
}

struct Reaction {
    let from: [(Chemical, Int64)]
    let to: (Chemical, Int64)

    static func parse(_ string: String) -> Reaction {
        let parts = string.components(separatedBy: " => ")
        assert(parts.count == 2)

        let from = parts[0].components(separatedBy: ", ").map({ part -> (Chemical, Int64) in
            let parts = part.split(separator: " ")
            return (Chemical.parse(String(parts[1])), Int64(parts[0])!)
        })

        let toParts = parts[1].split(separator: " ")
        let to = (Chemical.parse(String(toParts[1])), Int64(toParts[0])!)

        return Reaction(from: from, to: to)
    }
}

class Reactions {
    let allReactions: [Chemical: Reaction]
    let producedFromOre: [Chemical: Reaction]

    init(file: String) {
        let source = try! String(contentsOfFile: file)

        var allReactions: [Chemical: Reaction] = [:]
        var producedFromOre: [Chemical: Reaction] = [:]

        for line in source.split(separator: "\n") {
            let reaction = Reaction.parse(line.trimmingCharacters(in: .whitespacesAndNewlines))
            assert(allReactions[reaction.to.0] == nil)
            allReactions[reaction.to.0] = reaction

            if reaction.from.contains(where: { $0.0 == .ore }) {
                assert(reaction.from.count == 1)
                producedFromOre[reaction.to.0] = reaction
            }
        }

        self.allReactions = allReactions
        self.producedFromOre = producedFromOre
    }

    subscript(index: Chemical) -> Reaction {
        allReactions[index]!
    }
}

class Nanofactory {
    let reactions: Reactions
    var totalOreMined: Int64 = 0
    var storage: [Chemical: Int64] = [:]

    init(reactions: Reactions) {
        self.reactions = reactions
    }

    func produce(reaction: Reaction) {
        for (fromChemical, fromCount) in reaction.from {
            while (storage[fromChemical] ?? 0) < fromCount {
                if fromChemical == .ore {
                    self.totalOreMined += fromCount
                    storage[.ore] = (storage[.ore] ?? 0) + fromCount
                } else {
                    produce(reaction: reactions[fromChemical])
                }
            }

            storage[fromChemical] = storage[fromChemical]! - fromCount
            assert(storage[fromChemical]! >= 0)
        }

        storage[reaction.to.0] = (storage[reaction.to.0] ?? 0) + reaction.to.1
    }
}

func day14part1() {
    let reactions = Reactions(file: "Day14.txt")
    let factory = Nanofactory(reactions: reactions)
    factory.produce(reaction: reactions[.fuel])
    print("Total ore mined (part 1): \(factory.totalOreMined)")
}

func day14part2() {
}

func day14() {
    day14part1()
    day14part2()
}
