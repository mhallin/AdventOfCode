problem = open("2018/day1.txt")

numbers = map(l -> parse(Int, l), split(read(problem, String), "\n"))

solution = sum(numbers)

println("Solution, part 1: ", solution)

seen = Set()
frequency = 0
index = 0

while true
    global frequency, index, seen

    frequency += numbers[index + 1]
    index = (index + 1) % length(numbers)

    if frequency in seen
        println("Solution, part 2: ", frequency)
        break
    end

    union!(seen, [frequency])
end
