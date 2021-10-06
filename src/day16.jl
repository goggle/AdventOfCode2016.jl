module Day16

using AdventOfCode2016

function day16(input::String = readInput(joinpath(@__DIR__, "..", "data", "day16.txt")))
    input = rstrip(input)
    a = BitArray(undef, length(input))
    for (i, ch) in enumerate(input)
        if ch == '0'
            a[i] = false
        else
            a[i] = true
        end
    end

    data = generate_data(a, 272)
    p1 = calculate_checksum(data, 272)
    data = generate_data(a, 35651584)
    p2 = calculate_checksum(data, 35651584)
    return [p1, p2]
end

function generate_data(a::BitVector, len::Int)
    while length(a) < len
        b = .!reverse(a)
        a = vcat(a, [false], b)
    end
    return a
end

function calculate_checksum(a::BitVector, len::Int)
    a = a[1:len]
    while mod(len, 2) == 0
        len = len ÷ 2
        b = BitVector(undef, len)
        for i in 1:len
            b[i] = !(a[2i-1] ⊻ a[2i])
        end
        a = b
    end
    return join(Vector{UInt8}(a))
end

end # modulee