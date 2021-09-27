module Day10

using AdventOfCode2016

mutable struct Bot
    number::Int
    values::Array{Int,1}
    low::Base.RefValue{Vector{Int}}
    high::Base.RefValue{Vector{Int}}
end

function day10(input::String = readInput(joinpath(@__DIR__, "..", "data", "day10.txt")))
    botnumbers = Set{Int}()
    outputnumbers = Set{Int}()
    botoccurences = findall(r"bot\s+(\d+)", input)
    outputoccurences = findall(r"output\s+(\d+)", input)
    for range in botoccurences
        m = match(r"bot\s+(\d+)", input[range])
        m === nothing && continue
        push!(botnumbers, parse(Int, m.captures[1]))
    end
    for range in outputoccurences
        m = match(r"output\s+(\d+)", input[range])
        m === nothing && continue
        push!(outputnumbers, parse(Int, m.captures[1]))
    end
    bots = Dict{Int, Bot}()
    for bn in botnumbers
        bots[bn] = Bot(bn, Int[], Ref(Int[]), Ref(Int[]))
    end
    outputs = Dict{Int, Array{Int,1}}()
    for on in outputnumbers
        outputs[on] = Int[]
    end
    
    for line in split(input, "\n")
        if startswith(line, "value")
            m = match(r"value\s+(\d+)\s+goes\s+to\s+bot\s+(\d+)", line)
            m === nothing && continue
            value = parse(Int, m.captures[1])
            botnumber = parse(Int, m.captures[2])
            push!(bots[botnumber].values, value)
        else
            m = match(r"bot\s+(\d+)\s+gives\s+low\s+to\s(bot|output)\s+(\d+)\s+and\s+high\s+to\s+(bot|output)\s+(\d+)", line)
            m === nothing && continue
            botnumber = parse(Int, m.captures[1])
            lowto = parse(Int, m.captures[3])
            highto = parse(Int, m.captures[5])
            if m.captures[2] == "bot"
                bots[botnumber].low = Ref(bots[lowto].values)
            else
                bots[botnumber].low = Ref(outputs[lowto])
            end
            if m.captures[4] == "bot"
                bots[botnumber].high = Ref(bots[highto].values)
            else
                bots[botnumber].high = Ref(outputs[highto])
            end
        end
    end
    return solve(bots, outputs)
end

function solve(bots, outputs)
    p1 = -100
    p2 = -100
    donep1 = false
    donep2 = false
    while !(donep1 && donep2)
        if length(outputs[0]) != 0 && length(outputs[1]) != 0 && length(outputs[2]) != 0
            p2 = pop!(outputs[0]) * pop!(outputs[1]) * pop!(outputs[2])
            donep2 = true
        end
        for (bn, bot) in bots
            length(bot.values) < 2 && continue
            if 17 ∈ bot.values && 61 ∈ bot.values
                p1 = bn
                donep1 = true
            end
            a = pop!(bot.values)
            b = pop!(bot.values)
            a, b = minmax(a, b)
            push!(bot.low[], a)
            push!(bot.high[], b)
        end
    end
    return [p1, p2]
end

end # module