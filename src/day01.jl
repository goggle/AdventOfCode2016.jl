module Day01

using AdventOfCode2016

function day01(input::String = readInput(joinpath(@__DIR__, "..", "data", "day01.txt")))
    instructions = lstrip.(split(rstrip(input), ','))
    dir = 0
    pos = [0, 0]
    visited = [[0, 0]]
    part2 = 0
    found = false
    for instruction in instructions
        if instruction[1] == 'R'
            dir = turn_right(dir)
        elseif instruction[1] == 'L'
            dir = turn_left(dir)
        end
        length = parse(Int, instruction[2:end])
        if !found
            for i = 1:length
                p = pos + i * dir2d(dir)
                if p ∉ visited
                    push!(visited, copy(p))
                else
                    part2 = sum(abs.(p))
                    found = true
                    break
                end
            end
        end
        pos = pos + length * dir2d(dir)
    end
    part1 = sum(abs.(pos))
    return [part1, part2]
end

function dir2d(dir::Int)
    dir == 0 && return [0, 1]
    dir == 1 && return [1, 0]
    dir == 2 && return [0, -1]
    dir == 3 && return [-1, 0]
end

function turn_right(dir::Int)
    return mod(dir + 1, 4)
end

function turn_left(dir::Int)
    return mod(dir - 1, 4)
end


end # module
