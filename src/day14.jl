module Day14

using AdventOfCode2016
using MD5

function day14(input::String = readInput(joinpath(@__DIR__, "..", "data", "day14.txt")))
    input = rstrip(input)
    return [solve(input, 0), solve(input, 2016)]
end

function solve(input::AbstractString, n_additional::Int)
    producers = Int[]

    # TODO: Use circular buffer instead of a dictionary
    lookup = Dict{Int,AbstractString}()
    i = 0
    while length(producers) < 64
        i > 1 && delete!(lookup, i-1)
        if haskey(lookup, i)
            hash = lookup[i]
        else
            hash = bytes2hex(md5(input * string(i)))
            for k = 1:n_additional
                hash = bytes2hex(md5(hash))
            end
            lookup[i] = hash
        end
        c = triplet_char(hash)
        if c != '-'
            for j = i + 1:i + 999
                if haskey(lookup, j)
                    followuphash = lookup[j]
                else
                    followuphash = bytes2hex(md5(input * string(j)))
                    for k = 1:n_additional
                        followuphash = bytes2hex(md5(followuphash))
                    end
                    lookup[j] = followuphash
                end
                if contains_five_of_a_kind(followuphash, c)
                    push!(producers, i)
                end
            end
        end
        i += 1
    end
    return producers[end]
end

function triplet_char(s::AbstractString)
    i = 1
    while i <= length(s) - 2
        s[i] == s[i+1] == s[i+2] && return s[i]
        i += 1
    end
    return '-'
end

function contains_five_of_a_kind(s::AbstractString, kind::Char)
    return occursin(kind^5, s)
end

end # module