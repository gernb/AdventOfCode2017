//
//  main.swift
//  Day 04
//
//  Created by Peter Bohac on 2/4/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

let passphrases = InputData.challenge.split(separator: "\n")

extension Substring {
    var isValidPassphrase: Bool {
        let words = self.split(separator: " ")
        let unique = Set(words)
        return words.count == unique.count
    }

    var isExtraValidPassphrase: Bool {
        let words = self.split(separator: " ")
        let extraUnique = Set(words.map { word -> Set<Character> in
            return Set(word)
        })
        return words.count == extraUnique.count
    }
}

func partOneSolution(with input: [Substring]) {
    let validPassphrases = input.filter { $0.isValidPassphrase }
    print("Count of valid passphrases:", validPassphrases.count)
}

partOneSolution(with: passphrases)

func partTwoSolution(with input: [Substring]) {
    let validPassphrases = input.filter { $0.isExtraValidPassphrase }
    print("Count of extra valid passphrases:", validPassphrases.count)
}

partTwoSolution(with: passphrases)
