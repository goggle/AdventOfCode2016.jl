module Day13

using AdventOfCode2016

function day13(input::String = readInput(joinpath(@__DIR__, "..", "data", "day13.txt")))
    favnumber = parse(Int, input)
    return solve(favnumber, 31, 39)
end

function is_open_space(favnumber::Int, x::Int, y::Int)
    x >= 0 && y >= 0 && mod(x*x + 3*x + 2*x*y + y + y*y + favnumber |> count_ones, 2) == 0 && return true
    return false
end

function solve(favnumber::Int, xtarget::Int, ytarget::Int)
    p1, p2 = 0, 0
    p1done, p2done = false, false
    nsteps = 0
    current_positions = [(1, 1)]
    visited = Set([(1,1)])
    while !(p1done && p2done)
        if (xtarget, ytarget) ∈ current_positions
            p1, p1done = nsteps, true
        end
        if nsteps == 50
            p2, p2done = length(visited), true
        end
        tmppositions = copy(current_positions)
        current_positions = Array{Tuple{Int,Int},1}()
        for cp in tmppositions
            poss = [cp .+ (1, 0), cp .+ (0, 1), cp .+ (-1, 0), cp .+ (0, -1)]
            for pos in poss
                if pos ∉ visited && is_open_space(favnumber, pos...)
                    push!(visited, pos)
                    push!(current_positions, pos)
                end
            end
        end
        nsteps += 1
    end
    return [p1, p2]
end

end # module