module Day20

using AdventOfCode2016

function day20(input::String = readInput(joinpath(@__DIR__, "..", "data", "day20.txt")))
    blacklist = UnitRange{Int}[]
    for line in split(rstrip(input), "\n")
        first, second = parse.(Int, split(line, '-'))
        push!(blacklist, first:second)
    end

    blacklist = simplify(blacklist)
    whitelist = generate_whitelist(blacklist)

    return [part1(whitelist), part2(whitelist)]
end

function part1(whitelist)
    return whitelist[1].start
end

function part2(whitelist)
    return length.(whitelist) |> sum
end

function simplify(blacklist)
    simplified = UnitRange{Int}[]
    for (i, elem) in enumerate(blacklist)
        add = true
        for (j, comp) in enumerate(blacklist)
            i == j && continue
            if elem.start >= comp.start && elem.stop <= comp.stop
                add = false
                break
            end
        end
        if add
            push!(simplified, elem)
        end
    end
    return simplified
end

function generate_whitelist(blacklist; minip = 0, maxip = 4294967295)
    whitelist = UnitRange{Int}[minip:maxip]
    for range in blacklist
        whitelist = exclude(whitelist, range)
    end
    return whitelist
end

function is_subrange(r, subr)
    return subr.start >= r.start && subr.stop <= r.stop
end

function exclude(whitelist, r)
    nwl = UnitRange{Int}[]

    i = 1
    while i <= length(whitelist) && whitelist[i].stop < r.start
        push!(nwl, whitelist[i])
        i += 1
    end

    if i <= length(whitelist) && r.start ∈ whitelist[i]
        tr = whitelist[i].start:(r.start-1)
        if length(tr) > 0
            push!(nwl, tr)
        end
    end

    while i <= length(whitelist) && r.stop > whitelist[i].stop
        i += 1
    end

    if i <= length(whitelist) && r.stop ∈ whitelist[i]
        tr = (r.stop+1):whitelist[i].stop
        if length(tr) > 0
            push!(nwl, tr)
        end
        i += 1
    end

    while i <= length(whitelist)
        push!(nwl, whitelist[i])
        i += 1
    end

    return nwl
end


end # module