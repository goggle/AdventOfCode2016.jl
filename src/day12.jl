module Day12

using AdventOfCode2016

function day12(input::String = readInput(joinpath(@__DIR__, "..", "data", "day12.txt")))
    registers = Dict{Char,Int}()
    for c in ('a', 'b', 'c', 'd')
        registers[c] = 0
    end
    code = []
    for line in split(rstrip(input), "\n")
        tokens = split(line)
        if tokens[1] == "cpy"
            x = tryparse(Int, tokens[2])
            if x === nothing
                x = tokens[2][1]
            end
            y = tokens[3][1]
            push!(code, (cpy!, x, y))
        elseif tokens[1] == "inc"
            x = tokens[2][1]
            y = 0
            push!(code, (inc!, x, y))
        elseif tokens[1] == "dec"
            x = tokens[2][1]
            y = 0
            push!(code, (dec!, x, y))
        elseif tokens[1] == "jnz"
            x = tryparse(Int, tokens[2])
            if x === nothing
                x = tokens[2][1]
            end
            y = parse(Int, tokens[3])
            push!(code, (jnz, x, y))
        end
    end
    p1 = run!(registers, code)
    for c in ('a', 'b', 'd')
        registers[c] = 0
    end
    registers['c'] = 1
    p2 = run!(registers, code)
    return [p1, p2]
end

function cpy!(registers::Dict{Char,Int}, i::Int, x::Int, y::Char)
    registers[y] = x
    return i + 1
end

function cpy!(registers::Dict{Char,Int}, i::Int, x::Char, y::Char)
    registers[y] = registers[x]
    return i + 1
end

function inc!(registers::Dict{Char,Int}, i::Int, x::Char, ::Int)
    registers[x] += 1
    return i + 1
end

function dec!(registers::Dict{Char,Int}, i::Int, x::Char, ::Int)
    registers[x] -= 1
    return i + 1
end

function jnz(registers::Dict{Char,Int}, i::Int, x::Int, y::Int)
    x != 0 && return i + y
    return i + 1
end

function jnz(registers::Dict{Char,Int}, i::Int, x::Char, y::Int)
    registers[x] != 0 && return i + y
    return i + 1
end

function run!(registers::Dict{Char,Int}, code)
    i = 1
    while i >= 1 && i <= length(code)
        func, x, y = code[i]
        i = func(registers, i, x, y)
    end
    return registers['a']
end

end # module