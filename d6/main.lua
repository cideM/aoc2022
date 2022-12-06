local function all_chars_different(chars)
	local seen, unique = {}, {}
	for c in string.gmatch(chars, "%w") do
		if not seen[c] then
			table.insert(unique, c)
			seen[c] = {}
		end
	end
	return #unique == #chars
end

local line, p1, p2 = io.read("a"), 0, 0
for i = 1, #line do
	if i >= 4 and p1 == 0 and all_chars_different(string.sub(line, i - 3, i)) then
		p1 = i
	end

	if i >= 14 and p2 == 0 and all_chars_different(string.sub(line, i - 13, i)) then
		p2 = i
	end

	if p1 > 0 and p2 > 0 then
		break
	end

	i = i + 1
end

print(p1, p2)
