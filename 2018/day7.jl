line_re = r"^Step ([A-Z]+) must be finished before step ([A-Z]+) can begin.$"

dep_list = map(
    l -> begin
        m = match(line_re, l)
        (m[1], m[2])
    end,
    split(read(open("2018/day7.txt"), String), "\n"))

all_known = Set()
parents = Dict()
children = Dict()

for (parent, child) in dep_list
    global all_known, children, parents

    union!(all_known, [parent, child])

    ps = get(parents, child, [])
    push!(ps, parent)
    parents[child] = ps

    cs = get(children, parent, [])
    push!(cs, child)
    children[parent] = cs
end

visited = Set()
task_order = []


while visited != all_known
    remaining = sort(collect(symdiff(all_known, visited)))

    for next in remaining
        ps = get(parents, next, Set())
        if intersect(ps, visited) != ps
            continue
        end

        if in(next, visited)
            continue
        end

        push!(task_order, next)
        union!(visited, [next])
        break
    end
end

println("Solution, part 1: ", join(task_order, ""))

w_count = 5
cooldowns = fill(0, w_count)
works = Array{Union{Nothing,String}}(nothing, w_count)
iterations = 0
base_time = 60

done = Set()

while !isempty(task_order) || any(c -> c > 0, cooldowns)
    global iterations

    for w in 1:w_count
        if cooldowns[w] == 0
            if works[w] != nothing
                union!(done, [works[w]])
            end
        end
    end

    for w in 1:w_count
        if cooldowns[w] == 0
            for (i, next) in enumerate(task_order)
                ps = get(parents, next, [])
                if intersect(ps, done) == ps
                    deleteat!(task_order, i)
                    cooldowns[w] = Int(next[1]) - 65 + base_time + 1
                    println("[", iterations, "] W", w, " staring task ", next, ", cooldown ", cooldowns[w])
                    works[w] = next
                    break
                end
            end
        end

        if cooldowns[w] > 0
            cooldowns[w] -= 1
        end
    end

    iterations += 1
end

println("Solution, part 2: ", iterations)