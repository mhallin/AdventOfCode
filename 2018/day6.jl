coords = map(
    l -> begin
        x, y = split(l, ",")
        parse(Int, x), parse(Int, y)
    end,
    split(read(open("2018/day6.txt"), String), "\n"))

xmin = nothing
xmax = nothing
ymin = nothing
ymax = nothing

for (x, y) in coords
    global xmin, xmax, ymin, ymax
    if xmin == nothing || x < xmin
        xmin = x
    end
    if xmax == nothing || x > xmax
        xmax = x
    end
    if ymin == nothing || y < ymin
        ymin = y
    end
    if ymax == nothing || y > ymax
        ymax = y
    end
end

function dist(a, b)
    abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function closest(find_pos)
    global coords

    min_dist = nothing
    min_idx = nothing

    for (i, pos) in enumerate(coords)
        d = dist(pos, find_pos)
        if min_dist == nothing || d < min_dist
            min_idx = i
            min_dist = d
        elseif d == min_dist
            min_idx = nothing
        end
    end

    return min_idx
end

dist_counts = Dict{Int,Int}()

for x in xmin:xmax
    for y in ymin:ymax
        global coords, dist_counts
        
        idx = closest((x, y))
        if idx == nothing
            continue
        end

        pos = coords[idx]
        if pos[1] == xmin || pos[1] == xmax || pos[2] == ymin || pos[2] == ymax
            continue
        end
        
        count = get(dist_counts, idx, 0)
        dist_counts[idx] = count + 1
    end
end

max_area = maximum(values(dist_counts))

println("Solution, part 1: ", max_area)


region_size = 0
region_dist = 10000

for x in xmin:xmax
    for y in ymin:ymax
        global coords, region_size, region_dist

        dist_sum = 0
        for p in coords
            dist_sum += dist(p, (x, y))
        end

        if dist_sum < region_dist
            region_size += 1
        end
    end
end

println("Solution, part 2: ", region_size)
