module Day09

using AdventOfCode2016

function day09(input::String = readInput(joinpath(@__DIR__, "..", "data", "day09.txt")))
    input = rstrip(input)
    return [part1(input), part2(input)]
end

function decompress(input::AbstractString)
    parts = []
    i = 1
    reg = r"\((\d+)x(\d+)\)(.*)"
    buffer = []
    while i <= length(input)
        if input[i] != '('
            push!(buffer, input[i])
        else
            if length(buffer) != 0
                push!(parts, (join(buffer), 1))
                buffer = []
            end
            m = match(reg, input[i:end])
            m === nothing && break
            nchar = parse(Int, m.captures[1])
            ntimes = parse(Int, m.captures[2])
            i += m.offsets[3] - 1
            push!(parts, (input[i:i+nchar-1], ntimes))
            i += nchar
            continue
        end
        i += 1
    end
    if length(buffer) != 0
        push!(parts, (join(buffer), 1))
    end
    return parts
end

function decompress(parts::AbstractArray)
    reg = r"\((\d+)x(\d+)\)(.*)"
    newparts = []
    for (item, n) in parts
        if isa(item, Int)
            push!(newparts, (item, n))
        elseif occursin(reg, item)
            p = decompress(item)
            for (it, m) in p
                push!(newparts, (it, m*n))
            end
        else
            push!(newparts, (length(item), n))
        end
    end
    return newparts
end

function done(::AbstractString)
    return false
end

function done(inp::AbstractArray)
    for (item, _) in inp
        !isa(item, Int) && return false
    end
    return true
end

function part1(input::AbstractString)
    parts = decompress(input)
    s = 0
    for (str, i) in parts
        s += length(str) * i
    end
    return s
end

function part2(input::AbstractString)
    while !done(input)
        input = decompress(input)
    end
    s = 0
    for (i, j) in input
        s += i * j
    end
    return s
end

end # module