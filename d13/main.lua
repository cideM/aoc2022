local function compare(l, r)
	if type(l) == "number" and type(r) == "number" then
		if r < l then
			return false
		end
		if l < r then
			return true
		end
	elseif type(l) == "table" and type(r) == "table" then
		for i = 1, #l >= #r and #l or #r do
			local result = compare(l[i], r[i])
			if result ~= nil then
				return result
			end
		end
	elseif type(l) == "number" and type(r) ~= "number" then
		return compare({ l }, r)
	elseif not l and r then
		return true
	elseif l and not r then
		return false
	elseif type(l) ~= "number" and type(r) == "number" then
		return compare(l, { r })
	end
end

local lines, sum = {}, 0
for line in io.lines() do
	if line ~= "" then
		table.insert(lines, load("return" .. string.gsub(string.gsub(line, "%[", "{"), "%]", "}"))())
		if #lines % 2 == 0 and compare(lines[#lines - 1], lines[#lines]) then
			sum = sum + #lines / 2
		end
	end
end
print(sum)

local divider_1, divider_2 = { { 6 } }, { { 2 } }
table.insert(lines, divider_1)
table.insert(lines, divider_2)
table.sort(lines, compare)

local mul = 1
for j, line in ipairs(lines) do
	if line == divider_1 or line == divider_2 then
		mul = mul * j
	end
end
print(mul)
