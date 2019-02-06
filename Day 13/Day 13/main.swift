//
//  main.swift
//  Day 13
//
//  Created by Peter Bohac on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

import Foundation

final class Layer {
    let depth: Int
    let range: Int
    var scannerIndex: Int
    var direction: Int

    var severity: Int {
        return depth * range
    }

    init(depth: Int, range: Int) {
        self.depth = depth
        self.range = range
        scannerIndex = 0
        direction = 1
    }

    func reset() {
        scannerIndex = 0
        direction = 1
    }

    func moveScanner() {
        switch (scannerIndex, direction) {
        case (0, -1):
            scannerIndex += 1
            direction = 1
        case (range - 1, 1):
            scannerIndex -= 1
            direction = -1
        default:
            scannerIndex += direction
        }
    }
}

extension Layer {
    static func load(from input: String) -> [Layer] {
        return input.split(separator: "\n").map { line in
            let values = line.split(separator: ":")
                .map { Int($0.trimmingCharacters(in: .whitespaces))! }
            return Layer(depth: values[0], range: values[1])
        }
    }
}

extension Array where Element == Layer {
    mutating func moveScanners() {
        for i in 0 ..< count {
            self[i].moveScanner()
        }
    }
}

func traverse(firewall: [Layer]) -> Int {
    var layers = firewall
    var severity = 0
    let depth = layers.last!.depth

    for currentDepth in 0 ... depth {
        if let layer = layers.first(where: { $0.depth == currentDepth }) {
            severity += layer.scannerIndex == 0 ? layer.severity : 0
        }
        layers.moveScanners()
    }

    return severity
}

let layers = Layer.load(from: InputData.challenge)

let tripSeverity = traverse(firewall: layers)
print("Trip severity:", tripSeverity)

// MARK: Part 2

extension Array where Element == Layer {
    mutating func resetScanners() {
        for i in 0 ..< count {
            self[i].reset()
        }
    }
}

// Brute-force solution... takes too long to solve :(
func findDelayForSuccessfulTraverse(of firewall: [Layer]) -> Int {
    var delay = 1
    var layers = firewall

    // returns whether we were caught
    func traverse(layers: inout [Layer], delay initialDelay: Int = 0) -> Bool {
        let depth = layers.last!.depth

        (0 ..< initialDelay).forEach { _ in layers.moveScanners() }

        for currentDepth in 0 ... depth {
            if let layer = layers.first(where: { $0.depth == currentDepth }), layer.scannerIndex == 0 {
                return true
            }
            layers.moveScanners()
        }

        return false
    }

    while traverse(layers: &layers, delay: delay) {
        delay += 1
        layers.resetScanners()
    }

    return delay
}

//print("Initial delay:", findDelayForSuccessfulTraverse(of: layers))

func findDelay2ForSuccessfulTraverse(of firewall: [Layer]) -> Int {
    let scannerPeriods = firewall.map { layer -> (depth: Int, period: Int) in
        return (layer.depth, layer.range * 2 - 2)
    }
    var delay = 0
    repeat {
        delay += 1
        let positions = scannerPeriods.map { ($0.depth + delay) % $0.period }
        if positions.contains(0) == false {
            break
        }
    } while true

    return delay
}

print("Initial delay:", findDelay2ForSuccessfulTraverse(of: layers))
