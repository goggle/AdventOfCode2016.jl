module Day18

using AdventOfCode2016

function day18(input::String = readInput(joinpath(@__DIR__, "..", "data", "day18.txt")))
    safetiles = generate_initial_safe_tile_map(input, 40)
    calculate_safe_tiles!(safetiles)
    p1 = sum(safetiles)
    safetiles = generate_initial_safe_tile_map(input, 400000)
    calculate_safe_tiles!(safetiles)
    p2 = sum(safetiles)
    return [p1, p2]
end

function generate_initial_safe_tile_map(input::AbstractString, nrows::Int)
    input = rstrip(input)
    safetiles = zeros(Bool, nrows, length(input))
    for j = 1:length(input)
        if input[j] == '.'
            safetiles[1,j] = true
        end
    end
    return safetiles
end

function calculate_safe_tiles!(stiles::Matrix{Bool})
    nrows, ncols = size(stiles)
    for i = 2:nrows
        for j = 1:ncols
            istrap = false
            if j == 1
                left = true
            else
                left = stiles[i-1,j-1]
            end
            center = stiles[i-1,j]
            if j == ncols
                right = true
            else
                right = stiles[i-1, j+1]
            end
            if (!left && !center && right) || (left && !center && !right) || (!left && center && right) || (left && center && !right)
                istrap = true
            end
            stiles[i,j] = !istrap
        end
    end
end

end # module