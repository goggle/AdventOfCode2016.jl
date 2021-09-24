module Day06

using AdventOfCode2016
using LinearAlgebra

function day06(input::String = readInput(joinpath(@__DIR__, "..", "data", "day06.txt")))
    data = transpose(reduce(hcat, collect.(split(input))))
    return solve(data)
end

LinearAlgebra.adjoint(c::Char) = c
LinearAlgebra.transpose(c::Char) = c

function solve(data)
    p1 = []
    p2 = []
    for j = 1:size(data)[2]
        counts = sort([(i, count(==(i), data[:,j])) for i in unique(data[:,j])], by=x->x[2])
        push!(p1, counts[end][1])
        push!(p2, counts[1][1])
    end
    return [join(p1), join(p2)]
end

end # module