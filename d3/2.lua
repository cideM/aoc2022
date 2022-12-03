local sum, group = 0, {}
for line in io.lines() do
  table.insert(group, line)
	if #group < 3 then goto continue end

	for c in string.gmatch(group[1], "%w") do
		if string.match(group[2], c, 1) and string.match(group[3], c, 1) then
			local score = 0
			if string.match(c, "%l") then
				score = string.byte(c) - string.byte("a") + 1
			else
				score = string.byte(c) - string.byte("A") + 1 + 26
			end
			sum = sum + score
			break
		end
	end
  group = {}
	::continue::
end
print(sum)
