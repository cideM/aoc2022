local grid = {}

local function set(point, v)
	if not grid[point.y] then
		grid[point.y] = {}
	end
	grid[point.y][point.x] = v
end

local function clamp(x, min, max)
	return math.min(math.max(x, min), max)
end

local lowest_rock = math.mininteger

for line in io.lines() do
	local path = {}
	for point in string.gmatch(line, "(%d+,%d+)") do
		local x, y = string.match(point, "(%d+),(%d+)")
		x, y = tonumber(x), tonumber(y)
		table.insert(path, { x = x, y = y })
	end

	for i = 2, #path do
		local prev, cur = path[i - 1], path[i]
		local dx, dy = cur.x - prev.x, cur.y - prev.y
		local steps = math.max(math.abs(dx), math.abs(dy))
		dx, dy = clamp(dx, -1, 1), clamp(dy, -1, 1)
		for j = 0, steps do
			local x, y = prev.x + j * dx, prev.y + j * dy
			lowest_rock = math.max(y, lowest_rock)
			set({ x = x, y = y }, "#")
		end
	end
end

local function next_sand_pos(point)
	for _, p in ipairs({
		{ x = point.x, y = point.y + 1 },
		{ x = point.x - 1, y = point.y + 1 },
		{ x = point.x + 1, y = point.y + 1 },
	}) do
		if ((grid[p.y] or {})[p.x] or ".") == "." then
			return p
		end
	end
end

local sand_start, p1, sands = { x = 500, y = 0 }, nil, 0
local pos = sand_start
while pos do
	::continue::
	local next_pos = pos.y - lowest_rock < 1 and next_sand_pos(pos)
	if not next_pos then
		sands = sands + 1
		if pos == sand_start then
			break
		else
			pos = sand_start
			goto continue
		end
	end

	set(pos, ".")
	set(next_pos, "o")
	if not p1 and next_pos.y > lowest_rock then
		p1 = sands
	end
	pos = next_pos
end
print(p1)
print(sands)
