local sum = 0
for line in io.lines() do
	local half = #line / 2
	local left = string.sub(line, 1, half)
	local right = string.sub(line, half + 1)
	for c in string.gmatch(left, "%w") do
		if string.match(right, c, 1) then
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
end
print(sum)
