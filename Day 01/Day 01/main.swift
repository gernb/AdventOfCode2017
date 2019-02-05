//
//  main.swift
//  Day 01
//
//  Created by Peter Bohac on 2/4/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

func partOneSolution(with input: String) {
    let numbers = input.map { Int(String($0))! }
    let count = numbers.count
    var sum = 0
    for (i, number) in numbers.enumerated() {
        let next = numbers[(i + 1) % count]
        sum = number == next ? sum + number : sum
    }
    print("Sum:", sum)
}

partOneSolution(with: "1122")
partOneSolution(with: "1111")
partOneSolution(with: "1234")
partOneSolution(with: "91212129")
partOneSolution(with: InputData.challenge)

print("")

func partTwoSolution(with input: String) {
    let numbers = input.map { Int(String($0))! }
    let count = numbers.count
    var sum = 0
    for (i, number) in numbers.enumerated() {
        let next = numbers[(i + (count / 2)) % count]
        sum = number == next ? sum + number : sum
    }
    print("Sum:", sum)
}

partTwoSolution(with: "1212")
partTwoSolution(with: "1221")
partTwoSolution(with: "123425")
partTwoSolution(with: "123123")
partTwoSolution(with: "12131415")
partTwoSolution(with: InputData.challenge)
