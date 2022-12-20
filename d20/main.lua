local list, order, zero = {}, {}, nil
for line in io.lines() do
	local n = { tonumber(line) }
	table.insert(order, n)
	table.insert(list, n)
	if line == "0" then
		zero = n
	end
end

local function index(i)
	local l = #list
	local new_pos = (i % l + l) % l
	return new_pos == 0 and l or new_pos
end

local original_list = { table.unpack(list) }
for round = 1, 12 do
	-- Mix once with the original list, then reset the list, and mix it 10 more
	-- times after multiplying each value with a constant number for part 2.
	if round == 2 or round == 12 then
		for i, n in ipairs(list) do
			if n == zero then
				local a, b, c = list[index(i + 1000)][1], list[index(i + 2000)][1], list[index(i + 3000)][1]
				print(a, b, c, a + b + c)
			end
		end
		for _, n in ipairs(order) do
			n[1] = n[1] * 811589153
		end
		list = original_list
	end

	for _, node in ipairs(order) do
		for i, listnode in ipairs(list) do
			if listnode == node then
				table.remove(list, i)
				table.insert(list, index(i + node[1]), node)
				goto continue
			end
		end
		::continue::
	end
end
