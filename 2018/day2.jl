problem = open("2018/day2.txt")

ids = split(read(problem, String), "\n")

contains_two = 0
contains_three = 0

for id in ids
    occurrences = fill(0, 26)
    for char in id
        occurrences[Int(char) - 97 + 1] += 1
    end

    counted_two = false
    counted_three = false

    for v in occurrences
        if v == 2 && !counted_two
            global contains_two
            counted_two = true
            contains_two += 1
        end
        if v == 3 && !counted_three
            global contains_three
            counted_three = true
            contains_three += 1
        end
    end
end

println("Checksum: ", contains_three * contains_two)
