//
//  main.swift
//  Day 11
//
//  Created by Peter Bohac on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

enum Step: String {
    case nw, n, ne, se, s, sw
}

extension Step {
    static func load(from input: String) -> [Step] {
        return input.split(separator: ",")
            .map { Step(rawValue: String($0))! }
    }
}

// From: https://www.redblobgames.com/grids/hexagons/
struct Coordinate {
    let x: Int
    let y: Int
    let z: Int

    static let origin = Coordinate(x: 0, y: 0, z: 0)

    var northWest: Coordinate { return Coordinate(x: x - 1, y: y + 1, z: z) }
    var north: Coordinate { return Coordinate(x: x, y: y + 1, z: z - 1) }
    var northEast: Coordinate { return Coordinate(x: x + 1, y: y, z: z - 1) }
    var southEast: Coordinate { return Coordinate(x: x + 1, y: y - 1, z: z) }
    var south: Coordinate { return Coordinate(x: x, y: y - 1, z: z + 1) }
    var southWest: Coordinate { return Coordinate(x: x - 1, y: y, z: z + 1) }

    func distance(to other: Coordinate) -> Int {
        let xDiff = abs(x - other.x)
        let yDiff = abs(y - other.y)
        let zDiff = abs(z - other.z)
        return (xDiff + yDiff + zDiff) / 2
    }
}

extension Step {
    func move(from coordinate: Coordinate) -> Coordinate {
        switch self {
        case .nw: return coordinate.northWest
        case .n: return coordinate.north
        case .ne: return coordinate.northEast
        case .se: return coordinate.southEast
        case .s: return coordinate.south
        case .sw: return coordinate.southWest
        }
    }
}

let steps = Step.load(from: InputData.challenge)

var position = Coordinate.origin
var maxDistance = 0
steps.forEach {
    position = $0.move(from: position)
    maxDistance = max(maxDistance, position.distance(to: .origin))
}

print("Distance:", position.distance(to: .origin))
print("Max distance:", maxDistance)
