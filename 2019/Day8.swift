//
//  Day8.swift
//  AdventOfCode2019
//
//  Created by Magnus Hallin on 2019-12-08.
//  Copyright © 2019 Magnus Hallin. All rights reserved.
//

import Foundation

//let DAY8_PUZZLE_INPUT = (3, 2, "123456789012")
//let DAY8_PUZZLE_INPUT = (2, 2, "0222112222120000")
let DAY8_PUZZLE_INPUT = (25, 6, (try! String(contentsOfFile: "Day8.txt")).trimmingCharacters(in: .whitespacesAndNewlines))

typealias Layer = [[Int]]

func decodeImage(_ data: (Int, Int, String)) -> [Layer] {
    let (width, height, encodedLayers) = data
    let decodedLayers = encodedLayers.map({ Int(String($0))! })

    let digitsPerLayer = width * height

    var layers: [Layer] = []

    for layer in 0..<(encodedLayers.count / digitsPerLayer) {
        let layerStart = layer * digitsPerLayer
        var layer: Layer = []
        for row in 0..<height {
            let rowStart = layerStart + row * width
            let rowEnd = layerStart + (row + 1) * width
            layer.append(Array(decodedLayers[rowStart..<rowEnd]))
        }
        layers.append(layer)
    }

    return layers
}

func mergeLayers(_ a: Layer, _ b: Layer) -> Layer {
    zip(a, b).map({ zip($0.0, $0.1).map({ $0.0 == 2 ? $0.1 : $0.0 }) })
}

func printLayer(_ layer: Layer) {
    for row in layer {
        print(row.map({ $0 == 0 ? " " : "X" }).joined(separator: ""))
    }
}

func day8part1() {
    let layers = decodeImage(DAY8_PUZZLE_INPUT)
    let minLayer = layers.min(by: { $0.flatMap({ $0.filter({ $0 == 0 }) }).count < $1.flatMap({ $0.filter({ $0 == 0 }) }).count })!
    let oneCount = minLayer.map({ $0.filter({ $0 == 1 }).count }).reduce(0, +)
    let twoCount = minLayer.map({ $0.filter({ $0 == 2 }).count }).reduce(0, +)
    print("Result (part 1): \(oneCount * twoCount)")
}

func day8part2() {
    let layers = decodeImage(DAY8_PUZZLE_INPUT)
    let flattened = layers[1...].reduce(layers[0], mergeLayers)
    print("Result (part 2):")
    printLayer(flattened)
}

func day8() {
    day8part1()
    day8part2()
}
