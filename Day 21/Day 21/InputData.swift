//
//  InputData.swift
//  Day 21
//
//  Created by Bohac, Peter on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct InputData {
    static let example = """
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
"""

    static let challenge = """
../.. => #../.../..#
#./.. => ###/##./.#.
##/.. => ..#/..#/##.
.#/#. => ###/.../#..
##/#. => #../#.#/.#.
##/## => ##./##./...
.../.../... => .##./.##./#.##/#.##
#../.../... => #.#./####/..#./#..#
.#./.../... => #.../#..#/##.#/#.##
##./.../... => .##./##../..##/....
#.#/.../... => #.../..##/#.##/#...
###/.../... => ##.#/.#../####/....
.#./#../... => .###/#..#/####/...#
##./#../... => ##.#/#.../..#./####
..#/#../... => ####/###./..../#.#.
#.#/#../... => ..##/.#../.#.#/...#
.##/#../... => #.##/###./####/####
###/#../... => #.#./##.#/..#./####
.../.#./... => .##./#.../..../#...
#../.#./... => ###./.##./...#/....
.#./.#./... => .#../..#./###./....
##./.#./... => .##./..../.###/...#
#.#/.#./... => ###./.##./##.#/#.##
###/.#./... => ##../..##/####/...#
.#./##./... => ..#./#..#/##../.#..
##./##./... => .#../...#/###./##..
..#/##./... => .###/.###/####/...#
#.#/##./... => ####/#.#./###./##..
.##/##./... => ##../..#./###./..#.
###/##./... => ##../..../.##./#.#.
.../#.#/... => ..#./.#.#/.##./#.##
#../#.#/... => ####/..##/#.../#.#.
.#./#.#/... => #.../#..#/#.../..##
##./#.#/... => .#.#/##.#/.###/#..#
#.#/#.#/... => ..#./##.#/##../#..#
###/#.#/... => ####/#..#/.##./###.
.../###/... => .##./..##/..#./#...
#../###/... => .##./###./##../.###
.#./###/... => ##../..../..##/##..
##./###/... => ##.#/#.#./#.#./##..
#.#/###/... => ..##/.#.#/..../.#.#
###/###/... => ####/.#../...#/.#..
..#/.../#.. => .#.#/#..#/##../##.#
#.#/.../#.. => ...#/.#.#/##.#/###.
.##/.../#.. => ..##/##../#.../#.##
###/.../#.. => ..##/##../#.#./##..
.##/#../#.. => #.##/####/##../####
###/#../#.. => ##../#..#/#.##/####
..#/.#./#.. => #.#./#.##/...#/..#.
#.#/.#./#.. => ..../...#/..../#.#.
.##/.#./#.. => ...#/#..#/.#../##.#
###/.#./#.. => .#../..#./.#../.#..
.##/##./#.. => #.##/..../#.##/.#..
###/##./#.. => #.../##../#.#./#.##
#../..#/#.. => #.../..##/#.#./.#..
.#./..#/#.. => ##../#.../#..#/##.#
##./..#/#.. => ###./#..#/..##/....
#.#/..#/#.. => ...#/##.#/#.../####
.##/..#/#.. => .##./###./#.../#..#
###/..#/#.. => #.#./.#.#/.#.#/...#
#../#.#/#.. => ##.#/####/#.##/##.#
.#./#.#/#.. => ...#/.#.#/.#../.##.
##./#.#/#.. => ##.#/.##./#.##/####
..#/#.#/#.. => ##../.#../##.#/#.#.
#.#/#.#/#.. => ..#./###./#..#/.#.#
.##/#.#/#.. => ..../.##./..#./##.#
###/#.#/#.. => #.#./.#../###./##..
#../.##/#.. => ##.#/##.#/.#.#/#.##
.#./.##/#.. => ###./.##./..../####
##./.##/#.. => ####/#..#/##../###.
#.#/.##/#.. => ####/..#./#..#/.#.#
.##/.##/#.. => ##../##.#/#.##/.##.
###/.##/#.. => ..../..#./####/##.#
#../###/#.. => ####/.#.#/#..#/#...
.#./###/#.. => #.#./#.#./.#../#...
##./###/#.. => ..../#.#./.##./##..
..#/###/#.. => ##.#/...#/.#../#.#.
#.#/###/#.. => ####/.##./..##/..#.
.##/###/#.. => .###/..#./..#./##.#
###/###/#.. => ##../..##/.###/.##.
.#./#.#/.#. => ...#/##../.#.#/##.#
##./#.#/.#. => ##../##../..##/##..
#.#/#.#/.#. => .##./###./#.##/.##.
###/#.#/.#. => .#.#/.#../.#.#/.##.
.#./###/.#. => #.##/####/#..#/....
##./###/.#. => #.../#.#./#.../#.##
#.#/###/.#. => ###./#.#./##../#...
###/###/.#. => ..##/.#.#/###./#..#
#.#/..#/##. => #.../#.#./..##/#...
###/..#/##. => #.../##.#/#.#./.###
.##/#.#/##. => ###./#.../..##/...#
###/#.#/##. => ...#/.###/#.##/.#..
#.#/.##/##. => .###/..#./#..#/....
###/.##/##. => ..../##.#/#..#/##.#
.##/###/##. => #.#./..##/.##./##.#
###/###/##. => ..../#..#/..../...#
#.#/.../#.# => .###/#.../.##./....
###/.../#.# => .#../.#../.#../#...
###/#../#.# => ..../##.#/##../##..
#.#/.#./#.# => ..##/#.#./##../#...
###/.#./#.# => ##../..../#.../#..#
###/##./#.# => #.../.##./.###/..##
#.#/#.#/#.# => #.../..##/#.#./##.#
###/#.#/#.# => ...#/#.##/#.##/#...
#.#/###/#.# => ##.#/###./#..#/..##
###/###/#.# => ..##/####/.##./..#.
###/#.#/### => #.##/..../..../#.#.
###/###/### => ###./..##/.#.#/....
"""
}
