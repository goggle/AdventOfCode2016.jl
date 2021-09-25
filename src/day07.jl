module Day07

using AdventOfCode2016

function day07(input::String = readInput(joinpath(@__DIR__, "..", "data", "day07.txt")))
    p1, p2 = 0, 0
    for line in split(input)
        if supports_tls(line)
            p1 += 1
        end
        if supports_ssl(line)
            p2 += 1
        end
    end
    return [p1, p2]
end

function contains_abba(inp::AbstractString)
    i = 1
    while i + 3 <= length(inp)
        inp[i+1] == inp[i+2] && inp[i] == inp[i+3] && inp[i] != inp[i+1] && return true
        i += 1
    end
    return false
end

function supports_tls(inp::AbstractString)
    sp = split(inp, ('[', ']'))
    outside = sp[1:2:end]
    inside = sp[2:2:end]
    for square in inside
        contains_abba(square) && return false
    end
    for out in outside
        contains_abba(out) && return true
    end
    return false
end

function supports_ssl(inp::AbstractString)
    sp = split(inp, ('[', ']'))
    outside = sp[1:2:end]
    squares = sp[2:2:end]
    for out in outside
        i = 1
        while i + 2 <= length(out)
            if out[i] == out[i+2] && out[i] != out[i+1] && find_in_squares(out[i+1] * out[i] * out[i+1], squares)
                return true
            end
            i += 1
        end
    end
    return false
end

function find_in_squares(seq, squares)
    for str in squares
        i = 1
        while i + length(seq) - 1 <= length(str)
            if seq == str[i:i+length(seq)-1]
                return true
            end
            i += 1
        end
    end
    return false
end


end # module