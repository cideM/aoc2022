local shapes = {
	-- ####
	function(x, y)
		return { { x, y }, { x + 1, y }, { x + 2, y }, { x + 3, y } }
	end,
	-- .#.
	-- ###
	-- .#.
	function(x, y)
		return { { x + 1, y }, { x + 1, y + 1 }, { x + 1, y + 2 }, { x, y + 1 }, { x + 2, y + 1 } }
	end,
	-- ..#
	-- ..#
	-- ###
	function(x, y)
		return { { x, y }, { x + 1, y }, { x + 2, y }, { x + 2, y + 1 }, { x + 2, y + 2 } }
	end,
	-- #
	-- #
	-- #
	-- #
	function(x, y)
		return { { x, y }, { x, y + 1 }, { x, y + 2 }, { x, y + 3 } }
	end,
	-- ##
	-- ##
	function(x, y)
		return { { x, y }, { x, y + 1 }, { x + 1, y }, { x + 1, y + 1 } }
	end,
}

local function intersect(a, b)
	local m = {}
	for _, p in ipairs(a) do
		m[table.concat(p, "-")] = true
	end
	for _, p in ipairs(b) do
		if m[table.concat(p, "-")] then
			return true
		end
	end
	return false
end

local gusts = {}
for c in string.gmatch(io.read("l"), ".") do
	table.insert(gusts, c)
end

local rocks = { { 4, 5, 1 } }

local function dist(p1, p2)
	local x1, y1 = table.unpack(p1)
	local x2, y2 = table.unpack(p2)
	return math.abs(x1 - x2) + math.abs(y1 - y2)
end

local height_after_fast_forward, rocks_after_fast_forward = 0, 0
local stop = 1000000000000

local cache = {}
local function simulate(gust_i)
	local gust = gusts[gust_i]

	local x, y, i = table.unpack(rocks[#rocks])
	local x2 = gust == ">" and x + 1 or x - 1

	-- generate new points after moving horizontally
	local new_points = shapes[i](x2, y)

	-- check if new points fall out of bounds, then don't move
	for _, p in ipairs(new_points) do
		local xb, _ = table.unpack(p)
		if xb == 1 or xb == 9 then
			x2 = x
			break
		end
	end

	if x2 ~= x then
		-- check for collision with any other rock
		for j = 1, #rocks - 1 do
			local rock = rocks[j]
			local xb, yb, ib = table.unpack(rock)
			-- don't move if it intersects with any rock
			if dist({ x2, y }, rock) < 8 and intersect(new_points, shapes[ib](xb, yb)) then
				x2 = x
				break
			end
		end
	end

	local y2 = y - 1
	-- generate new points after moving horizontally and vertically
	new_points = shapes[i](x2, y2)

	-- check if new points fall out of bounds, then don't move
	for _, p in ipairs(new_points) do
		local _, yb = table.unpack(p)
		if yb == 1 then
			y2 = y
			break
		end
	end

	if y2 ~= y then
		-- check for collision with any other rock
		for j = 1, #rocks - 1 do
			local rock = rocks[j]
			local xb, yb, ib = table.unpack(rock)
			-- don't move if it intersects with any rock
			if dist({ x2, y2 }, rock) < 8 and intersect(new_points, shapes[ib](xb, yb)) then
				y2 = y
				break
			end
		end
	end

	local next_gust_i = ((gust_i + 1) + #gusts) % #gusts -- wrap around index
	next_gust_i = next_gust_i == 0 and #gusts or next_gust_i

  -- move the current rock
	rocks[#rocks] = { x2, y2, i }

	-- rock is stuck, add a new one
	if y2 == y then
		local max = 0
		for _, rock in ipairs(rocks) do
			local xb, yb, ib = table.unpack(rock)
			local ps = shapes[ib](xb, yb)
			for _, p in ipairs(ps) do
				max = math.max(max, p[2])
			end
		end

		local key = gust_i .. "-" .. i
		if cache[key] and #rocks > 2022 then
			local previous_rocks, previous_height = table.unpack(cache[key])
			local rocks_diff = #rocks - previous_rocks
			local safe_cycles = math.floor((stop - #rocks) / rocks_diff)
			rocks_after_fast_forward = #rocks + safe_cycles * rocks_diff
			height_after_fast_forward = max + safe_cycles * (max - previous_height)
		else
			cache[key] = { #rocks, max }
		end

		local next_i = ((i + 1) + #shapes) % #shapes -- wrap around index
		next_i = next_i == 0 and #shapes or next_i
		table.insert(rocks, { 4, max + 4, next_i })

		if rocks_after_fast_forward > 0 then
			rocks_after_fast_forward = rocks_after_fast_forward + 1
		end

		if rocks_after_fast_forward > stop then
			print("p2", height_after_fast_forward - 1)
			os.exit()
		end

		if #rocks == 2023 then
			print("p1", max - 1)
		end
	end

	return simulate(next_gust_i)
end

simulate(1)
