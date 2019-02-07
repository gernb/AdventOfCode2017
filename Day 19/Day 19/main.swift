//
//  main.swift
//  Day 19
//
//  Created by Peter Bohac on 2/6/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Position {
    enum Heading: Equatable {
        case up, down, left, right
    }

    var x: Int
    var y: Int
    var heading: Heading

    var up: Position { return Position(x: x, y: y - 1, heading: .up) }
    var down: Position { return Position(x: x, y: y + 1, heading: .down) }
    var left: Position { return Position(x: x - 1, y: y, heading: .left) }
    var right: Position { return Position(x: x + 1, y: y, heading: .right) }

    mutating func moveNext() {
        switch heading {
        case .up: y -= 1
        case .down: y += 1
        case .left: x -= 1
        case .right: x += 1
        }
    }
}

struct Map {
    let map: [[Character]]

    init(with string: String) {
        map = string.split(separator: "\n").map { line in line.map { $0 } }
    }

    func collectLetters() -> (letters: String, steps: Int) {
        var letters = ""
        var position = findStart()
        var steps = 0

        repeat {
            let char = self[position]!
            switch char {
            case " ":
                return (letters, steps)
            case "|", "-":
                break
            case "+":
                changeDirection(at: &position)
            default:
                letters += String(char)
            }
            position.moveNext()
            steps += 1
        } while true
    }

    subscript(x: Int, y: Int) -> Character? {
        get {
            guard x >= 0 && y >= 0 && y < map.count && x < map[y].count else { return nil }
            return map[y][x]
        }
    }

    subscript(pos: Position) -> Character? {
        get {
            return self[pos.x, pos.y]
        }
    }

    private func findStart() -> Position {
        let index = map[0].firstIndex(of: "|")!
        return Position(x: index, y: 0, heading: .down)
    }

    private func changeDirection(at position: inout Position) {
        let neighbors = getNeighbors(of: position)
        if position.heading == .up || position.heading == .down {
            let left = neighbors.first { $0.direction == .left }
            if let left = left, left.char != " ", left.char != "|" {
                position.heading = .left
            } else {
                position.heading = .right
            }
        } else {
            let up = neighbors.first { $0.direction == .up }
            if let up = up, up.char != " ", up.char != "-" {
                position.heading = .up
            } else {
                position.heading = .down
            }
        }
    }

    private func getNeighbors(of position: Position) -> [(direction: Position.Heading, char: Character)] {
        return [position.up, position.down, position.left, position.right]
            .compactMap { pos in
                guard let char = self[pos] else { return nil }
                return (pos.heading, char)
            }
    }
}

let map = Map(with: InputData.challenge)
let result = map.collectLetters()

print("Result:", result)
