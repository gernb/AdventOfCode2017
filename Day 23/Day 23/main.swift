//
//  main.swift
//  Day 23
//
//  Created by Bohac, Peter on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Instruction {
    enum Operation: String, Equatable {
        case set, sub, mul, jnz
    }

    let op: Operation
    let targetRegister: String
    let sourceRegister: String
    let targetImmediate: Int
    let sourceImmediate: Int

    init(with string: Substring) {
        let words = string.split(separator: " ").map(String.init)
        let op = Operation(rawValue: words[0])!
        self.op = op

        if let immediate = Int(words[1]) {
            self.targetRegister = ""
            self.targetImmediate = immediate
        } else {
            self.targetRegister = words[1]
            self.targetImmediate = 0
        }

        if let immediate = Int(words[2]) {
            self.sourceRegister = ""
            self.sourceImmediate = immediate
        } else {
            self.sourceRegister = words[2]
            self.sourceImmediate = 0
        }
    }
}

final class Program {
    let instructions: [Instruction]
    var registers: [String: Int]
    var ip: Int
    var mulExecutionCount = 0

    init(input string: String, debugMode: Int = 0) {
        self.instructions = string.split(separator: "\n").map(Instruction.init)
        let registerNames = Set(instructions.map { [$0.targetRegister.isEmpty ? nil : $0.targetRegister, $0.sourceRegister.isEmpty ? nil : $0.sourceRegister] }.flatMap { $0 }.compactMap { $0 })
        self.registers = Dictionary(uniqueKeysWithValues: registerNames.map { ($0, 0) })
        self.registers["a"] = debugMode
        self.ip = 0
    }

    func run() {
        var shouldHalt = false
        repeat {
            shouldHalt = executeNextInstruction()
        } while shouldHalt == false
    }

    // returns whether the program should halt
    private func executeNextInstruction() -> Bool {
        guard ip >= 0 && ip < instructions.count else { return true }
        let instruction = instructions[ip]
        let targetValue = registers[instruction.targetRegister] ?? instruction.targetImmediate
        let sourceValue = registers[instruction.sourceRegister] ?? instruction.sourceImmediate

        switch instruction.op {
        case .set:
            registers[instruction.targetRegister] = sourceValue
            ip += 1
        case .sub:
            registers[instruction.targetRegister] = targetValue - sourceValue
            ip += 1
        case .mul:
            registers[instruction.targetRegister] = targetValue * sourceValue
            ip += 1
            mulExecutionCount += 1
        case .jnz:
            if targetValue != 0 {
                ip += sourceValue
            } else {
                ip += 1
            }
        }

        return false
    }
}

let program = Program(input: InputData.challenge, debugMode: 0)
print("Instruction count:", program.instructions.count)

program.run()
print(program.mulExecutionCount)

var A = 1
var B = 81
var C = 81
var H = 0

func swiftyProgram() {
    if A == 1 {
        B = B * 100 + 100_000
        C = B + 17_000
    }

    repeat {
        var F = 1

//        for D in 2 ... B {
//            for E in 2 ... B {
//                if D * E == B {
//                    F = 0 // B is not prime
//                }
//            }
//        }
        for i in 2 ..< B {
            if B % i == 0 {
                F = 0
                break
            }
        }

        if F == 0 {
            H = H + 1
        }
        if B == C {
            break
        }
        B = B + 17
    } while true
}

swiftyProgram()

print("H:", H)
