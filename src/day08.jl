module Day08

using AdventOfCode2016

function day08(input::String = readInput(joinpath(@__DIR__, "..", "data", "day08.txt")))
    instructions = split(input, "\n")
    screen = run(instructions)
    return [count(screen), generate_image(screen)]
end

function run(instructions)
    screen = zeros(Bool, 6, 50)
    for line in instructions
        rectreg = r"rect\s*(\d+)x(\d+)"
        m = match(rectreg, line)
        if m !== nothing
            ncols = parse(Int, m.captures[1])
            nrows = parse(Int, m.captures[2])
            rect!(screen, ncols, nrows)
            continue
        end
        rotrreg = r"rotate\s*row\s*y=(\d+)\s*by\s*(\d+)"
        m = match(rotrreg, line)
        if m !== nothing
            row = parse(Int, m.captures[1]) + 1
            nshifts = parse(Int, m.captures[2])
            rotr!(screen, row, nshifts)
            continue
        end
        rotdreg = r"rotate\s*column\s*x=(\d+)\s*by\s*(\d+)"
        m = match(rotdreg, line)
        if m !== nothing
            col = parse(Int, m.captures[1]) + 1
            nshifts = parse(Int, m.captures[2])
            rotd!(screen, col, nshifts)
            continue
        end
    end
    return screen
end

function rect!(screen::Matrix{Bool}, ncols::Int, nrows::Int)
    for i = 1:nrows
        for j = 1:ncols
            screen[i,j] = true
        end
    end
end

function rotr!(screen::Matrix{Bool}, row::Int, nshifts::Int)
    N = size(screen)[2]
    newrow = hcat(screen[row,N-nshifts+1:N]', screen[row,1:N-nshifts]')
    screen[row,:] = newrow
end

function rotd!(screen::Matrix{Bool}, col::Int, nshifts::Int)
    N = size(screen)[1]
    newcol = vcat(screen[N-nshifts+1:N,col], screen[1:N-nshifts, col])
    screen[:,col] = newcol
end

function generate_image(image)
    image = Matrix{Int8}(image)
    block = '\u2588'
    empty = ' '
    output = ""
    for i = 1:size(image, 1)
        row = join(image[i, :])
        row = replace(row, "1" => block)
        row = replace(row, "0" => empty)
        output *= row * "\n"
    end
    return output
end

end # module