//
//  main.swift
//  Day 10
//
//  Created by Bohac, Peter on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

import Foundation

struct State {
    var skipSize = 0
    var index = 0
}

func hash(_ list: inout [Int], state: inout State, length: Int) {
    var begin = state.index
    var end = (begin + length - 1) % list.count
    let swaps = length / 2
    for _ in 0 ..< swaps {
        list.swapAt(begin, end)
        begin = (begin + 1) % list.count
        end = end > 0 ? end - 1 : list.count - 1
    }
    state.index = (state.index + length + state.skipSize) % list.count
    state.skipSize += 1
}

let lengths = InputData.challenge
    .split(separator: ",")
    .map { Int(String($0))! }

var list = (0 ..< 256).map { $0 }
var state = State()

lengths.forEach { hash(&list, state: &state, length: $0) }

print("Solution:", list[0] * list[1])

// MARK: Part 2

extension Character {
    var ascii: Int {
        return Int(unicodeScalars.first!.value)
    }
}

func makeLengths(from input: String) -> [Int] {
    return input.map { $0.ascii } + [17, 31, 73, 47, 23]
}

func knotHash(_ input: String) -> String {
    let lengths = makeLengths(from: input)
    var sparseHash = (0 ..< 256).map { $0 }
    var state = State()

    (0 ..< 64).forEach { _ in
        lengths.forEach { hash(&sparseHash, state: &state, length: $0) }
    }

    let denseHash = (0 ..< 16).map { index in
        return sparseHash.dropFirst(index * 16).prefix(16).reduce(0, ^)
    }

    let result = denseHash.map { String(format: "%02x", $0) }.joined()
    assert(result.count == 32)
    return result
}

assert(knotHash("") == "a2582a3a0e66e6e86e3812dcb672a272")
assert(knotHash("AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd")
assert(knotHash("1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d")
assert(knotHash("1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e")

print("Knot Hash for challenge input is:", knotHash(InputData.challenge))
