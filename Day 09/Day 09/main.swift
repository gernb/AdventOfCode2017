//
//  main.swift
//  Day 09
//
//  Created by Bohac, Peter on 2/5/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

func parse(stream: String) -> Int {
    var groupLevel = 0
    var isParsingGarbage = false
    var ignoreNextChar = false
    var score = 0

    stream.forEach { char in
        if isParsingGarbage {
            guard !ignoreNextChar else {
                ignoreNextChar = false
                return
            }
            switch char {
            case "!":
                ignoreNextChar = true
            case ">":
                isParsingGarbage = false
            default:
                break
            }
        } else {
            switch char {
            case "{":
                groupLevel += 1
            case "}":
                score += groupLevel
                groupLevel -= 1
            case "<":
                isParsingGarbage = true
            default:
                break
            }
        }
    }

    return score
}

print("Score:", parse(stream: InputData.challenge))

// MARK: Part 2

func parse2(stream: String) -> Int {
    var isParsingGarbage = false
    var ignoreNextChar = false
    var garbageCharacters = 0

    stream.forEach { char in
        if isParsingGarbage {
            guard !ignoreNextChar else {
                ignoreNextChar = false
                return
            }
            switch char {
            case "!":
                ignoreNextChar = true
            case ">":
                isParsingGarbage = false
            default:
                garbageCharacters += 1
            }
        } else {
            switch char {
            case "<":
                isParsingGarbage = true
            default:
                break
            }
        }
    }

    return garbageCharacters
}

print("Garbage chars:", parse2(stream: InputData.challenge))
