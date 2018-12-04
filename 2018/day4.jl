using Dates

problem = open("2018/day4.txt")
line_re = r"^\[(.*)\] (Guard #([0-9]+) begins shift|falls asleep|wakes up)$"

struct GuardDuty
    id::Int
end

struct Awake
end

struct Asleep
end

EntryData = Union{GuardDuty, Awake, Asleep}

struct GuardEntry
    ts::DateTime
    data::EntryData
end

df = DateFormat("Y-m-d H:M")

entries = sort(
    map(
        line -> begin
            m = match(line_re, line)
            dt = DateTime(m[1], df)
            if m[2] == "wakes up"
                ed = Awake() :: EntryData
            elseif m[2] == "falls asleep"
                ed = Asleep() :: EntryData
            else
                ed = GuardDuty(parse(Int, m[3])) :: EntryData
            end
            GuardEntry(dt, ed)
        end,
        split(read(problem, String), "\n")),
    by=e->e.ts)

active_id = nothing
start_ts = nothing
minutes_by_guard = Dict()
for entry in entries
    if typeof(entry.data) == GuardDuty
        global active_id
        active_id = entry.data.id
    elseif typeof(entry.data) == Asleep
        global start_ts
        start_ts = entry.ts
    elseif typeof(entry.data) == Awake
        sleep = get(minutes_by_guard, active_id, fill(0, 60))
        for m in minute(start_ts):(minute(entry.ts) - 1)
            sleep[m + 1] += 1
        end
        minutes_by_guard[active_id] = sleep
    end
end

max_slept = 0
max_minute = nothing
max_gid = nothing
for (gid, minutes) in minutes_by_guard
    global max_slept, max_minute, max_gid
    slept = sum(minutes)
    if slept > max_slept
        max_slept = slept
        max_gid = gid
        _, max_minute = findmax(minutes)
        max_minute -= 1
    end
end

println("Solution (part 1): ", (max_gid * max_minute))

max_count = 0
max_minute = nothing
max_gid = nothing
for (gid, minutes) in minutes_by_guard
    global max_count, max_minute, max_gid
    count, minute = findmax(minutes)
    minute -= 1
    if count > max_count
        max_minute = minute
        max_count = count
        max_gid = gid
    end
end

println("Solution (part 2): ", (max_gid * max_minute))