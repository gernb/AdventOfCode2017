//
//  main.swift
//  Day 25
//
//  Created by Peter Bohac on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Rule {
    let write: Int
    let advance: Int
    let nextState: String
}

struct State: Hashable {
    let name: String
    let value: Int
}

// MARK: Example input

func example() {
    var rules: [State: Rule] = [:]

    rules[State(name: "A", value: 0)] = Rule(write: 1, advance: 1, nextState: "B")
    rules[State(name: "A", value: 1)] = Rule(write: 0, advance: -1, nextState: "B")

    rules[State(name: "B", value: 0)] = Rule(write: 1, advance: -1, nextState: "A")
    rules[State(name: "B", value: 1)] = Rule(write: 1, advance: 1, nextState: "A")

    let steps = 6
    var tape = Set<Int>()
    var cursor = 0
    var currentState = "A"

    for _ in 0 ..< steps {
        let value = tape.contains(cursor) ? 1 : 0
        let rule = rules[State(name: currentState, value: value)]!
        if rule.write == 1 {
            tape.insert(cursor)
        } else {
            tape.remove(cursor)
        }
        cursor += rule.advance
        currentState = rule.nextState
    }

    let checksum = tape.count
    print("Checksum:", checksum)
}

example()

// MARK: Challenge input

func challenge() {
    var rules: [State: Rule] = [:]

    rules[State(name: "A", value: 0)] = Rule(write: 1, advance: 1, nextState: "B")
    rules[State(name: "A", value: 1)] = Rule(write: 0, advance: 1, nextState: "C")

    rules[State(name: "B", value: 0)] = Rule(write: 0, advance: -1, nextState: "A")
    rules[State(name: "B", value: 1)] = Rule(write: 0, advance: 1, nextState: "D")

    rules[State(name: "C", value: 0)] = Rule(write: 1, advance: 1, nextState: "D")
    rules[State(name: "C", value: 1)] = Rule(write: 1, advance: 1, nextState: "A")

    rules[State(name: "D", value: 0)] = Rule(write: 1, advance: -1, nextState: "E")
    rules[State(name: "D", value: 1)] = Rule(write: 0, advance: -1, nextState: "D")

    rules[State(name: "E", value: 0)] = Rule(write: 1, advance: 1, nextState: "F")
    rules[State(name: "E", value: 1)] = Rule(write: 1, advance: -1, nextState: "B")

    rules[State(name: "F", value: 0)] = Rule(write: 1, advance: 1, nextState: "A")
    rules[State(name: "F", value: 1)] = Rule(write: 1, advance: 1, nextState: "E")

    let steps = 12_368_930
    var tape = Set<Int>()
    var cursor = 0
    var currentState = "A"

    for _ in 0 ..< steps {
        let value = tape.contains(cursor) ? 1 : 0
        let rule = rules[State(name: currentState, value: value)]!
        if rule.write == 1 {
            tape.insert(cursor)
        } else {
            tape.remove(cursor)
        }
        cursor += rule.advance
        currentState = rule.nextState
    }

    let checksum = tape.count
    print("Checksum:", checksum)
}

challenge()
