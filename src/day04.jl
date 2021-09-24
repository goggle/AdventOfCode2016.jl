module Day04

using AdventOfCode2016

function day04(input::String = readInput(joinpath(@__DIR__, "..", "data", "day04.txt")))
    p1, p2 = 0, 0
    for line in split(input)
        if is_real(line)
            m = match(r"(.+)-(\d+)\[.+", line)
            m === nothing && continue
            cipher = parse(Int, m.captures[2])
            p1 += cipher
            room = decrypt(m.captures[1], cipher)
            if occursin("northpole object storage",room)
                p2 = cipher
            end
        end
    end
    return [p1, p2]
end

function is_real(input::AbstractString)
    d = Dict{Char, Int}()
    for letter in input
        isnumeric(letter) && break
        letter == '-' && continue
        if !haskey(d, letter)
            d[letter] = 1
        else
            d[letter] += 1
        end
    end
    d = sort(collect(d), by=_sortcrit, rev=true)
    m = match(r".+\[(.+)\].*", input)
    m === nothing && return false
    checksum = m.captures[1]
    return checksum == join(first.(d[1:5]))
end

function _sortcrit(x)
    return (x[2], 'z' - x[1]) 
end

function decrypt(code::AbstractString, cipher::Int)
    a = []
    for letter in code
        if letter == '-'
            push!(a, ' ')
            continue
        end
        push!(a, Char(mod(Int(letter) - 97 + cipher, 26)) + 97)
    end
    return join(a)
end


end # module
