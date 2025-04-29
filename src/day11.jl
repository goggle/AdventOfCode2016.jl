module Day11

using AdventOfCode2016
using DataStructures
using Combinatorics

abstract type Item end

struct Generator <: Item
    element::Symbol
    floor::Int8
end

struct Microchip <: Item
    element::Symbol
    floor::Int8
end

struct State
    elevator::Int8
    items::Vector{Item}
end

function day11(input::String = readInput(joinpath(@__DIR__, "..", "data", "day11.txt")))
    state, indices = parse_input(input)
    [part1(state, indices), part2(state, indices)]
end

function parse_input(input::String)
    items = Item[]
    
    floor_map = Dict("first" => 1, "second" => 2, "third" => 3, "fourth" => 4)
    
    gen_regex = r"(\w+) generator"
    chip_regex = r"(\w+)-compatible microchip"
    
    lines = split(strip(input), '\n')
    
    for (floor_num, line) in enumerate(lines)
        floor_match = match(r"The (\w+) floor", line)
        if isnothing(floor_match)
            continue
        end
        floor = floor_map[floor_match.captures[1]]
        
        if occursin("nothing relevant", line)
            continue
        end
        
        for m in eachmatch(gen_regex, line)
            element = Symbol(m.captures[1])
            push!(items, Generator(element, floor))
        end
        
        for m in eachmatch(chip_regex, line)
            element = Symbol(m.captures[1])
            push!(items, Microchip(element, floor))
        end
    end
    
    # For Part 2, add elerium and dilithium to floor 1
    push!(items, Generator(:elerium, 1), Microchip(:elerium, 1))
    push!(items, Generator(:dilithium, 1), Microchip(:dilithium, 1))
    
    # Precompute indices: Dict(element => (g_idx, m_idx))
    indices = Dict(e => (findfirst(i -> i isa Generator && i.element == e, items),
                         findfirst(i -> i isa Microchip && i.element == e, items))
                  for e in unique(item.element for item in items))
    
    State(1, items), indices
end

function is_valid(state::State, indices::Dict{Symbol,Tuple{Int,Int}})
    for floor in 1:4
        for (e, (_, m_idx)) in indices
            if state.items[m_idx].floor == floor
                if state.items[indices[e][1]].floor != floor
                    for (e2, (g_idx, _)) in indices
                        if state.items[g_idx].floor == floor
                            return false
                        end
                    end
                end
            end
        end
    end
    true
end

function is_goal(state::State)
    all(item.floor == 4 for item in state.items)
end

function heuristic(state::State, indices::Dict{Symbol,Tuple{Int,Int}})
    dist = sum(4 - item.floor for item in state.items)
    elevator_penalty = abs(4 - state.elevator)
    unpaired = sum(abs(state.items[g_idx].floor - state.items[m_idx].floor) for (e, (g_idx, m_idx)) in indices)
    (dist + elevator_penalty + unpaired) ÷ 2
end

function state_key(state::State, indices::Dict{Symbol,Tuple{Int,Int}}, pairs::Vector{Tuple{Int,Int}})
    for (i, (e, (g_idx, m_idx))) in enumerate(indices)
        pairs[i] = (state.items[g_idx].floor, state.items[m_idx].floor)
    end
    (state.elevator, sort(pairs))
end

function solve(initial_state::State, indices::Dict{Symbol,Tuple{Int,Int}})
    queue = PriorityQueue{Tuple{State,Int},Int}()
    enqueue!(queue, (initial_state, 0) => heuristic(initial_state, indices))
    visited = Dict{Any,Int}()
    visited[state_key(initial_state, indices, Vector{Tuple{Int,Int}}(undef, length(indices)))] = 0
    
    new_items = copy(initial_state.items)
    pairs = Vector{Tuple{Int,Int}}(undef, length(indices))
    
    while !isempty(queue)
        (state, steps), _ = dequeue_pair!(queue)
                
        if is_goal(state)
            return steps
        end
        
        current_floor = state.elevator
        items = state.items
        current_items = [i for (i, item) in enumerate(items) if item.floor == current_floor]
        
        # Try moving 1 or 2 items, prefer up
        for count in 1:min(2, length(current_items))
            for items_to_move in combinations(current_items, count)
                for new_floor in (current_floor == 4 ? [3] : current_floor == 1 ? [2] : [current_floor + 1, current_floor - 1])
                    for idx in eachindex(new_items)
                        new_items[idx] = items[idx]
                    end
                    for idx in items_to_move
                        new_items[idx] = typeof(new_items[idx])(new_items[idx].element, new_floor)
                    end
                    new_state = State(new_floor, copy(new_items))
                    
                    if is_valid(new_state, indices)
                        new_steps = steps + 1
                        key = state_key(new_state, indices, pairs)
                        if !haskey(visited, key) || new_steps < visited[key]
                            visited[key] = new_steps
                            enqueue!(queue, (new_state, new_steps) => new_steps + heuristic(new_state, indices))
                        end
                    end
                end
            end
        end
    end
end

function part1(initial_state::State, indices::Dict{Symbol,Tuple{Int,Int}})
    part1_items = [item for item in initial_state.items if item.element in [:thulium, :plutonium, :strontium, :promethium, :ruthenium]]
    part1_indices = Dict(e => (findfirst(i -> i isa Generator && i.element == e, part1_items),
                               findfirst(i -> i isa Microchip && i.element == e, part1_items))
                         for e in [:thulium, :plutonium, :strontium, :promethium, :ruthenium])
    solve(State(1, part1_items), part1_indices)
end

part2(initial_state::State, indices::Dict{Symbol,Tuple{Int,Int}}) = solve(initial_state, indices)

end # module