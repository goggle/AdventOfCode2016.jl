module Day24

using AdventOfCode2016
using Combinatorics
using OffsetArrays

Base.adjoint(c::Char) = c
function day24(input::String = readInput(joinpath(@__DIR__, "..", "data", "day24.txt")))
    maze = vcat([x' for x in collect.(split(rstrip(input)))]...)
    distances = calculate_distance_matrix(maze)
    p1 = shortest_distance(distances)
    p2 = shortest_distance(distances, return_to_zero = true)
    return [p1, p2]
end

function shortest_distance(distances::OffsetMatrix{Int, Matrix{Int}}; return_to_zero = false)
    shortest_distance = sum(distances)
    for perm in permutations(1:size(distances)[1]-1)
        prev = 0
        dist = 0
        if return_to_zero
            push!(perm, 0)
        end
        for curr in perm
            dist += distances[prev, curr]
            prev = curr
            dist >= shortest_distance && break
        end
        if dist < shortest_distance
            shortest_distance = dist
        end
    end
    return shortest_distance
end

function calculate_distance_matrix(maze::Matrix{Char})
    destinds = get_destination_indices(maze)
    m = length(destinds) - 1
    dists = Vector{OffsetArrays.OffsetVector{Int, Vector{Int}}}(undef, m+1)
    for i = 0:m
        dists[i+1] = calculate_distances(maze, i, destinds)
    end
    return OffsetArray(vcat(dists'...), 0:m, 0:m)
end

function get_destination_indices(maze::Matrix{Char})
    m = -1
    finds = CartesianIndex{2}[]
    for c ∈ map(x -> x[1], string.(0:9))
        f = findfirst(x -> (x == c), maze)
        f === nothing && break
        push!(finds, f)
        m += 1
    end
    return OffsetArray(finds, 0:m)
end

function calculate_distances(maze::Matrix{Char}, from::Int, to::OffsetVector{CartesianIndex{2}, Vector{CartesianIndex{2}}})
    start = findfirst(x -> (x == string(from)[1]), maze)
    cmap = fill!(similar(maze, Int), -1)
    cmap[start] = 0
    current = [start]
    while length(current) > 0
        c = popfirst!(current)
        val = cmap[c]
        for n ∈ (c + CartesianIndex(1, 0), c + CartesianIndex(-1, 0), c + CartesianIndex(0, 1), c + CartesianIndex(0, -1))
            if maze[n] != '#' && cmap[n] == -1
                cmap[n] = val + 1
                push!(current, n)
            end
        end
    end
    distances = OffsetArray(zeros(Int, length(to)), 0:length(to)-1)
    for i = 0:length(to)-1
        distances[i] = cmap[to[i]]
    end
    return distances
end

end # module