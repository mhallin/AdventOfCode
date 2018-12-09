max_marble = 7082500
num_players = 428

mutable struct Node
    next::Union{Nothing,Node}
    prev::Union{Nothing,Node}
    value::Int64
end

function rotate(node::Node, count::Int)
    if count > 0
        for _ in 1:count
            node = node.next
        end
    else
        for _ in 1:-count
            node = node.prev
        end
    end
    return node
end

function insertafter(node::Node, value::Int)
    new_node = Node(node.next, node, value)
    node.next = new_node
    new_node.next.prev = new_node
    return new_node
end

function deletenode(node::Node)
    next = node.next
    prev = node.prev

    next.prev = prev
    prev.next = next
end

function to_array(start::Node)
    vals = [start.value]
    node = start.next
    while node.value != start.value
        push!(vals, node.value)
        node = node.next
    end
    return vals
end

current = Node(nothing, nothing, 0)
current.next = current
current.prev = current

start = current

current_player = 0

player_scores = Dict{Int64,Int64}()

for marble in 1:max_marble
    global current, current_player, player_scores

    if marble % 23 == 0
        current = rotate(current, -7)
        next = current.next
        value = current.value
        deletenode(current)
        current = next
        player_scores[current_player] = get(player_scores, current_player, 0) + value + marble
    else
        current = rotate(current, 1)
        current = insertafter(current, marble)
    end

    current_player = (current_player + 1) % num_players

    # println("[", marble, "]: ", to_array(start))
end

winning_score = maximum(v -> v[2], pairs(player_scores))
println("Solution, part 1: ", winning_score)
