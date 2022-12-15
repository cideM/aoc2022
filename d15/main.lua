local ranges, sensors, beacons = {}, {}, {}

local function key(x, y)
	return string.format("%d-%d", x, y)
end

for line in io.lines() do
	-- print(line)
	local x, y, x2, y2 =
		string.match(line, "Sensor at x=(%-?%d+), y=(%-?%d+): closest beacon is at x=(%-?%d+), y=(%-?%d+)")
	x, y, x2, y2 = tonumber(x), tonumber(y), tonumber(x2), tonumber(y2)

	sensors[key(x, y)] = true
	beacons[key(x2, y2)] = true
	local dist = math.abs(x - x2) + math.abs(y - y2)
	local new_ranges = {
		[y] = { from = x - dist, to = x + dist },
	}
	-- print(dist)

	for i = 1, dist do
		local dx = dist - i
		-- print(y - i, x - dx, x + dx)
		new_ranges[y - i] = { from = x - dx, to = x + dx }
		new_ranges[y + i] = { from = x - dx, to = x + dx }
	end
	for row, new_range in pairs(new_ranges) do
		if not ranges[row] then
			ranges[row] = {}
		end
		table.insert(ranges[row], new_range)
	end
end

local seen = {}
for _, range in ipairs(ranges[10]) do
	for i = range.from, range.to do
		if not sensors[key(i, 10)] and not beacons[key(i, 10)] then
			seen[i] = (seen[i] or 0) + 1
		end
	end
end

local sum = 0
for _ in pairs(seen) do
	sum = sum + 1
end
print(sum)

local function ranges_difference(a, b)
	local new_ranges = table.move(b, 1, #b, 1, {})
	for _, range in ipairs(a) do
		local temp = {}
		for _, new_range in ipairs(new_ranges) do
			-- new range contained in range, remove it
			if new_range.from >= range.from and new_range.to <= range.to then
				goto next_new_range
			end

			-- range contained in new_range, split new_range
			if range.from >= new_range.from and range.to <= new_range.to then
				table.insert(temp, { from = new_range.from, to = range.from - 1 })
				table.insert(temp, { from = range.to + 1, to = new_range.to })
				goto next_new_range
			end

			-- overlap one side
			if range.to >= new_range.from and range.to < new_range.to then
				table.insert(temp, { from = range.to + 1, to = new_range.to })
				goto next_new_range
			end

			-- overlap other side
			if range.from <= new_range.to and range.from > new_range.from then
				table.insert(temp, { from = new_range.from, to = range.from - 1 })
				goto next_new_range
			end

			table.insert(temp, new_range)
			::next_new_range::
		end
		new_ranges = table.move(temp, 1, #temp, 1, {})
	end
	return new_ranges
end

local max = 20
local mult = 4000000
for row = 0, max do
	if ranges[row] then
		local new_ranges = ranges_difference(ranges[row], { { from = 0, to = max } })
		if #new_ranges == 1 then
			local x, y = new_ranges[1].from, new_ranges[1].to
			if x == y then
				print(x * mult + row)
				os.exit(0)
			end
		end
	end
end
