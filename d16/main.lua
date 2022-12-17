-- Reworked my solution to be faster based on https://adventofcode.com/2022/day/16
-- from https://old.reddit.com/r/adventofcode/comments/zn6k1l/2022_day_16_solutions/j0fjofh/

local graph = {}
-- count how many nodes we have where rate is > 0 and use that for the bit
-- masks so we get 1 << 0 to 1 << 15 rather than to 1 << 63
local non_zero_nth = 0
local count = 0 -- count how many lines
for line in io.lines() do
	local valve_iter = string.gmatch(line, "%u%u")
	local valve = valve_iter()
	graph[valve] = {
		rate = tonumber(string.match(line, "(%d+)")),
		neighbours = {},
		mask = 1 << non_zero_nth,
		nth = count, -- we'll use this for the cache key
	}
	for neighbour in valve_iter do
		table.insert(graph[valve].neighbours, neighbour)
	end
	if graph[valve].rate > 0 then
		non_zero_nth = non_zero_nth + 1
	end
	count = count + 1
end

local cache = {}
local function solve(valves, pos, t, others)
	if t == 0 then
		-- Instead of trying to manage multiple players at the same time, just keep
		-- playing without resetting the valves. The second player can't open any
		-- valve that the first player already opened.
		return others > 0 and solve(valves, "AA", 26, others - 1) or 0
	end

	local key = valves * count * 31 * 2 + graph[pos].nth * 31 * 2 + t * 2 + others
	if cache[key] then
		return cache[key]
	end
	local n, answer = graph[pos], 0
	if n.rate > 0 and not ((valves & n.mask) ~= 0) then -- valve has flow and isn't open
		answer = math.max(answer, (t - 1) * n.rate + solve(valves ~ n.mask, pos, t - 1, others))
	end
	for _, neighbour in ipairs(n.neighbours) do
		answer = math.max(answer, solve(valves, neighbour, t - 1, others))
	end
	cache[key] = answer
	return answer
end

local p1 = solve(0, "AA", 30, 0)
print(p1)
local p2 = solve(0, "AA", 26, 1)
print(p2)
