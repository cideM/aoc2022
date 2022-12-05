local crates, crates_2 = {}, {}

for line in io.lines() do
	if #crates == 0 then
		local num_crates = ((#line - 3) / 4) + 1
		for _ = 1, num_crates do
			table.insert(crates, {})
			table.insert(crates_2, {})
		end
	end

	if string.find(line, "[", 1, true) then
		local crate_index = 1
		for i = 2, #line, 4 do
			local v = string.sub(line, i, i)
			if v ~= " " then
				table.insert(crates[crate_index], 1, v)
				table.insert(crates_2[crate_index], 1, v)
			end
			crate_index = crate_index + 1
		end
	end

	if string.find(line, "move", 1, true) then
		local amount, from, to = string.match(line, "move (%d+) from (%d+) to (%d+)")
		amount, from, to = tonumber(amount), tonumber(from), tonumber(to)

		local source, dest = crates_2[from], crates_2[to]
		-- Moving does not remove the values from "source", so we do that with the
		-- second table.move
		table.move(source, #source - (amount - 1), #source, #dest + 1, dest)
		table.move({}, 1, amount, #source - (amount - 1), source)

		for _ = 1, amount do
			local crate = table.remove(crates[from])
			table.insert(crates[to], crate)
		end
	end
end

print("p1:")
for _, stack in ipairs(crates) do
	io.write(stack[#stack])
end

print("p2:")
for _, stack in ipairs(crates_2) do
	io.write(stack[#stack])
end
