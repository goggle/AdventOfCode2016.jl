module Day25

using AdventOfCode2016

function day25(input::String = readInput(joinpath(@__DIR__, "..", "data", "day25.txt")))
    # Find the smallest positive a that produces 0, 1, 0, 1, ...
    a = 1
    while true
        registers, code = parse_and_initialize_registers(input, a, 0, 0, 0)
        outputs = run!(registers, code)
        if length(outputs) >= 100 && all(outputs[i] == (i-1) % 2 for i ∈ eachindex(outputs))
            return a
        end
        a += 1
    end
end

function parse_and_initialize_registers(input::AbstractString, a::Int, b::Int, c::Int, d::Int)
    registers = Dict('a' => a, 'b' => b, 'c' => c, 'd' => d)
    F = Union{typeof(cpy!), typeof(inc!), typeof(dec!), typeof(jnz), typeof(tgl!), typeof(out!)}
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
        elseif tokens[1] == "out"
            x = tryparse(Int, tokens[2])
            if x === nothing
                x = tokens[2][1]
            end
            y = 0
            push!(code, (out!, x, y))
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
    elseif func == cpy! || func == out!
        func = jnz
    end
    code[j] = (func, arg1, arg2)
    return i + 1
end

function out!(code, registers::Dict{Char,Int}, i::Int, x::Int, ::Int, outputs::Vector{Int})
    push!(outputs, x)
    return i + 1
end

function out!(code, registers::Dict{Char,Int}, i::Int, x::Char, ::Int, outputs::Vector{Int})
    push!(outputs, registers[x])
    return i + 1
end

function run!(registers::Dict{Char,Int}, code::Vector{Tuple{F,Any,Any}} where F)
    toggled = fill(false, length(code))
    outputs = Int[]
    i = 1
    iterations = 0
    max_outputs = 100
    while i >= 1 && i <= length(code)
        iterations += 1
        if length(outputs) >= max_outputs
            return outputs
        end
        func, x, y = code[i]
        if func == tgl!
            i = tgl!(code, toggled, registers, i, x, y)
        elseif func == out!
            i = out!(code, registers, i, x, y, outputs)
            # Check if output is valid (0 or 1) and alternates
            if !isempty(outputs) && (outputs[end] ∉ [0, 1] || (length(outputs) > 1 && outputs[end] == outputs[end-1]))
                return outputs
            end
        else
            i = func(code, registers, i, x, y)
        end
    end
    return outputs
end

end # module