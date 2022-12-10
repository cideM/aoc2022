local image = {}
for _ = 1, 6 do
	local new_row = {}
	for _ = 1, 40 do
		table.insert(new_row, " ")
	end
	table.insert(image, new_row)
end

local values = { 1 }
for line in io.lines() do
	if line == "noop" then
		table.insert(values, values[#values])
	else
		local _, value = string.match(line, "(%g+) (%-?%d+)")
		table.insert(values, values[#values])
		table.insert(values, values[#values] + tonumber(value))
	end
end

local when_to_measure = {
	[20] = true,
	[60] = true,
	[100] = true,
	[140] = true,
	[180] = true,
	[220] = true,
}
local sum = 0
for i, v in ipairs(values) do
	local crt_pos = i % 40
	crt_pos = crt_pos == 0 and 40 or crt_pos

	local row = math.floor((i - 1) / 40) + 1
	if crt_pos >= v and crt_pos <= v + 2 then
		image[row][crt_pos] = "X"
	end
	sum = when_to_measure[i] and sum + v * i or sum
end
print(sum)

for i = 1, 6 do
	print(table.concat(image[i], ""))
end
