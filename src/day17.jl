module Day17

using AdventOfCode2016
using MD5

function day17(input::String = readInput(joinpath(@__DIR__, "..", "data", "day17.txt")))
    input = rstrip(input)
    return [find_path(input), find_path(input; shortest_path = false)]
end

function at_vault(sequence::String)
    return position(sequence).I == (4, 4)
end

function position(sequence::String)
    d = Dict('U' => 0, 'D' => 0, 'L' => 0, 'R' => 0)
    for ch in sequence
        d[ch] += 1
    end
    return CartesianIndex(1 + d['D'] - d['U'], 1 + d['R'] - d['L'])
end

function available_doors(input::AbstractString, sequence::String)
    # Order: Up, Down, Left, Right
    up = Bool[0 0 0 0 ; 1 1 1 1 ; 1 1 1 1 ; 1 1 1 1]
    down = Bool[1 1 1 1 ; 1 1 1 1 ; 1 1 1 1 ; 0 0 0 0]
    left = Bool[0 1 1 1 ; 0 1 1 1 ; 0 1 1 1 ; 0 1 1 1]
    right = Bool[1 1 1 0 ; 1 1 1 0 ; 1 1 1 0 ; 1 1 1 0]
    hash = bytes2hex(md5(input * sequence))
    open = map(x -> x[1] ∈ ('b', 'c', 'd', 'e', 'f'), split(hash[1:4], ""))
    ind = position(sequence)
    return Bool[up[ind] & open[1], down[ind] & open[2], left[ind] & open[3], right[ind] & open[4]]
end

function find_path(input::AbstractString; shortest_path = true)
    queue = String[""]
    path = ""
    while length(queue) > 0
        sequence = popfirst!(queue)
        doors = available_doors(input, sequence)
        for (i, d) in zip(1:4, ('U', 'D', 'L', 'R'))
            if doors[i]
                seq = sequence * d
                if at_vault(seq)
                    path = seq
                    shortest_path && return seq
                else
                    push!(queue, seq)
                end
            end
        end
    end
    return length(path)
end

end # module