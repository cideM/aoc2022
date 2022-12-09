local pairs = {}
for _ = 1, 10 do
	local t = {
		trails = { { x = 1, y = 1 } },
		x = 1,
		y = 1,
	}
	table.insert(pairs, t)
end

local function clamp(x, min, max)
	return math.min(math.max(x, min), max)
end

local vectors = { R = { 1, 0 }, L = { -1, 0 }, U = { 0, 1 }, D = { 0, -1 } }
for line in io.lines() do
	local dir, steps = string.match(line, "(%g) (%d+)")
	steps = tonumber(steps)
	for _ = 1, steps do
		-- move head
		local head = pairs[1]
		table.insert(head.trails, { x = head.x, y = head.y })
		local dx, dy = table.unpack(vectors[dir])
		head.x, head.y = head.x + dx, head.y + dy

		for i = 1, #pairs - 1 do
			local p1, p2 = pairs[i], pairs[i + 1]
			dx, dy = p1.x - p2.x, p1.y - p2.y
			-- if p1 and p2 are too far apart, move p2 closer to p1
			if math.abs(dx) > 1 or math.abs(dy) > 1 then
				p2.x, p2.y = p2.x + clamp(dx, -1, 1), p2.y + clamp(dy, -1, 1)
				table.insert(p2.trails, { x = p2.x, y = p2.y })
			end
		end
	end
end

for _, tail in ipairs({ pairs[2], pairs[10] }) do
	local seen, visited = {}, 0
	for _, p in ipairs(tail.trails) do
		local key = string.format("%d-%d", p.x, p.y)
		if not seen[key] then
			seen[key] = true
			visited = visited + 1
		end
	end
	print(visited)
end
