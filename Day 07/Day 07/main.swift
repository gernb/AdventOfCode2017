//
//  main.swift
//  Day 07
//
//  Created by Bohac, Peter on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Program: Hashable, CustomStringConvertible {
    let name: String
    let weight: Int
    let blockingNames: Set<String>

    var description: String {
        let details = "\(name) (\(weight))"
        let blockList = blockingNames.joined(separator: ", ")
        return blockList.isEmpty ? details : "\(details) -> \(blockList)"
    }
}

extension Program {
    // fwft (72) -> ktlj, cntj, xhth
    private init(with string: Substring) {
        var words = string.split(separator: " ")
        let name = String(words.removeFirst())
        let weightString = words.removeFirst()
        let weight = Int(String(weightString.dropFirst().dropLast()))!
        var blockingNames: [String] = []
        if words.first == "->" {
            words.removeFirst()
            blockingNames = words.map { word -> String in
                return word.last == "," ? String(word.dropLast()) : String(word)
            }
        }

        self.init(name: name, weight: weight, blockingNames: Set(blockingNames))
    }

    static func load(from input: String) -> [Program] {
        return input.split(separator: "\n").map(Program.init)
    }
}

final class Node: Hashable {
    let program: Program
    var parent: Node?
    var children: Set<Node>

    var hashValue: Int {
        return program.hashValue
    }

    init(program: Program) {
        self.program = program
        self.parent = nil
        self.children = Set()
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.program == rhs.program
    }

    static func parse(_ programs: [Program]) -> Node {
        var nodes: [String: Node] = Dictionary(uniqueKeysWithValues: programs.map { ($0.name, Node(program: $0)) })
        programs.forEach { program in
            let programNode = nodes[program.name]!
            program.blockingNames.forEach { name in
                let blockedNode = nodes[name]!
                blockedNode.parent = programNode
                programNode.children.insert(blockedNode)
            }
        }
        var root = nodes[programs[0].name]!
        while root.parent != nil {
            root = root.parent!
        }
        return root
    }
}

let programs = Program.load(from: InputData.challenge)
print("Count:", programs.count)

let root = Node.parse(programs)
print("Bottom program is:", root.program.name)

// MARK: Part Two

extension Node {
    var weight: Int {
        return program.weight + children.reduce(0) { $0 + $1.weight }
    }
}

var node = root
var weightToLose = 0

repeat {
    var childrenWeight = node.children.map { (node: $0, weight: $0.weight) }.sorted { $0.weight > $1.weight }
    guard childrenWeight.count > 1 else {
        preconditionFailure("Shouldn't happen for this input data.")
    }
    if childrenWeight[0].weight != childrenWeight[1].weight {
        // recurse into the "overweight" node
        weightToLose = childrenWeight[0].weight - childrenWeight[1].weight
        node = childrenWeight[0].node
    } else {
        // found the "overweight" node
        break
    }
} while true

print("Program '\(node.program.name)' has a weight of \(node.program.weight) and needs to lose \(weightToLose) to be \(node.program.weight - weightToLose)")
