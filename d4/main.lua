local count, count2 = 0, 0
for line in io.lines() do
	local a1, a2, b1, b2 = string.match(line, "(%d+)-(%d+),(%d+)-(%d+)")
	a1, a2, b1, b2 = tonumber(a1), tonumber(a2), tonumber(b1), tonumber(b2)
	if (a1 <= b1 and a2 >= b2) or (b1 <= a1 and b2 >= a2) then
		count = count + 1
	end

	if a1 <= b2 and b1 <= a2 then
		count2 = count2 + 1
	end
end
print(count, count2)
