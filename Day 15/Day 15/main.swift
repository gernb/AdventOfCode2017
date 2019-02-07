//
//  main.swift
//  Day 15
//
//  Created by Bohac, Peter on 2/6/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

final class Generator {
    let factor: Int
    var previousValue: Int

    init(startingValue: Int, factor: Int) {
        self.factor = factor
        self.previousValue = startingValue
    }

    func next() -> Int {
        let value = (previousValue * factor) % 2147483647
        previousValue = value
        return value
    }
}

struct Judge {
    let genA: Generator
    let genB: Generator

    func countMatches(for iterations: Int) -> Int {
        var matchCount = 0
        for _ in (0 ..< iterations) {
            let valueA = genA.next()
            let valueB = genB.next()
            matchCount += (valueA & 0xFFFF) == (valueB & 0xFFFF) ? 1 : 0
        }
        return matchCount
    }
}

// Generator A starts with 703
// Generator B starts with 516

//let genA = Generator(startingValue: 703, factor: 16807)
//let genB = Generator(startingValue: 516, factor: 48271)
//let judge = Judge(genA: genA, genB: genB)
//print(judge.countMatches(for: 40_000_000))

// MARK: Part 2

extension Generator {
    func next2() -> Int {
        repeat {
            let value = next()
            if factor == 16807 && (value & 0b11) == 0 { // Generator A && multiple of 4
                return value
            } else if factor == 48271 && (value & 0b111) == 0 { // Generator B && multiple of 8
                return value
            }
        } while true
    }
}

extension Judge {
    func countMatches2(for iterations: Int) -> Int {
        var matchCount = 0
        for _ in (0 ..< iterations) {
            let valueA = genA.next2()
            let valueB = genB.next2()
            matchCount += (valueA & 0xFFFF) == (valueB & 0xFFFF) ? 1 : 0
        }
        return matchCount
    }
}

let genA = Generator(startingValue: 703, factor: 16807)
let genB = Generator(startingValue: 516, factor: 48271)
let judge = Judge(genA: genA, genB: genB)
print(judge.countMatches2(for: 5_000_000))
