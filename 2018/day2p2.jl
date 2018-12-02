problem = open("2018/day2.txt")

ids = split(read(problem, String), "\n")

for i in 1:length(ids)
    for j in (i + 1):length(ids)
        first = ids[i]
        second = ids[j]

        diffs = 0
        for (a, b) in zip(first, second)
            if a != b
                diffs += 1
            end
        end

        if diffs == 1
            print("Solution: ")
            for (a, b) in zip(first, second)
                if a == b
                    print(a)
                end
            end
            println()
        end
    end
end