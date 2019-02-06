//
//  main.swift
//  Day 05
//
//  Created by Bohac, Peter on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

let instructions = InputData.challenge
    .split(separator: "\n")
    .map { Int(String($0))! }

func partOneSolution(with input: [Int]) {
    var instructions = input
    var steps = 0
    var index = 0

    while index < instructions.count {
        let offset = instructions[index]
        instructions[index] += 1
        steps += 1
        index += offset
    }

    print("Steps:", steps)
}

partOneSolution(with: instructions)


func partTwoSolution(with input: [Int]) {
    var instructions = input
    var steps = 0
    var index = 0

    while index < instructions.count {
        let offset = instructions[index]
        if offset >= 3 {
            instructions[index] -= 1
        } else {
            instructions[index] += 1
        }
        steps += 1
        index += offset
    }

    print("Steps:", steps)
}

partTwoSolution(with: instructions)
