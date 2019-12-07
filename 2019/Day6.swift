//
//  Day6.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-07.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

class OrbitTree {
    private let parentMap: [String: String]
    private let planets: Set<String>

    init(data: String) {
        var parentMap: [String: String] = [:]
        var planets = Set<String>()
        for line in data.split(separator: "\n") {
            let components = line.split(separator: ")")
            parentMap[String(components[1])] = String(components[0])
            planets.insert(String(components[0]))
            planets.insert(String(components[1]))
        }
        self.parentMap = parentMap
        self.planets = planets
    }

    func parent(ofPlanet: String) -> String {
        self.parentMap[ofPlanet]!
    }

    func allPlanets() -> Set<String> {
        self.planets
    }
}

func pathToCOM(_ tree: OrbitTree, planet: String) -> [String] {
    var path: [String] = []
    var planet = planet
    while planet != "COM" {
        planet = tree.parent(ofPlanet: planet)
        path.append(planet)
    }
    return path
}

func distanceToCOM(_ tree: OrbitTree, planet: String) -> Int {
    if planet == "COM" {
        return 0
    } else {
        return 1 + distanceToCOM(tree, planet: tree.parent(ofPlanet: planet))
    }
}

func day6part1() {
    let tree = OrbitTree(data: try! String(contentsOfFile: "Day6.txt"))
    let totalOrbits = tree.allPlanets().map({ distanceToCOM(tree, planet: $0) }).reduce(0, +)
    print("Total orbits (part 1): \(totalOrbits)")
}

func day6part2() {
    let tree = OrbitTree(data: try! String(contentsOfFile: "Day6.txt"))
    var youPath = pathToCOM(tree, planet: "YOU")
    var sanPath = pathToCOM(tree, planet: "SAN")

    while youPath.last! == sanPath.last! {
        youPath.removeLast()
        sanPath.removeLast()
    }

    print("Total transfers (part 2): \(youPath.count + sanPath.count)")
}

func day6() {
    day6part1()
    day6part2()
}
