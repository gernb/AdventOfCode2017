//
//  main.swift
//  Day 21
//
//  Created by Bohac, Peter on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Grid: Hashable {
    var pixels: [[Int]]

    var size: Int {
        return pixels.count
    }

    var pattern: String {
        return pixels.map { row in row.map { $0 == 1 ? "#" : "." }.joined() }.joined(separator: "/")
    }

    var countOfOnPixels: Int {
        return pixels.flatMap { $0 }.reduce(0, +)
    }

    static let initial = Grid(with: ".#./..#/###")

    init(pixels: [[Int]]) {
        self.pixels = pixels
    }

    init(with pattern: String) {
        pixels = pattern.split(separator: "/")
            .map { row in
                row.map { $0 == "#" ? 1 : 0 }
            }
    }

    init(with grids: [[Grid]]) {
        pixels = []
        grids.forEach { row in
            for y in 0 ..< row[0].pixels.count {
                let pixelRow = row.map { grid in grid.pixels[y] }.flatMap { $0 }
                pixels.append(pixelRow)
            }
        }
    }

    func flipHorizontally() -> Grid {
        return Grid(pixels: pixels.reversed())
    }

    func flipVertically() -> Grid {
        let newPixels = pixels.map { row in Array(row.reversed()) }
        return Grid(pixels: newPixels)
    }

    func rotate() -> Grid {
        var result = pixels
        for y in 0 ..< pixels.count {
            var j = pixels.count - 1
            for x in 0 ..< pixels.count {
                result[y][x] = pixels[j][y]
                j -= 1
            }
        }
        return Grid(pixels: result)
    }

    func divide() -> [[Grid]] {
        var result: [[Grid]] = []
        if size % 2 == 0 {
            let count = size / 2
            for y in 0 ..< count {
                var row: [Grid] = []
                for x in 0 ..< count {
                    let newPixels = pixels.dropFirst(y * 2).prefix(2)
                        .map { row in Array(row.dropFirst(x * 2).prefix(2)) }
                    row.append(Grid(pixels: newPixels))
                }
                result.append(row)
            }
        } else {
            assert(size % 3 == 0)
            let count = size / 3
            for y in 0 ..< count {
                var row: [Grid] = []
                for x in 0 ..< count {
                    let newPixels = pixels.dropFirst(y * 3).prefix(3)
                        .map { row in Array(row.dropFirst(x * 3).prefix(3)) }
                    row.append(Grid(pixels: newPixels))
                }
                result.append(row)
            }
        }
        return result
    }

    func draw() {
        for (_, row) in pixels.enumerated() {
            for (_, pixel) in row.enumerated() {
                print(pixel == 1 ? "#" : ".", terminator: "")
            }
            print("")
        }
    }
}

assert(Grid.initial.countOfOnPixels == 5)
assert(Grid.initial.flipHorizontally().pattern == "###/..#/.#.")
assert(Grid.initial.flipVertically().pattern == ".#./#../###")
assert(Grid.initial.rotate().pattern == "#../#.#/##.")

func loadRules(from input: String) -> [Grid: Grid] {
    var rules: [Grid: Grid] = [:]
    input.split(separator: "\n")
        .map { $0.split(separator: " ") .map { String($0) } }
        .forEach { line in
            let startGrid = Grid(with: line[0])
            let resultGrid = Grid(with: line[2])

            [startGrid, startGrid.flipHorizontally(), startGrid.flipVertically()].forEach { grid in
                rules[grid] = resultGrid
                var rotated = grid.rotate()
                rules[rotated] = resultGrid
                rotated = grid.rotate()
                rules[rotated] = resultGrid
                rotated = grid.rotate()
                rules[rotated] = resultGrid
            }
        }
    return rules
}

//let rules = loadRules(from: InputData.example)
//print("Count:", rules.keys.count)
//
//let grid = Grid.initial
//let iter1 = Grid(with: grid.divide().map { row in row.map { rules[$0]! } })
//iter1.draw()
//
//let iter2 = Grid(with: iter1.divide().map { row in row.map { rules[$0]! } })
//iter2.draw()

let rules = loadRules(from: InputData.challenge)

var grid = Grid.initial
for _ in 0 ..< 18 {
    grid = Grid(with: grid.divide().map { row in row.map { rules[$0]! } })
}

print(grid.countOfOnPixels)
