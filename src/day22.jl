module Day22

using AdventOfCode2016

struct Node
    x::Int
    y::Int
    size::Int
    used::Int
    available::Int
end

function day22(input::String = readInput(joinpath(@__DIR__, "..", "data", "day22.txt")))
    nodes = Node[]
    r = r"/dev/grid/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T.*"
    for line in split(rstrip(input), '\n')
        m = match(r, line)
        if m !== nothing
            data = parse.(Int, m.captures)
            push!(nodes, Node(data...))
        end
    end
    # p1 = part1(nodes)
    return [part1(nodes), part2(nodes)]
end

function part1(nodes::Array{Node,1})
    s = 0
    for (i, a) in enumerate(nodes)
        for (j, b) in enumerate(nodes)
            i == j && continue
            if a.used != 0 && a.used <= b.available
                s += 1
            end
        end
    end
    return s
end

function part2(nodes::Array{Node,1})
    grid = generate_grid(nodes)
    return steps_to_initial_position(grid) + (size(grid)[2] - 2) * 5 + 1
end

function generate_grid(nodes::Array{Node,1})
    xmax = maximum(n.x for n in nodes) + 1
    ymax = maximum(n.y for n in nodes) + 1
    grid = fill('.', ymax, xmax)
    for node in nodes
        # Note: these assumptions were made by looking at
        # my concrete input
        if node.size >= 100
            grid[node.y+1, node.x+1] = '#'
        end
        if node.used == 0
            grid[node.y+1, node.x+1] = '_'
        end
    end
    return grid
end

function steps_to_initial_position(grid::Matrix{Char})
    # Initial position looks like this:
    #
    # ........-.
    # ..........
    #
    m = similar(grid, Int)
    fill!(m, -1)
    start = findfirst(x -> (x == '_'), grid)
    m[start] = 0
    goal = CartesianIndex((1, size(m)[2] - 1))
    c = 0
    while m[goal] < 0
        candids = findall(x -> (x == c), m)
        for candi in candids
            for dir in (CartesianIndex(1, 0), CartesianIndex(-1, 0), CartesianIndex(0, 1), CartesianIndex(0, -1))
                z = candi + dir
                if _valid(m, z) && grid[z] != '#' && m[z] == -1
                    m[z] = c + 1
                end
            end
        end
        c += 1
    end
    return m[goal]
end

function _valid(m, c)
    return c[1] >= 1 && c[2] >= 1 && c[1] <= size(m)[1] && c[2] <= size(m)[2]
end

end # module