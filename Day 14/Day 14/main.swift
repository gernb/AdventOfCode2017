//
//  main.swift
//  Day 14
//
//  Created by Bohac, Peter on 2/6/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

func knotHash(_ input: String) -> [Int] {
    let data = input.map { Int($0.unicodeScalars.first!.value) } + [17, 31, 73, 47, 23]
    var sparseHash = Array(0 ..< 256)
    var skipSize = 0
    var index = 0

    (0 ..< 64).forEach { _ in
        data.forEach { length in
            var begin = index
            var end = (begin + length - 1) % sparseHash.count
            let swaps = length / 2
            for _ in 0 ..< swaps {
                sparseHash.swapAt(begin, end)
                begin = (begin + 1) % sparseHash.count
                end = end > 0 ? end - 1 : sparseHash.count - 1
            }
            index = (index + length + skipSize) % sparseHash.count
            skipSize += 1
        }
    }

    let denseHash = (0 ..< 16).map { index in
        return sparseHash.dropFirst(index * 16).prefix(16).reduce(0, ^)
    }

    return denseHash
}

func usedSquares(for input: String) -> Int {
    let bits = (0 ..< 128).map { knotHash("\(input)-\($0)") }
    return bits.map { row in row.map { $0.nonzeroBitCount }.reduce(0, +) }.reduce(0, +)
}

let used = usedSquares(for: "amgozmfv")
print("Used squares:", used)

// MARK: Part 2

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    var up: Coordinate { return Coordinate(x: x, y: y - 1) }
    var down: Coordinate { return Coordinate(x: x, y: y + 1) }
    var left: Coordinate { return Coordinate(x: x - 1, y: y) }
    var right: Coordinate { return Coordinate(x: x + 1, y: y) }
}

struct Disk {
    var grid: [[Bool]]

    init(input: String) {
        let bits = (0 ..< 128).map { knotHash("\(input)-\($0)") }
        var grid = Array(repeating: Array(repeating: false, count: 128), count: 128)

        for (y, row) in bits.enumerated() {
            var x = 0
            row.forEach { chunk in // each chunk represents 8 bits
                (0 ..< 8).reversed().forEach { pos in
                    let bit = 1 << pos
                    grid[y][x] = chunk & bit == bit
                    x += 1
                }
            }
        }

        self.grid = grid
    }

    mutating func regionsCount() -> Int {
        var count = 0

        for y in (0 ..< grid.count) {
            for x in (0 ..< grid[y].count) {
                let start = Coordinate(x: x, y: y)
                if self[start]! {
                    count += 1
                    visitRegion(from: start)
                }
            }
        }

        return count
    }

    private mutating func visitRegion(from start: Coordinate) {
        var queue = [start]
        while queue.isEmpty == false {
            let coordinate = queue.removeFirst()
            self[coordinate] = false // mark this location as "visited"
            neighborsMarkedAsUsed(for: coordinate).forEach {
                if queue.contains($0) == false {
                    queue.append($0)
                }
            }
        }
    }

    private func neighborsMarkedAsUsed(for coord: Coordinate) -> [Coordinate] {
        return [coord.up, coord.down, coord.left, coord.right]
            .compactMap { self[$0] != nil ? (coord: $0, used: self[$0]!) : nil }
            .filter { $0.used }
            .map { $0.coord }
    }

    subscript(x: Int, y: Int) -> Bool? {
        get {
            guard x >= 0 && y >= 0 && x < grid.count && y < grid.count else { return nil }
            return grid[y][x]
        }
        set {
            guard x >= 0 && y >= 0 && x < grid.count && y < grid.count else { return }
            guard let newValue = newValue else { return }
            grid[y][x] = newValue
        }
    }

    subscript(coord: Coordinate) -> Bool? {
        get {
            return self[coord.x, coord.y]
        }
        set {
            self[coord.x, coord.y] = newValue
        }
    }
}

var disk = Disk(input: "amgozmfv")
print("Unique regions:", disk.regionsCount())
