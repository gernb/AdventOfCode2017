//
//  main.swift
//  Day 20
//
//  Created by Bohac, Peter on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

typealias Triplet = (x: Int, y: Int, z: Int)

struct Particle {
    let id: Int
    var position: Triplet
    var velocity: Triplet
    let acceleration: Triplet

    var distanceFromOrigin: Int {
        return abs(position.x) + abs(position.y) + abs(position.z)
    }

    var accelMagnitudeSquared: Int {
        let x = acceleration.x * acceleration.x
        let y = acceleration.y * acceleration.y
        let z = acceleration.z * acceleration.z
        return x + y + z
    }
}

extension Particle {
    private init(with string: Substring, id: Int) {
        let parts = string.split(separator: " ")
        let posParts = parts[0].dropFirst(3).dropLast(2).split(separator: ",")
            .map { Int(String($0))! }
        let velParts = parts[1].dropFirst(3).dropLast(2).split(separator: ",")
            .map { Int(String($0))! }
        let accelParts = parts[2].dropFirst(3).dropLast().split(separator: ",")
            .map { Int(String($0))! }
        self.init(id: id,
                  position: (posParts[0], posParts[1], posParts[2]),
                  velocity: (velParts[0], velParts[1], velParts[2]),
                  acceleration: (accelParts[0], accelParts[1], accelParts[2]))
    }

    static func load(from input: String) -> [Particle] {
        return input.split(separator: "\n")
            .enumerated()
            .map { id, line in return Particle(with: line, id: id) }
    }
}

let particles = Particle.load(from: InputData.challenge)
print("Count:", particles.count)

// MARK: Part 1

let lowestAcceleration = particles.min { $0.accelMagnitudeSquared < $1.accelMagnitudeSquared }!.accelMagnitudeSquared
let slowestAcceleratingParticles = particles.filter { $0.accelMagnitudeSquared <= lowestAcceleration }
if slowestAcceleratingParticles.count == 1 {
    let found = slowestAcceleratingParticles.first!
    print("Particle #\(found.id) will stay closest to the origin.")
} else {
    preconditionFailure("More than one particle has the lowest acceleration.")
}

// MARK: Part 2

extension Particle {
    mutating func tick() {
        velocity = (velocity.x + acceleration.x, velocity.y + acceleration.y, velocity.z + acceleration.z)
        position = (position.x + velocity.x, position.y + velocity.y, position.z + velocity.z)
    }
}

extension Particle: Hashable {
    var hashValue: Int {
        return id.hashValue
    }

    static func == (lhs: Particle, rhs: Particle) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Array where Element == Particle {
    func removingCollisions() -> [Particle] {
        var result = Set<Particle>(self)
        for (i, particle1) in self.enumerated() {
            for (_, particle2) in self.dropFirst(i + 1).enumerated() {
                if particle1.position == particle2.position {
                    result.remove(particle1)
                    result.remove(particle2)
                }
            }
        }
        return Array(result)
    }

    mutating func removeCollisions() {
        self = self.removingCollisions()
    }

    mutating func tick() {
        for i in 0 ..< count {
            self[i].tick()
        }
    }
}

// Brute-force
var result = particles
for _ in 1 ... 1_000 {
    result.tick()
    result.removeCollisions()
}

print("Result:", result.count)
