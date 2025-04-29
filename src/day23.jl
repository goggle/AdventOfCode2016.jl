module Day23

using AdventOfCode2016

function day23(input::String = readInput(joinpath(@__DIR__, "..", "data", "day23.txt")))
    registers, code = parse_and_initialize_registers(input, 7, 0, 0, 0)
    p1 = run!(registers, code)
    registers, code = parse_and_initialize_registers(input, 12, 0, 0, 0)
    p2 = run!(registers, code)
    return [p1, p2]
end

function parse_and_initialize_registers(input::AbstractString, a::Int, b::Int, c::Int, d::Int)
    registers = Dict('a' => a, 'b' => b, 'c' => c, 'd' => d)
    F = Union{typeof(cpy!), typeof(inc!), typeof(dec!), typeof(jnz), typeof(tgl!)}
    code = Vector{Tuple{F,Any,Any}}()
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
            y = tryparse(Int, tokens[3])
            if y === nothing
                y = tokens[3][1]
            end
            push!(code, (jnz, x, y))
        elseif tokens[1] == "tgl"
            x = tokens[2][1]
            y = 0
            push!(code, (tgl!, x, y))
        end
    end
    return registers, code
end

function cpy!(code, registers::Dict{Char,Int}, i::Int, x::Int, y::Char)
    registers[y] = x
    return i + 1
end

function cpy!(code, registers::Dict{Char,Int}, i::Int, x::Char, y::Char)
    registers[y] = registers[x]
    return i + 1
end

function cpy!(code, registers::Dict{Char,Int}, i::Int, x::Char, y::Int)
    return i + 1
end

function cpy!(code, registers::Dict{Char,Int}, i::Int, x::Int, y::Int)
    return i + 1
end

function inc!(code, registers::Dict{Char,Int}, i::Int, x::Char, ::Int)
    registers[x] += 1
    return i + 1
end

function dec!(code, registers::Dict{Char,Int}, i::Int, x::Char, ::Int)
    registers[x] -= 1
    return i + 1
end

function jnz(code, registers::Dict{Char,Int}, i::Int, x::Int, y::Int)
    x != 0 && return i + y
    return i + 1
end

function jnz(code, registers::Dict{Char,Int}, i::Int, x::Char, y::Int)
    registers[x] != 0 && return i + y
    return i + 1
end

function jnz(code, registers::Dict{Char,Int}, i::Int, x::Int, y::Char)
    x != 0 && return i + registers[y]
    return i + 1
end

function jnz(code, registers::Dict{Char,Int}, i::Int, x::Char, y::Char)
    registers[x] != 0 && return i + registers[y]
    return i + 1
end

function tgl!(code, toggled::Vector{Bool}, registers::Dict{Char,Int}, i::Int, x::Char, y::Int)
    j = i + registers[x]
    if j < 1 || j > length(code)
        return i + 1
    end
    toggled[j] = true
    func, arg1, arg2 = code[j]
    if func == inc!
        func = dec!
    elseif func == dec! || func == tgl!
        func = inc!
    elseif func == jnz
        func = cpy!
    elseif func == cpy!
        func = jnz
    end
    code[j] = (func, arg1, arg2)
    return i + 1
end

function multiply_loop!(code::Vector{Tuple{F,Any,Any}} where F, toggled::Vector{Bool}, registers::Dict{Char,Int}, i::Int)
    # Assumes pattern: cpy b c; inc a; dec c; jnz c -2; dec d; jnz d -5
    # Computes a = b * d, sets c=0, d=0
    if i != 5 || any(toggled[i:i+5])
        return false, i
    end
    registers['a'] = registers['b'] * registers['d']
    registers['c'] = 0
    registers['d'] = 0
    return true, 11  # Skip to after jnz d -5
end

function run!(registers::Dict{Char,Int}, code::Vector{Tuple{F,Any,Any}} where F)
    toggled = fill(false, length(code))
    i = 1
    iterations = 0
    while i >= 1 && i <= length(code)
        iterations += 1
        # Check for multiplication loop at i=5
        if i == 5
            applied, new_i = multiply_loop!(code, toggled, registers, i)
            if applied
                i = new_i
                continue
            end
        end
        func, x, y = code[i]
        if func == tgl!
            i = tgl!(code, toggled, registers, i, x, y)
        else
            i = func(code, registers, i, x, y)
        end
    end
    return registers['a']
end

end # module