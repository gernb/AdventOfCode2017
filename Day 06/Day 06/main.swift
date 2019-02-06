//
//  main.swift
//  Day 06
//
//  Created by Bohac, Peter on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

let initialAllocation = InputData.challenge
    .split(separator: " ")
    .map { Int(String($0))! }

func redistribute(_ banks: [Int]) -> [Int] {
    var result = banks
    let blocks = banks.max()!
    var index = banks.firstIndex(of: blocks)!
    result[index] = 0
    for _ in 1 ... blocks {
        index += 1
        result[index % result.count] += 1
    }
    return result
}

func partOneSolution(with input: [Int]) {
    var redistributionCount = 0
    var states: [[Int]: [Int]] = [:]
    var memoryBanks = input

    repeat {
        if states[memoryBanks] != nil {
            break
        }
        let nextState = redistribute(memoryBanks)
        redistributionCount += 1
        states[memoryBanks] = nextState
        memoryBanks = nextState
    } while true

    print("Count:", redistributionCount)
}

partOneSolution(with: initialAllocation)

func partTwoSolution(with input: [Int]) {
    var redistributionCount = 0
    var states: [[Int]: [Int]] = [:]
    var memoryBanks = input
    var target: (state: [Int], firstAt: Int)?

    repeat {
        if let target = target, target.state == memoryBanks {
            break
        }
        if states[memoryBanks] != nil && target == nil {
            target = (memoryBanks, redistributionCount)
        }
        let nextState = redistribute(memoryBanks)
        redistributionCount += 1
        states[memoryBanks] = nextState
        memoryBanks = nextState
    } while true

    print("Cycle size:", redistributionCount - target!.firstAt)
}

partTwoSolution(with: initialAllocation)
