module Day03

using AdventOfCode2016

function day03(input::String = readInput(joinpath(@__DIR__, "..", "data", "day03.txt")))
    input = lstrip.(split(rstrip(input), "\n"))
    p1 = 0
    for line in input
        triangle = sort(parse.(Int, split(line)))
        if triangle[1] + triangle[2] > triangle[3]
            p1 += 1
        end
    end

    inputp2 = vcat(transpose(parse.(Int, reduce(hcat, split.(input))))...)
    p2 = 0
    i = 1
    while i < length(inputp2)
        triangle = sort([inputp2[i], inputp2[i+1], inputp2[i+2]])
        if triangle[1] + triangle[2] > triangle[3]
            p2 += 1
        end
        i += 3
    end

    return [p1, p2]
end


end # module
