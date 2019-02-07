//
//  main.swift
//  Day 16
//
//  Created by Bohac, Peter on 2/6/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

enum DanceMove {
    case spin(Int)
    case exchange(Int, Int)
    case partner(String, String)

    init(with string: Substring) {
        switch string.first! {
        case "s":
            let count = Int(String(string.dropFirst()))!
            self = .spin(count)
        case "x":
            let values = string.dropFirst()
                .split(separator: "/")
                .map { Int(String($0))! }
            self = .exchange(values[0], values[1])
        case "p":
            let names = string.dropFirst()
                .split(separator: "/")
                .map(String.init)
            self = .partner(names[0], names[1])
        default:
            preconditionFailure("Unhandled dance move!")
        }
    }

    static func load(from string: String) -> [DanceMove] {
        return string.split(separator: ",").map(DanceMove.init)
    }
}

extension DanceMove {
    func perform(with dancers: inout [String]) {
        switch self {
        case .spin(let count):
            let head = dancers.prefix(dancers.count - count)
            let tail = dancers[(dancers.count - count)...]
            dancers = Array(tail + head)

        case .exchange(let a, let b):
            dancers.swapAt(a, b)

        case .partner(let a, let b):
            let posA = dancers.firstIndex(of: a)!
            let posB = dancers.firstIndex(of: b)!
            dancers.swapAt(posA, posB)
        }
    }

    func performFaster(with dancers: inout [String], head: inout Int) {
        switch self {
        case .spin(let count):
            head = (head + dancers.count - count) % dancers.count

        case .exchange(var a, var b):
            a = (a + head) % dancers.count
            b = (b + head) % dancers.count
            dancers.swapAt(a, b)

        case .partner(let a, let b):
            let posA = dancers.firstIndex(of: a)!
            let posB = dancers.firstIndex(of: b)!
            dancers.swapAt(posA, posB)
        }
    }
}

let moves = DanceMove.load(from: InputData.challengeMoves)
var programs = InputData.challengePrograms
//var head = 0

moves.forEach { $0.perform(with: &programs) }

//var tail = programs[0 ..< head]
//var front = programs[head...]
//var result = Array(front + tail)
print("Result:", programs.joined())

// MARK: Part 2

var dancers = InputData.challengePrograms
var count = 0
var states: [[String]: Int] = [dancers: count]
var cycleLength = 0

repeat {
    moves.forEach { $0.perform(with: &dancers) }
    count += 1

    if let previousCount = states[dancers] {
        print("Current state was previously seen at \(previousCount). Current count is \(count)")
        assert(previousCount == 0, "Solution assumes cycle starts at 0")
        cycleLength = count - previousCount
        break
    } else {
        states[dancers] = count
    }
} while true

dancers = InputData.challengePrograms
count = 1_000_000_000 % cycleLength
for _ in (0 ..< count) {
    moves.forEach { $0.perform(with: &dancers) }
}

print("Result:", dancers.joined())
