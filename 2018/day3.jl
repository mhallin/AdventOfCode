problem = open("2018/day3.txt")
line_re = r"^#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)$"

struct Claim
    id::Int
    x::Int
    y::Int
    w::Int
    h::Int
end

function overlap(c1::Claim, c2::Claim)
    return (c1.x < c2.x + c2.w &&
        c1.y < c2.y + c2.h &&
        c1.x + c1.w > c2.x &&
        c1.y + c1.h > c2.y)
end

grid = Dict()
overlaps = Set()

claims = map(
    function (line)
        m = match(line_re, line)
        Claim(parse(Int, m[1]), parse(Int, m[2]), parse(Int, m[3]), parse(Int, m[4]), parse(Int, m[5]))
    end,
    split(read(problem, String), "\n"))

for i in 1:length(claims)
    claim = claims[i]
    for x in claim.x:(claim.x + claim.w - 1)
        for y in claim.y:(claim.y + claim.h - 1)
            grid[(x, y)] = get(grid, (x, y), 0) + 1
        end
    end

    for j in (i + 1):length(claims)
        claim2 = claims[j]
        if overlap(claim, claim2)
            union!(overlaps, [claim.id, claim2.id])
        end
    end
end

overlapped_squares = count(v -> v >= 2, values(grid))

println("Solution, part 1: ", overlapped_squares)

all_ids = Set(map(c -> c.id, claims))

println("Unclaimed ID: ", first(symdiff(all_ids, overlaps)))