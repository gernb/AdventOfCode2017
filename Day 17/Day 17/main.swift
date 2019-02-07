//
//  main.swift
//  Day 17
//
//  Created by Bohac, Peter on 2/6/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

final class Node<T> {
    let value: T
    var previous: Node<T>!
    var next: Node<T>!

    static func create(with value: T) -> Node<T> {
        let node = Node(value: value)
        node.next = node
        node.previous = node
        return node
    }

    private init(value: T, previous: Node? = nil, next: Node? = nil) {
        self.value = value
        self.previous = previous
        self.next = next
    }

    func insert(_ value: T) -> Node<T> {
        let node = Node(value: value, previous: self, next: self.next)
        self.next.previous = node
        self.next = node
        return node
    }
}

extension Int {
    func times(block: () -> Void) {
        (0 ..< self).forEach { _ in block() }
    }
}

let stepCount = 329
var buffer = Node.create(with: 0)

for value in 1 ... 2017 {
    stepCount.times { buffer = buffer.next }
    buffer = buffer.insert(value)
}

print(buffer.next.value)

// MARK: Part 2

/* Brute force... too slow :(
buffer = Node.create(with: 0)
let zero = buffer

for value in 1 ... 50_000_000 {
    stepCount.times { buffer = buffer.next }
    if buffer === zero {
        print("Inserting \(value) after 0")
    }
    buffer = buffer.insert(value)
}

print(zero.next.value)
*/

var valueAfterZero = -1
var position = 0
for value in 1 ... 50_000_000 {
    position = (position + stepCount) % value
    if position == 0 {
        valueAfterZero = value
        print("Inserting \(value) after 0")
    }
    position += 1
}

print(valueAfterZero)
