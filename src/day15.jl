module Day15

using AdventOfCode2016

function day15(input::String = readInput(joinpath(@__DIR__, "..", "data", "day15.txt")))
    n, positions = parse_input(input)
    a = similar(positions)
    for (i, pos) in enumerate(positions)
        a[i] = mod(-(i + pos), n[i])
    end
    p1 = solve_congruence_system!(copy(a), copy(n))
    push!(n, 11)
    push!(a, mod(-length(n), n[end]))
    p2 = solve_congruence_system!(a, n)
    return [p1, p2]
end

function parse_input(input::AbstractString)
    reg = r"Disc\s+#\d+\s+has\s+(\d+)\s+positions;\s+at\s+time=0,\s+it\s+is\s+at\s+position\s+(\d+)\."
    npositions = Int[]
    positions = Int[]
    for line in split(rstrip(input), "\n")
        m = match(reg, line)
        m === nothing && continue
        push!(npositions, parse(Int, m.captures[1]))
        push!(positions, parse(Int, m.captures[2]))
    end
    return npositions, positions
end

function solve_congruence_system!(a::Vector{Int}, n::Vector{Int})
    # Solve system of congruences by using the Chinese Remainder Theorem,
    # see https://en.wikipedia.org/wiki/Chinese_remainder_theorem
    a1 = pop!(a)
    n1 = pop!(n)
    while length(a) > 0
        a2 = pop!(a)
        n2 = pop!(n)
        N = n1 * n2
        _, m1, m2 = gcdx(n1, n2)
        a1 = mod(a1*m2*n2 + a2*m1*n1, N)
        n1 = N
    end
    return a1
end

end # module