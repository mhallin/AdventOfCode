mutable struct Point
    x::Int
    y::Int
    dx::Int
    dy::Int
end

line_re = r"^position=< *([-0-9]+), *([-0-9]+)> velocity=< *([-0-9]+), *([-0-9]+)>$"
points = map(
    l -> begin
        m = match(line_re, l)
        Point(parse(Int, m[1]), parse(Int, m[2]), parse(Int, m[3]), parse(Int, m[4]))
    end,
    split(read("2018/day10.txt", String), "\n"))

function bbox(points::Array{Point})
    xmin = nothing
    xmax = nothing
    ymin = nothing
    ymax = nothing

    for point in points
        if xmin == nothing || point.x < xmin
            xmin = point.x
        end
        if xmax == nothing || point.x > xmax
            xmax = point.x
        end
        if ymin == nothing || point.y < ymin
            ymin = point.y
        end
        if ymax == nothing || point.y > ymax
            ymax = point.y
        end
    end

    return (xmin, xmax, ymin, ymax)
end

function bbox_area(points::Array{Point})
    (xmin, xmax, ymin, ymax) = bbox(points)
    return (xmax - xmin) * (ymax - ymin)
end

function step(points::Array{Point})
    for point in points
        point.x += point.dx
        point.y += point.dy
    end
end

function stepback(points::Array{Point})
    for point in points
        point.x -= point.dx
        point.y -= point.dy
    end
end

function printpoints(points::Array{Point})
    (xmin, xmax, ymin, ymax) = bbox(points)
    occupied = Set{Tuple{Int,Int}}()
    for point in points 
        union!(occupied, [(point.x, point.y)])
    end

    for y in ymin:ymax
        for x in xmin:xmax
            if in((x, y), occupied)
                print("X")
            else
                print(".")
            end
        end
        println()
    end
end

area = bbox_area(points)
i = 0
while true
    global area, i
    step(points)
    new_area = bbox_area(points)
    if new_area > area
        stepback(points)
        break
    else
        area = new_area
    end
    i += 1
end

printpoints(points)

println("Solution, part 2: ", i)