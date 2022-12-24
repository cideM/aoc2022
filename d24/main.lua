local r, l, u, d = { 1, 0 }, { -1, 0 }, { 0, -1 }, { 0, 1 }
local dirs = {
	[">"] = r,
	["<"] = l,
	["^"] = u,
	["v"] = d,
}

local function mapkey(pos)
	local x, y = pos[1], pos[2]
	return y + 10000 * x
end

local grid, blizzards = {}, {}

do
	for line in io.lines() do
		local row = {}
		for c in string.gmatch(line, ".") do
			if dirs[c] then
				local pos = { #row + 1, #grid + 1 }
				if not blizzards[mapkey(pos)] then
					blizzards[mapkey(pos)] = {}
				end
				table.insert(blizzards[mapkey(pos)], { dirs[c], pos })
				table.insert(row, ".")
			else
				table.insert(row, c)
			end
		end
		table.insert(grid, row)
	end
end

local start, goal = { 2, 1 }, { #grid[#grid] - 1, #grid }
local reachable, times, min = { [0] = { [mapkey(start)] = start } }, {}, 0

while #times < 3 do
	min = min + 1
	local new_blizzards = {}
	for _, group in pairs(blizzards) do
		for _, b in ipairs(group) do
			local dxdy, pos = table.unpack(b)
			local x, y = pos[1], pos[2]
			local next
			if x == 2 and dxdy == l then
				next = { #grid[#grid] - 1, y }
			elseif x == #grid[#grid] - 1 and dxdy == r then
				next = { 2, y }
			elseif y == #grid - 1 and dxdy == d then
				next = { x, 2 }
			elseif y == 2 and dxdy == u then
				next = { x, #grid - 1 }
			else
				next = { x + dxdy[1], y + dxdy[2] }
			end
			if not new_blizzards[mapkey(next)] then
				new_blizzards[mapkey(next)] = { { dxdy, next } }
			else
				table.insert(new_blizzards[mapkey(next)], { dxdy, next })
			end
		end
	end
	blizzards = new_blizzards

	reachable[min] = {}
	for _, last_pos in pairs(reachable[min - 1]) do
		local x, y = last_pos[1], last_pos[2]
		for _, dxdy in ipairs({ { 0, -1 }, { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, 0 } }) do
			local x2, y2 = x + dxdy[1], y + dxdy[2]
			local cell = (grid[y2] or {})[x2]
			local pos = { x2, y2 }
			local k = mapkey(pos)

			if x2 == goal[1] and y2 == goal[2] then
				table.insert(times, min)
				print(min)
				reachable[min] = { [mapkey(goal)] = goal }
				goal, start = start, goal
				goto continue
			end

			if cell and cell == "." and not new_blizzards[k] then
				reachable[min][k] = pos
			end
		end
	end

	::continue::
end
