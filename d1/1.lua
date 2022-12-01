local sums = {}
local cur = 0
for line in io.lines() do
	if line == "" then
		table.insert(sums, cur)
		cur = 0
	end

	if line ~= "" then
		local num = tonumber(line)
		cur = cur + num
	end
end

table.sort(sums, function(a, b)
	return a > b
end)

print(sums[1])
print(sums[1] + sums[2] + sums[3])
