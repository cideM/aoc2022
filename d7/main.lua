local dirs, stack = {}, { "root" }
for line in io.lines() do
	if string.match(line, "^(%d+)") then
		local path = ""
		for _, dir in ipairs(stack) do
			path = path .. "/" .. dir
			dirs[path] = (dirs[path] or 0) + tonumber(string.match(line, "^(%d+)"))
		end
	elseif line == "$ cd /" then
		stack = { "root" }
	elseif line == "$ cd .." then
		table.remove(stack, #stack)
	elseif string.match(line, "$ cd (%g+)") then
		local dir = string.match(line, "$ cd (%g+)")
		table.insert(stack, dir)
	end
end

local sum, min = 0, math.maxinteger
for _, size in pairs(dirs) do
	if size <= 100000 then
		sum = sum + size
	end
	if 70000000 - dirs["/root"] + size > 30000000 then
		min = math.min(size, min)
	end
end
print(sum, min)
