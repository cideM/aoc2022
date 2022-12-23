local grid, instructions = {}, {}

for line in io.lines() do
	if string.find(line, "[%.#]") then
		local row = {}
		for c in string.gmatch(line, ".") do
			table.insert(row, c)
		end
		table.insert(grid, row)
	end

	if string.find(line, "%d") then
		local i = 1
		while i < #line do
			local letter = string.match(line, "^[RL]", i)
			if letter then
				table.insert(instructions, letter)
				i = i + 1
			else
				local num = string.match(line, "^%d+", i)
				table.insert(instructions, tonumber(num))
				i = i + #num
			end
		end
	end
end

local function get_region(position)
	local x, y = table.unpack(position)
	if x > 50 and x <= 100 and y >= 1 and y <= 50 then
		return 1
	end
	if x > 100 and x <= 150 and y >= 1 and y <= 50 then
		return 2
	end
	if x > 50 and x <= 100 and y > 50 and y <= 100 then
		return 3
	end
	if x > 50 and x <= 100 and y > 100 and y <= 150 then
		return 4
	end
	if x >= 1 and x <= 50 and y > 100 and y <= 150 then
		return 5
	end
	if x >= 1 and x <= 50 and y > 150 and y <= 200 then
		return 6
	end
end

local function next_p2(position, facing)
	local x, y = table.unpack(position)
	local dx, dy = table.unpack(facing)
	local x2, y2 = x + dx, y + dy
	local cell = (grid[y2] or {})[x2]
	if cell == "." or cell == "#" then
		return { x2, y2 }, facing
	end

	if not cell or cell == " " then -- wrap
		local region = get_region(position)
		if region == 1 then
			if dx == -1 then
				return { 1, 151 - y2 }, { 1, 0 }
			elseif dy == -1 then
				return { 1, x2 + 100 }, { 1, 0 }
			end
		elseif region == 2 then
			if dy == -1 then
				return { x2 - 100, 200 }, { 0, -1 }
			elseif dx == 1 then
				return { 100, 151 - y2 }, { -1, 0 }
			elseif dy == 1 then
				return { 100, x2 - 50 }, { -1, 0 }
			end
		elseif region == 3 then
			if dx == 1 then
				return { y2 + 50, 50 }, { 0, -1 }
			elseif dx == -1 then
				return { y2 - 50, 101 }, { 0, 1 }
			end
		elseif region == 4 then
			if dx == 1 then
				return { 150, 151 - y2 }, { -1, 0 }
			elseif dy == 1 then
				return { 50, x2 + 100 }, { -1, 0 }
			end
		elseif region == 5 then
			if dy == -1 then
				return { 51, x2 + 50 }, { 1, 0 }
			elseif dx == -1 then
				return { 51, 151 - y2 }, { 1, 0 }
			end
		elseif region == 6 then
			if dx == -1 then
				return { y2 - 100, 1 }, { 0, 1 }
			elseif dy == 1 then
				return { x2 + 100, 1 }, { 0, 1 }
			elseif dx == 1 then
				return { y2 - 100, 150 }, { 0, -1 }
			end
		end
	end

	return { x2, y2 }, facing
end

local start = { 0, 0 }
for y = 1, #grid do
	for x = 1, #grid[y] do
		local v = grid[y][x]
		if v == "." then
			start = { x, y }
			goto continue
		end
	end
end
::continue::

function next(position, facing)
	local x, y = table.unpack(position)
	local dx, dy = table.unpack(facing)
	local x2, y2 = x + dx, y + dy
	local cell = (grid[y2] or {})[x2]
	if cell == "." or cell == "#" then
		return { x2, y2 }, facing
	end

	if not cell or cell == " " then
		if dx == 1 then
			x2 = 1
		elseif dx == -1 then
			x2 = #grid[y]
		elseif dy == 1 then
			y2 = 1
		elseif dy == -1 then
			y2 = #grid
		end
		cell = grid[y2][x2]

		while not cell or cell == " " do
			x2, y2 = x2 + dx, y2 + dy
			cell = grid[y2][x2]
		end
	end

	return { x2, y2 }, facing
end

local function rotate(p, dir)
	return dir == "R" and { -p[2], p[1] } or { p[2], -p[1] }
end

local function solve(nextfn)
	local direction, position = { 1, 0 }, start
	for _, ins in ipairs(instructions) do
		if ins == "R" then
			direction = rotate(direction, "R")
		elseif ins == "L" then
			direction = rotate(direction, "L")
		else
			local steps = ins
			while steps > 0 do
				local new_pos, new_facing = nextfn(position, direction)
				local x2, y2 = table.unpack(new_pos)
				if grid[y2][x2] == "#" then
					break
				else
					direction = new_facing
					position = { x2, y2 }
				end
				steps = steps - 1
			end
		end
	end
	return position, direction
end

local function score(pos, dir)
	local sum = 0
	local dx, dy = table.unpack(dir)
	if dx == 1 and dy == 0 then
		sum = sum
	elseif dx == 0 and dy == 1 then
		sum = sum + 1
	elseif dx == -1 and dy == 0 then
		sum = sum + 2
	elseif dx == 0 and dy == -1 then
		sum = sum + 3
	end
	local x, y = table.unpack(pos)
	return sum + y * 1000 + x * 4
end

print(score(solve(next)))
print(score(solve(next_p2)))
