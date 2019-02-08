//
//  main.swift
//  Day 24
//
//  Created by Peter Bohac on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

final class Component {
    let ports: [Int]
    var unusedPortIndex: Int?

    var unusedPort: Int? {
        guard let index = unusedPortIndex else { return nil }
        return ports[index]
    }

    var strength: Int {
        return ports.reduce(0, +)
    }

    init(with string: Substring) {
        ports = string.split(separator: "/").map { Int(String($0))! }
    }

    func hasPort(_ value: Int) -> Bool {
        return ports[0] == value || ports[1] == value
    }

    func usePort(_ value: Int) {
        unusedPortIndex = ports[0] == value ? 1 : 0
    }

    static func load(from input: String) -> Set<Component> {
        let lines = input.split(separator: "\n")
        let set = Set(lines.map(Component.init))
        assert(set.count == lines.count)
        return set
    }
}

extension Component: Hashable {
    var hashValue: Int {
        return ports.hashValue
    }

    static func == (lhs: Component, rhs: Component) -> Bool {
        return lhs.ports == rhs.ports || lhs.ports == rhs.ports.reversed()
    }
}

extension Component: CustomStringConvertible {
    var description: String {
        return "\(ports[0])/\(ports[1])"
    }
}

struct Bridge {
    let components: [Component]

    private init(components: [Component] = []) {
        self.components = components
    }

    var strength: Int {
        return components.reduce(0) { $0 + $1.strength }
    }

    var nextPort: Int {
        return components.last?.unusedPort ?? 0
    }

    static func makeBridges(with components: Set<Component>, startingWith port: Int = 0) -> [Bridge] {
        var bridges: [Bridge] = []
        let nextComponents = components.filter { $0.hasPort(port) }
        nextComponents.forEach { component in
            component.usePort(port)
            let bridge = Bridge(components: [component])
            bridges.append(bridge)

            var newSet = components
            newSet.remove(component)
            makeBridges(with: newSet, startingWith: component.unusedPort!).forEach { newBridge in
                bridges.append(bridge + newBridge)
            }
        }
        return bridges
    }

    static func + (lhs: Bridge, rhs: Bridge) -> Bridge {
        if lhs.components.isEmpty {
            return rhs
        } else if rhs.components.isEmpty {
            return lhs
        } else {
            return Bridge(components: lhs.components + rhs.components)
        }
    }
}

extension Bridge: CustomStringConvertible {
    var description: String {
        return components.map { $0.description }.joined(separator: "--")
    }
}

let components = Component.load(from: InputData.challenge)
print("Component count:", components.count)

let bridges = Bridge.makeBridges(with: components)
//bridges.forEach { print($0) }
print("Bridges count:", bridges.count)
let strongest = bridges.max { $0.strength < $1.strength }!
print("Strongest: \(strongest.strength) \(strongest)")

let longest = bridges.max { lhs, rhs in
    if lhs.components.count == rhs.components.count {
        return lhs.strength < rhs.strength
    } else {
        return lhs.components.count < rhs.components.count
    }
}!
print("Longest: \(longest.strength) \(longest)")
