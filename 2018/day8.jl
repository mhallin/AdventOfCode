data = map(v -> parse(Int, v), split(read(open("2018/day8.txt"), String), " "))

struct Node
    children::Array{Node}
    metadata::Array{Int}
end

function readtree(data)
    child_count = popfirst!(data)
    metadata_count = popfirst!(data)

    children = []
    metadata = []

    for _ in 1:child_count
        push!(children, readtree(data))
    end

    for _ in 1:metadata_count
        push!(metadata, popfirst!(data))
    end

    return Node(children, metadata)
end

function sum_metadata(node)
    s = 0
    if !isempty(node.children)
        s += sum(c -> sum_metadata(c), node.children)
    end

    if !isempty(node.metadata)
        s += sum(node.metadata)
    end
    return s
end

function value(node)
    if isempty(node.children)
        if isempty(node.metadata)
            return 0
        end

        return sum(node.metadata)
    end

    s = 0
    for idx in node.metadata
        if idx < 1 || idx > length(node.children)
            continue
        end

        s += value(node.children[idx])
    end

    return s
end

tree = readtree(data)

println("Solution, part 1: ", sum_metadata(tree))
println("Solution, part 2: ", value(tree))
