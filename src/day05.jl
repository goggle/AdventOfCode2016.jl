module Day05

using AdventOfCode2016
using MD5

function day05(input::String = readInput(joinpath(@__DIR__, "..", "data", "day05.txt")))
    input = rstrip(input)
    return [part1(input), part2(input)]
end

function part1(input::AbstractString)
    i = 0
    pass = []
    while length(pass) != 8
        hash = bytes2hex(md5(input * string(i)))
        if hash[1:5] == "00000"
            push!(pass, hash[6])
        end
        i += 1
    end
    return join(pass)
end

function part2(input::AbstractString)
    pass = ['-', '-', '-', '-', '-', '-', '-', '-']
    i = 0
    while true
        hash = bytes2hex(md5(input * string(i)))
        if hash[1:5] == "00000"
            if isnumeric(hash[6])
                pos = parse(Int, hash[6]) + 1
                if pos >= 1 && pos <= 8 && pass[pos] == '-'
                    pass[pos] = hash[7]
                    '-' ∉ pass && break
                end
            end
        end
        i += 1
    end
    return join(pass)
end




end # module