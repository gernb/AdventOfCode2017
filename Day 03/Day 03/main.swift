//
//  main.swift
//  Day 03
//
//  Created by Peter Bohac on 2/4/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    var up: Coordinate { return Coordinate(x: x, y: y - 1) }
    var down: Coordinate { return Coordinate(x: x, y: y + 1) }
    var left: Coordinate { return Coordinate(x: x - 1, y: y) }
    var right: Coordinate { return Coordinate(x: x + 1, y: y) }

    var upLeft: Coordinate { return Coordinate(x: x - 1, y: y - 1) }
    var downLeft: Coordinate { return Coordinate(x: x - 1, y: y + 1) }
    var upRight: Coordinate { return Coordinate(x: x + 1, y: y - 1) }
    var downRight: Coordinate { return Coordinate(x: x + 1, y: y + 1) }

    var neighbors: [Coordinate] {
        return [upLeft, up, upRight, left, right, downLeft, down, downRight]
    }

    static var origin: Coordinate { return Coordinate(x: 0, y: 0) }

    static var moves: [(Coordinate) -> Coordinate] {
        return [
            { $0.right },
            { $0.up },
            { $0.left },
            { $0.down },
        ]
    }

    func distance(to other: Coordinate) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

func findCoordinate(for target: Int) -> Coordinate {
    var coordinate = Coordinate.origin
    var index = 0
    var number = 1

    repeat {
        let movesInSameDirection = index / 2 + 1
        let move = Coordinate.moves[index % Coordinate.moves.count]
        for _ in 0 ..< movesInSameDirection {
            if number == target {
                return coordinate
            }
            number += 1
            coordinate = move(coordinate)
        }
        index += 1
    } while true
}

func partOneSolution(target: Int) {
    let coord = findCoordinate(for: target)
    let distance = coord.distance(to: .origin)
    print("Distance:", distance)
}

partOneSolution(target: 1)
partOneSolution(target: 12)
partOneSolution(target: 23)
partOneSolution(target: 1024)
partOneSolution(target: 347991)

func partTwoSolution(target: Int) -> Int {
    var coordinate = Coordinate.origin
    var index = 0
    var number = 1
    var found: [Coordinate: Int] = [coordinate: number]

    repeat {
        let movesInSameDirection = index / 2 + 1
        let move = Coordinate.moves[index % Coordinate.moves.count]
        for _ in 0 ..< movesInSameDirection {
            coordinate = move(coordinate)
            number = coordinate.neighbors.reduce(0) { sum, neighbor in
                return sum + (found[neighbor] ?? 0)
            }
            found[coordinate] = number
            if number > target {
                return number
            }
        }
        index += 1
    } while true
}

print("Solution:", partTwoSolution(target: 347991))
