local grid = {}

for line in io.lines() do
	table.insert(grid, line)
end

local function get(x, y)
	if x < 1 or x > #grid[1] or y < 1 or y > #grid then
		return math.mininteger
	else
		return tonumber(string.sub(grid[y], x, x))
	end
end

local trees_visible = 0
local max_view = 0

for row, line in ipairs(grid) do
	local col = 1
	for num in string.gmatch(line, "%w") do
		local cur_height, num_directions_visible = tonumber(num), 4

		local top = 0
		for r = row - 1, 1, -1 do
			top = top + 1
			if get(col, r) >= cur_height then
				num_directions_visible = num_directions_visible - 1
				break
			end
		end

		local bottom = 0
		for r = row + 1, #grid do
			bottom = bottom + 1
			if get(col, r) >= cur_height then
				num_directions_visible = num_directions_visible - 1
				break
			end
		end

		local left = 0
		for c = col - 1, 1, -1 do
			left = left + 1
			if get(c, row) >= cur_height then
				num_directions_visible = num_directions_visible - 1
				break
			end
		end

		local right = 0
		for c = col + 1, #grid[1], 1 do
			right = right + 1
			if get(c, row) >= cur_height then
				num_directions_visible = num_directions_visible - 1
				break
			end
		end

		trees_visible = trees_visible + (num_directions_visible > 0 and 1 or 0)
		max_view = math.max(max_view, top * bottom * left * right)
		col = col + 1
	end
end
print("p1", trees_visible)
print("p2", max_view)
