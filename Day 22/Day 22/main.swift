//
//  main.swift
//  Day 22
//
//  Created by Bohac, Peter on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

// A cluster is a set containing the coordinates currently infected.
typealias Cluster = Set<Coordinate>

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    var up: Coordinate { return Coordinate(x: x, y: y - 1) }
    var down: Coordinate { return Coordinate(x: x, y: y + 1) }
    var left: Coordinate { return Coordinate(x: x - 1, y: y) }
    var right: Coordinate { return Coordinate(x: x + 1, y: y) }
}

struct Virus {
    enum Heading: Equatable {
        case up, down, left, right
    }

    var position: Coordinate
    var heading: Heading
    var burstCount = 0
    var infectedCount = 0

    init(position: Coordinate, heading: Heading) {
        self.position = position
        self.heading = heading
    }

    mutating func burst(with cluster: inout Cluster) {
        if cluster.contains(position) {
            // Current position is infected
            switch heading {
            case .up: heading = .right
            case .down: heading = .left
            case .left: heading = .up
            case .right: heading = .down
            }
            cluster.remove(position)
        } else {
            // Current position is clean
            switch heading {
            case .up: heading = .left
            case .down: heading = .right
            case .left: heading = .down
            case .right: heading = .up
            }
            cluster.insert(position)
            infectedCount += 1
        }
        move()
        burstCount += 1
    }

    private mutating func move() {
        switch heading {
        case .up: position = position.up
        case .down: position = position.down
        case .left: position = position.left
        case .right: position = position.right
        }
    }
}

func loadMap(from input: String) -> (cluster: Cluster, center: Coordinate) {
    let lines = input.split(separator: "\n")
    let maxY = lines.count
    let maxX = lines[0].count
    let center = Coordinate(x: maxX / 2, y: maxY / 2)
    var cluster = Cluster()

    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            if char == "#" {
                cluster.insert(Coordinate(x: x, y: y))
            }
        }
    }

    return (cluster, center)
}

var (cluster, center) = loadMap(from: InputData.challenge)
var virus = Virus(position: center, heading: .up)

for _ in 0 ..< 10_000 {
    virus.burst(with: &cluster)
}

print(virus.infectedCount)

// MARK: Part 2

enum NodeState: Equatable {
    case clean, weakened, infected, flagged
}

typealias EnhancedCluster = [Coordinate: NodeState]

struct EnhancedVirus {
    enum Heading: Equatable {
        case up, down, left, right
    }

    var position: Coordinate
    var heading: Heading
    var burstCount = 0
    var infectedCount = 0

    init(position: Coordinate, heading: Heading) {
        self.position = position
        self.heading = heading
    }

    mutating func burst(with cluster: inout EnhancedCluster) {
        let nodeState = cluster[position] ?? .clean
        switch nodeState {
        case .clean:
            turnLeft()
            cluster[position] = .weakened
        case .weakened:
            // no turn
            cluster[position] = .infected
            infectedCount += 1
        case .infected:
            turnRight()
            cluster[position] = .flagged
        case .flagged:
            reverseDirection()
            cluster.removeValue(forKey: position)
        }
        move()
        burstCount += 1
    }

    private mutating func turnRight() {
        switch heading {
        case .up: heading = .right
        case .down: heading = .left
        case .left: heading = .up
        case .right: heading = .down
        }
    }

    private mutating func turnLeft() {
        switch heading {
        case .up: heading = .left
        case .down: heading = .right
        case .left: heading = .down
        case .right: heading = .up
        }
    }

    private mutating func reverseDirection() {
        switch heading {
        case .up: heading = .down
        case .down: heading = .up
        case .left: heading = .right
        case .right: heading = .left
        }
    }

    private mutating func move() {
        switch heading {
        case .up: position = position.up
        case .down: position = position.down
        case .left: position = position.left
        case .right: position = position.right
        }
    }
}

let (cluster2, center2) = loadMap(from: InputData.challenge)
var enhancedCluster = Dictionary(uniqueKeysWithValues: cluster2.map { ($0, NodeState.infected) })
var enhancedVirus = EnhancedVirus(position: center2, heading: .up)

for _ in 0 ..< 10000000 {
    enhancedVirus.burst(with: &enhancedCluster)
}

print(enhancedVirus.infectedCount)
