module Day19

using AdventOfCode2016

function day19(input::String = readInput(joinpath(@__DIR__, "..", "data", "day19.txt")))
    input = parse(Int, input)
    return [part1(input), part2(input)]
end

function part1(n::Int)
    next = collect(2:n+1)
    next[end] = 1
    previ, i = 0, 1
    while previ != i
        previ = i
        next[i] = next[next[i]]
        i = next[i]
    end
    return i
end

function part2(n::Int)
    left = collect(1:n÷2)
    right = collect(n÷2+1: n)
    while length(left) > 0 && length(right) > 0
        if length(right) >= length(left)
            popfirst!(right)
        else
            pop!(left)
        end
        push!(right, popfirst!(left))
        push!(left, popfirst!(right))
    end
    length(left) == 0 && return right[1]
    return left[1]
end

end # module