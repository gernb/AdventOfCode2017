//
//  main.swift
//  Day 12
//
//  Created by Peter Bohac on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

final class Program {
    let id: Int
    var connections: Set<Program>

    init(id: Int) {
        self.id = id
        self.connections = Set()
    }
}

extension Program: Hashable {
    var hashValue: Int {
        return id.hashValue
    }

    static func == (lhs: Program, rhs: Program) -> Bool {
        return lhs.id == rhs.id
    }
}

// 2 <-> 0, 3, 4
extension Program {
    static func load(from input: String) -> [Program] {
        var programs: [Int: Program] = [:]

        input.split(separator: "\n").forEach { line in
            var words = line.split(separator: " ").map(String.init)
            let id = Int(words.removeFirst())!
            words.removeFirst() // <->
            let program = programs[id] ?? Program(id: id)
            words.map { Int($0.hasSuffix(",") ? String($0.dropLast()) : $0)! }.forEach { otherId in
                let otherProgram = programs[otherId] ?? Program(id: otherId)
                otherProgram.connections.insert(program)
                program.connections.insert(otherProgram)
                programs[otherId] = otherProgram
            }
            programs[id] = program
        }

        return programs.values.sorted { $0.id < $1.id }
    }
}

func reachable(from program: Program) -> [Program] {
    var seen = Set<Program>()
    var queue: [Program] = [program]

    while queue.isEmpty == false {
        let current = queue.removeFirst()
        seen.insert(current)
        current.connections
            .filter { seen.contains($0) == false && queue.contains($0) == false }
            .forEach { queue.append($0) }
    }

    return Array(seen)
}

let programs = Program.load(from: InputData.challenge)
print("Total:", programs.count)

assert(programs[0].id == 0)

let reached = reachable(from: programs[0]).count
print("\(reached) programs can be reached from Program 0")

// MARK: Part 2

func countGroups(in programs: [Program]) -> Int {
    var groups: [[Program]] = []
    var programSet = Set(programs)

    while let program = programSet.first {
        let group = reachable(from: program)
        groups.append(group)
        programSet.subtract(group)
    }

    return groups.count
}

print("Groups:", countGroups(in: programs))
