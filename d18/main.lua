local function key(cube)
	local x, y, z = table.unpack(cube)
	return x + 100 * (y + 100 * z)
end

local function adjacent(cube)
	local x, y, z = table.unpack(cube)
	return {
		{ x - 1, y, z },
		{ x + 1, y, z },
		{ x, y - 1, z },
		{ x, y + 1, z },
		{ x, y, z - 1 },
		{ x, y, z + 1 },
	}
end

local exterior_surface = 0
local cubes = {}
local minx, miny, minz = math.maxinteger, math.maxinteger, math.maxinteger
local maxx, maxy, maxz = math.mininteger, math.mininteger, math.mininteger
for line in io.lines() do
	local x, y, z = string.match(line, "(%d+),(%d+),(%d+)")
	x, y, z = tonumber(x), tonumber(y), tonumber(z)
	minx, miny, minz = math.min(minx, x), math.min(miny, y), math.min(minz, z)
	maxx, maxy, maxz = math.max(maxx, x), math.max(maxy, y), math.max(maxz, z)
	cubes[key({ x, y, z })] = { x, y, z }
end

for _, cube in pairs(cubes) do
	exterior_surface = exterior_surface + 6
	for _, c in ipairs(adjacent(cube)) do
		exterior_surface = exterior_surface - (cubes[key(c)] and 1 or 0)
	end
end
print("p1", exterior_surface)

local seen_air = {}

local function spread(cube)
	seen_air[key(cube)] = true
	for _, c in ipairs(adjacent(cube)) do
		local x2, y2, z2 = table.unpack(c)

		if
			x2 >= minx - 1
			and x2 <= maxx + 1
			and y2 >= miny - 1
			and y2 <= maxy + 1
			and z2 >= minz - 1
			and z2 <= maxz + 1
		then
			local k = key(c)
			if not seen_air[k] and not cubes[k] then
				spread(c)
			end
		end
	end
end
spread({ minx - 1, miny - 1, minz - 1 })

local pockets = {}
for x = minx, maxx do
	for y = miny, maxy do
		for z = minz, maxz do
			local k = key({ x, y, z })
			if not seen_air[k] and not cubes[k] then
				table.insert(pockets, { x, y, z })
			end
		end
	end
end

for _, pocket in ipairs(pockets) do
	for _, p in ipairs(adjacent(pocket)) do
		exterior_surface = exterior_surface - (cubes[key(p)] and 1 or 0)
	end
end

print("p2", exterior_surface)
