module Day21

using AdventOfCode2016

function day21(input::String = readInput(joinpath(@__DIR__, "..", "data", "day21.txt")))
    instructions = parse_input(input)
    p1 = run("abcdefgh", instructions)
    reversed_instructions = reverse_instructions(instructions)
    p2 = run("fbgdceah", reversed_instructions)
    return [p1, p2]
end

function run(word::String, instructions)
    a = collect(word)
    for instruction in instructions
        instruction[1](a, instruction[2]...)
    end
    return join(a)
end

function parse_input(input::AbstractString)
    lines = split(rstrip(input), '\n')
    instructions = []
    for line in lines
        r = r"swap\s+position\s+(\d+)\s+with\s+position\s+(\d+)"
        m = match(r, line)
        if m !== nothing
            push!(instructions, (swap!, [parse(Int, m.captures[1]), parse(Int, m.captures[2])]))
            continue
        end
        r = r"swap\s+letter\s+(\p{L})\s+with\s+letter\s+(\p{L})"
        m = match(r, line)
        if m !== nothing
            push!(instructions, (swap!, [m.captures[1][1], m.captures[2][1]]))
            continue
        end
        r = r"rotate\s+left\s+(\d+)\s+steps?"
        m = match(r, line)
        if m !== nothing
            push!(instructions, (rotate_left!, [parse(Int, m.captures[1])]))
            continue
        end
        r = r"rotate\s+right\s+(\d+)\s+steps?"
        m = match(r, line)
        if m !== nothing
            push!(instructions, (rotate_right!, [parse(Int, m.captures[1])]))
            continue
        end
        r = r"rotate\s+based\s+on\s+position\s+of\s+letter\s+(\p{L})"
        m = match(r, line)
        if m !== nothing
            push!(instructions, (rotate!, [m.captures[1][1]]))
            continue
        end
        r = r"reverse\s+positions\s+(\d+)\s+through\s+(\d+)"
        m = match(r, line)
        if m !== nothing
            push!(instructions, (reverse!, [parse(Int, m.captures[1]), parse(Int, m.captures[2])]))
            continue
        end
        r = r"move\s+position\s+(\d+)\s+to\s+position\s+(\d+)"
        m = match(r, line)
        if m !== nothing
            push!(instructions, (remove_insert!, [parse(Int, m.captures[1]), parse(Int, m.captures[2])]))
            continue
        end
        if m === nothing
            println(line)
        end
    end
    return instructions
end

function swap!(arr::Array{Char,1}, i::Int, j::Int)
    tmp = arr[i+1]
    arr[i+1] = arr[j+1]
    arr[j+1] = tmp
end

function swap!(arr::Array{Char,1}, a::Char, b::Char)
    i = findfirst(arr .== a) - 1
    j = findfirst(arr .== b) - 1
    swap!(arr, i, j)
end

function rotate_left!(arr::Array{Char,1}, n::Int)
    a = copy(arr)
    n = mod(n, length(arr))
    for i = 1:length(arr) - n
        arr[i] = a[i+n]
    end
    j = 1
    for i = length(arr)-n+1:length(arr)
        arr[i] = a[j]
        j += 1
    end
end

function rotate_right!(arr::Array{Char,1}, n::Int)
    rotate_left!(arr, -n)
end

function rotate!(arr::Array{Char,1}, x::Char)
    i = findfirst(arr .== x) - 1
    rotate_right!(arr, 1 + i)
    if i >= 4
        rotate_right!(arr, 1)
    end
end

function revrotate!(arr::Array{Char,1}, x::Char)
    i = 0
    while true
        a = copy(arr)
        rotate_left!(a, i)
        rotate!(a, x)
        a == arr && break
        i += 1
    end
    rotate_left!(arr, i)
end

function reverse!(arr::Array{Char,1}, i::Int, j::Int)
    a = copy(arr)
    i, j = minmax(i, j)
    i += 1
    j += 1
    l = 0
    for k = i:j
        arr[k] = a[j-l]
        l += 1
    end
end

function remove_insert!(arr::Array{Char,1}, i::Int, j::Int)
    i += 1
    j += 1
    a = copy(arr)
    if i <= j
        for k = i:j-1
            arr[k] = a[k+1]
        end
        arr[j] = a[i]
    else
        arr[j] = a[i]
        for k = j+1:i
            arr[k] = a[k-1]
        end
    end
end

function reverse_instructions(instructions)
    rev = []
    for instruction in reverse(instructions)
        if instruction[1] == swap!
            push!(rev, instruction)
        elseif instruction[1] == rotate_left!
            push!(rev, (rotate_right!, [instruction[2][1]]))
        elseif instruction[1] == rotate_right!
            push!(rev, (rotate_left!, [instruction[2][1]]))
        elseif instruction[1] == rotate!
            push!(rev, (revrotate!, [instruction[2][1]]))
        elseif instruction[1] == reverse!
            push!(rev, instruction)
        elseif instruction[1] == remove_insert!
            push!(rev, (remove_insert!, [instruction[2][2], instruction[2][1]]))
        end
    end
    return rev
end

end # module