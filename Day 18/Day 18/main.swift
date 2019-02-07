//
//  main.swift
//  Day 18
//
//  Created by Bohac, Peter on 2/6/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Instruction {
    enum Operation: String, Equatable {
        case snd, set, add, mul, mod, rcv, jgz
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

        if op == .snd || op == .rcv {
            self.sourceRegister = ""
            self.sourceImmediate = 0
            return
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
    var soundFrequency: Int?

    init(input string: String) {
        self.instructions = string.split(separator: "\n").map(Instruction.init)
        let registerNames = Set(instructions.map { [$0.targetRegister.isEmpty ? nil : $0.targetRegister, $0.sourceRegister.isEmpty ? nil : $0.sourceRegister] }.flatMap { $0 }.compactMap { $0 })
        self.registers = Dictionary(uniqueKeysWithValues: registerNames.map { ($0, 0) })
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
        case .snd:
            soundFrequency = targetValue
            ip += 1
        case .set:
            registers[instruction.targetRegister] = sourceValue
            ip += 1
        case .add:
            registers[instruction.targetRegister] = targetValue + sourceValue
            ip += 1
        case .mul:
            registers[instruction.targetRegister] = targetValue * sourceValue
            ip += 1
        case .mod:
            registers[instruction.targetRegister] = targetValue % sourceValue
            ip += 1
        case .rcv:
            if targetValue != 0 {
                return true
            }
            ip += 1
        case .jgz:
            if targetValue > 0 {
                ip += sourceValue
            } else {
                ip += 1
            }
        }

        return false
    }
}

let program = Program(input: InputData.challenge)
print("Instruction count:", program.instructions.count)
program.run()

print("Recovered frequency:", program.soundFrequency!)

// MARK: Part 2

final class Program2 {
    let id: Int
    let instructions: [Instruction]
    var registers: [String: Int]
    var ip = 0
    var isTerminated = false
    var isWaiting = false
    var sendCount = 0
    var queue: [Int] = []
    weak var attachedProgram: Program2?

    init(input string: String, id: Int) {
        self.id = id
        self.instructions = string.split(separator: "\n").map(Instruction.init)
        let registerNames = Set(instructions.map { [$0.targetRegister.isEmpty ? nil : $0.targetRegister, $0.sourceRegister.isEmpty ? nil : $0.sourceRegister] }.flatMap { $0 }.compactMap { $0 })
        self.registers = Dictionary(uniqueKeysWithValues: registerNames.map { ($0, 0) })
        self.registers["p"] = id
    }

    func run() {
        guard !isTerminated else { return }
        if isWaiting && queue.isEmpty {
            // deadlock
            isTerminated = true
            return
        }
        repeat {
//            print("Program \(id) running...")
        } while executeNextInstruction() == false
    }

    // returns whether the program should halt
    private func executeNextInstruction() -> Bool {
        guard ip >= 0 && ip < instructions.count else {
            isTerminated = true
            return true
        }
        let instruction = instructions[ip]
        let targetValue = registers[instruction.targetRegister] ?? instruction.targetImmediate
        let sourceValue = registers[instruction.sourceRegister] ?? instruction.sourceImmediate

        switch instruction.op {
        case .snd:
            attachedProgram?.queue.append(targetValue)
            sendCount += 1
            ip += 1
        case .set:
            registers[instruction.targetRegister] = sourceValue
            ip += 1
        case .add:
            registers[instruction.targetRegister] = targetValue + sourceValue
            ip += 1
        case .mul:
            registers[instruction.targetRegister] = targetValue * sourceValue
            ip += 1
        case .mod:
            registers[instruction.targetRegister] = targetValue % sourceValue
            ip += 1
        case .rcv:
            if let value = queue.first {
                queue.removeFirst()
                isWaiting = false
                registers[instruction.targetRegister] = value
                ip += 1
            } else {
                isWaiting = true
                return true
            }
        case .jgz:
            if targetValue > 0 {
                ip += sourceValue
            } else {
                ip += 1
            }
        }

        return false
    }
}

let prog0 = Program2(input: InputData.challenge, id: 0)
let prog1 = Program2(input: InputData.challenge, id: 1)

prog0.attachedProgram = prog1
prog1.attachedProgram = prog0

repeat {
    print("Program 0 (\(prog0.sendCount)) running...")
    prog0.run()
    print("Program 1 (\(prog1.sendCount)) running...")
    prog1.run()
} while prog0.isTerminated == false && prog1.isTerminated == false

print("Program 1 sent \(prog1.sendCount) values.")
