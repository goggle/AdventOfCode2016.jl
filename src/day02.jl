module Day02

using AdventOfCode2016

function day02(input::String = readInput(joinpath(@__DIR__, "..", "data", "day02.txt")))
    lines = split(rstrip(input))

    return [part1(lines), part2(lines)]
end

function part1(lines)
    pad = [1 2 3 ; 4 5 6 ; 7 8 9]

    p1 = []
    i, j = 1, 1
    for line in lines
        for char in line
            ni, nj = i, j
            if char == 'U'
                ni -= 1
            elseif char == 'R'
                nj += 1
            elseif char == 'D'
                ni += 1
            elseif char == 'L'
                nj -= 1
            end
            if validp1(ni, nj)
                i, j = ni, nj
            end
        end
        push!(p1, pad[i, j])
    end
    return parse(Int, join(p1))
end

function validp1(i::Int, j::Int)
    return i >= 1 && i <= 3 && j >= 1 && j <= 3
end

function part2(lines)
    pad = ['0' '0' '1' '0' '0';
           '0' '2' '3' '4' '0';
           '5' '6' '7' '8' '9';
           '0' 'A' 'B' 'C' '0';
           '0' '0' 'D' '0' '0']
    p2 = []
    i, j = 3, 1
    for line in lines
        for char in line
            ni, nj = i, j
            if char == 'U'
                ni -= 1
            elseif char == 'R'
                nj += 1
            elseif char == 'D'
                ni += 1
            elseif char == 'L'
                nj -= 1
            end
            if validp2(ni, nj, pad)
                i, j = ni, nj
            end
        end
        push!(p2, pad[i, j])
    end
    return join(p2)
end

function validp2(i::Int, j::Int, pad::Matrix{Char})
    return i >= 1 && i <= 5 && j >= 1 && j <= 5 && pad[i, j] != '0'
end

end # module