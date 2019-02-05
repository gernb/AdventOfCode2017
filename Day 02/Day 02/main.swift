//
//  main.swift
//  Day 02
//
//  Created by Peter Bohac on 2/4/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

let spreadsheet = InputData.challenge
    .split(separator: "\n")
    .map { line in
        return line.split(separator: " ").map { Int(String($0))! }
    }

func partOneSolution(with spreadsheet: [[Int]]) {
    let lineChecksums = spreadsheet.map { row -> Int in
        let min = row.min()!
        let max = row.max()!
        return max - min
    }

    let checksum = lineChecksums.reduce(0, +)

    print("Checksum:", checksum)
}

partOneSolution(with: spreadsheet)

func lineChecksum(_ line: [Int]) -> Int {
    for (i, value1) in line.enumerated() {
        for j in (i + 1) ..< line.count {
            let value2 = line[j]
            let largerValue = max(value1, value2)
            let smallerValue = min(value1, value2)
            if largerValue % smallerValue == 0 {
                return largerValue / smallerValue
            }
        }
    }
    preconditionFailure("Invalid row values")
}

func partTwoSolution(with spreadsheet: [[Int]]) {
    let checksum = spreadsheet.map(lineChecksum).reduce(0, +)
    print("Checksum:", checksum)
}

partTwoSolution(with: spreadsheet)
