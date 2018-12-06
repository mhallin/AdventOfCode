problem = map(v -> v[1], split(read(open("2018/day5.txt"), String), ""))


function reduce(problem)
    stack = []
    for c in problem
        if length(stack) > 0 && uppercase(last(stack)) == uppercase(c) && last(stack) != c
            pop!(stack)
        else
            push!(stack, c)
        end
    end
    return stack
end

println("Solution: ", length(reduce(problem)))

min_length = length(problem)
for ignore in 'a':'z'
    global min_length
    l = length(reduce(filter(c -> lowercase(c) != ignore, problem)))
    min_length = min(l, min_length)
end

println("Solution, part 2: ", min_length)
