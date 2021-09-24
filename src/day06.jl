module Day06

using AdventOfCode2016

function day06(input::String = readInput(joinpath(@__DIR__, "..", "data", "day06.txt")))
    data = reduce(hcat, collect.(split(input)))
    return solve(data)
end

function solve(data)
    p1 = []
    p2 = []
    for k = 1:size(data)[1]
        counts = sort([(i, count(==(i), data[k,:])) for i in unique(data[k,:])], by=x->x[2])
        push!(p1, counts[end][1])
        push!(p2, counts[1][1])
    end
    return [join(p1), join(p2)]
end

end # module