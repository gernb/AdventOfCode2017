//
//  main.swift
//  Day 08
//
//  Created by Bohac, Peter on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Instruction {
    enum Operand: String {
        case gt = ">"
        case lt = "<"
        case gte = ">="
        case lte = "<="
        case e = "=="
        case ne = "!="
    }

    let targetRegister: String
    let amount: Int
    let sourceRegister: String
    let immediate: Int
    let operand: Operand

    func execute(with registers: inout [String: Int]) {
        let sourceValue = registers[sourceRegister]!
        let targetValue = registers[targetRegister]!
        switch operand {
        case .gt:
            registers[targetRegister] = sourceValue > immediate ? targetValue + amount : targetValue
        case .lt:
            registers[targetRegister] = sourceValue < immediate ? targetValue + amount : targetValue
        case .gte:
            registers[targetRegister] = sourceValue >= immediate ? targetValue + amount : targetValue
        case .lte:
            registers[targetRegister] = sourceValue <= immediate ? targetValue + amount : targetValue
        case .e:
            registers[targetRegister] = sourceValue == immediate ? targetValue + amount : targetValue
        case .ne:
            registers[targetRegister] = sourceValue != immediate ? targetValue + amount : targetValue
        }
    }
}

extension Instruction {
    private init(with string: Substring) {
        let words = string.split(separator: " ").map(String.init)
        let targetRegister = words[0]
        let amount = words[1] == "inc" ? Int(words[2])! : -Int(words[2])!
        let sourceRegister = words[4]
        let operand = Operand(rawValue: words[5])!
        let immediate = Int(words[6])!
        self.init(targetRegister: targetRegister, amount: amount, sourceRegister: sourceRegister, immediate: immediate, operand: operand)
    }

    static func load(from input: String) -> [Instruction] {
        return input.split(separator: "\n").map(Instruction.init)
    }
}

func initialiseRegisters(for instructions: [Instruction]) -> [String: Int] {
    var registerNames = Set<String>()
    instructions.forEach { instruction in
        registerNames.insert(instruction.targetRegister)
        registerNames.insert(instruction.sourceRegister)
    }
    return Dictionary(uniqueKeysWithValues: registerNames.map { ($0, 0) } )
}

let instructions = Instruction.load(from: InputData.challenge)
print("Instruction count:", instructions.count)

var registers = initialiseRegisters(for: instructions)
print("Register count:", registers.keys.count)

instructions.forEach { $0.execute(with: &registers) }

let largestValue = registers.values.max()!
print("Largest value in any register is", largestValue)

// MARK: Part Two

registers = initialiseRegisters(for: instructions)
var highestValue = Int.min

instructions.forEach {
    $0.execute(with: &registers)
    highestValue = max(highestValue, registers.values.max()!)
}

print("Highest value seen is", highestValue)

