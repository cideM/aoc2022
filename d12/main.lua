local Grid = {}

function Grid:new()
	local o = {}
	self.__index = self
	setmetatable(o, self)
	return o
end

function Grid:make_key(row, col)
	return string.format("%d-%d", row, col)
end

function Grid:adjacent_by_key(k)
	local row, col = string.match(k, "(%d+)-(%d+)")
	row, col = tonumber(row), tonumber(col)
	local candidates = {
		{ row - 1, col },
		{ row, col - 1 },
		{ row, col + 1 },
		{ row + 1, col },
	}

	local found = {}
	for _, c in ipairs(candidates) do
		local v = (self[c[1]] or {})[c[2]]
		if v then
			local entry = { key = self:make_key(c[1], c[2]), value = v }
			table.insert(found, entry)
		end
	end
	return found
end

function Grid:get_by_key(k)
	local row, col = string.match(k, "(%d+)-(%d+)")
	row, col = tonumber(row), tonumber(col)
	return (self[row] or {})[col]
end

local elevation_map = Grid:new()

local start, goal = "", ""
for line in io.lines() do
	local row = {}
	for c in string.gmatch(line, "%w") do
		if c == "S" then
			start = elevation_map:make_key(#elevation_map + 1, #row + 1)
			table.insert(row, string.byte("a") - 97)
		elseif c == "E" then
			goal = elevation_map:make_key(#elevation_map + 1, #row + 1)
			table.insert(row, string.byte("z") - 97)
		else
			table.insert(row, string.byte(c) - 97)
		end
	end
	table.insert(elevation_map, row)
end

local Heap = {}

function Heap:new()
	local o = {}
	self.__index = self
	setmetatable(o, self)
	return o
end

function Heap:bubbleup(pos)
	while pos > 1 do
		local parent = math.floor(pos / 2)
		if not (self[pos].f_score < self[parent].f_score) then
			break
		end
		self[parent], self[pos] = self[pos], self[parent]
		pos = parent
	end
end

function Heap:sink(pos)
	local last = #self
	while true do
		local min = pos
		local child = pos * 2
		for c = child, child + 1 do
			if c <= last and self[c].f_score < self[min].f_score then
				min = c
			end
		end

		if min == pos then
			break
		end
		self[pos], self[min] = self[min], self[pos]
		pos = min
	end
end

function Heap:has(value)
	for _, v in ipairs(self) do
		if v == value then
			return true
		end
	end
	return false
end

function Heap:insert(value)
	local pos = #self + 1
	self[pos] = value
	self:bubbleup(pos)
end

function Heap:remove(pos)
	local last = #self
	if pos == last then
		local v = self[last]
		self[last] = nil
		return v
	end

	local v = self[pos]
	self[pos], self[last] = self[last], self[pos]
	self[last] = nil
	self:bubbleup(pos)
	self:sink(pos)
	return v
end

local function a_star(start_key, goal_key, h, grid)
	local came_from = {}
	local g_score = {}
	local g_score_mt = {
		__index = function()
			return math.maxinteger
		end,
	}
	setmetatable(g_score, g_score_mt)
	g_score[start_key] = 0

	local f_score = {}
	local f_score_mt = {
		__index = function()
			return math.maxinteger
		end,
	}
	setmetatable(f_score, f_score_mt)
	f_score[start_key] = h(grid, start_key)

	local open_set = Heap:new()
	open_set:insert({ key = start_key, f_score = f_score[start_key] })

	while #open_set > 0 do
		local current = open_set:remove(1)
		local current_key = current.key
		if current_key == goal_key then
			local total_path = { current_key }
			while came_from[current_key] do
				current_key = came_from[current_key]
				table.insert(total_path, 1, current_key)
			end
			return total_path
		end

		local current_height = grid:get_by_key(current_key)
		for _, n in ipairs(grid:adjacent_by_key(current_key)) do
			if n.value > current_height + 1 then
				goto continue
			end
			local tentative_g_score = g_score[current_key] + 1
			if tentative_g_score < g_score[n.key] then
				came_from[n.key] = current_key
				g_score[n.key] = tentative_g_score
				f_score[n.key] = tentative_g_score + h(grid, n.key)
				if not open_set:has(n.key) then
					open_set:insert({ key = n.key, f_score = f_score[n.key] })
				end
			end
			::continue::
		end
	end
end

local heuristic = function()
	return 1
end

local path = a_star(start, goal, heuristic, elevation_map)
print(#path - 1)

local min = math.maxinteger
for row in ipairs(elevation_map) do
	for col, height in ipairs(elevation_map[row]) do
		if height == 0 then
			local new_start = elevation_map:make_key(row, col)
			local cur_path = a_star(new_start, goal, heuristic, elevation_map)
			if cur_path then
				min = math.min(#cur_path - 1, min)
			end
		end
	end
end
print(min)
