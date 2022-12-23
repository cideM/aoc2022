local function empty_ground_tiles(elves)
	local minx, miny, maxx, maxy = math.maxinteger, math.maxinteger, math.mininteger, math.mininteger

	local num_elves = 0
	for _, pos in pairs(elves) do
		local x, y = table.unpack(pos)
		minx, miny, maxx, maxy = math.min(minx, x), math.min(miny, y), math.max(maxx, x), math.max(maxy, y)
		num_elves = num_elves + 1
	end

	return (maxy - (miny - 1)) * (maxx - (minx - 1)) - num_elves
end

local function poskey(pos)
	return pos[2] + 10000 * pos[1] -- max is a best guess, but reduces time from ~9s to ~4s
end

local elves = {}
do
	local rows = 1
	for line in io.lines() do
		local col = 1
		for c in string.gmatch(line, ".") do
			if c == "#" then
				local pos = { col, rows }
				elves[poskey(pos)] = pos
			end
			col = col + 1
		end
		rows = rows + 1
	end
end

local directions = {
	{ check = { { 0, -1 }, { 1, -1 }, { -1, -1 } }, move = { 0, -1 } },
	{ check = { { 0, 1 }, { 1, 1 }, { -1, 1 } }, move = { 0, 1 } },
	{ check = { { -1, 0 }, { -1, -1 }, { -1, 1 } }, move = { -1, 0 } },
	{ check = { { 1, 0 }, { 1, 1 }, { 1, -1 } }, move = { 1, 0 } },
}

local rounds, none_moved = 1, false
while not none_moved do
	local proposals = {}
	none_moved = true

	for key, pos in pairs(elves) do
		local x, y = table.unpack(pos)

		local has_adjacent = false
		for _, dx in ipairs({ -1, 0, 1 }) do
			for _, dy in ipairs({ -1, 0, 1 }) do
				if (dx ~= 0 or dy ~= 0) and elves[poskey({ x + dx, y + dy })] then
					has_adjacent = true
					goto continue
				end
			end
		end
		::continue::

		if has_adjacent then
			for _, dir in ipairs(directions) do
				local can_move = true
				for _, dxdy in ipairs(dir.check) do
					if elves[poskey({ x + dxdy[1], y + dxdy[2] })] then
						can_move = false
						break
					end
				end

				if can_move then
					local new_pos = { x + dir.move[1], y + dir.move[2] }
					local k = poskey(new_pos)
					if not proposals[k] then
						proposals[k] = {}
					end
					table.insert(proposals[k], { key, new_pos })
					goto next_elf
				end
			end
		end

		::next_elf::
	end

	for new_elf_pos_key, v in pairs(proposals) do
		if #v == 1 then
			none_moved, elves[v[1][1]], elves[new_elf_pos_key] = false, nil, v[1][2]
		end
	end

	table.insert(directions, table.remove(directions, 1))
	if rounds == 10 then
		print(empty_ground_tiles(elves))
	end
	rounds = rounds + 1
end
print(rounds - 1)
