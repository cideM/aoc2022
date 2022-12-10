local register_history = {1}

local when_to_measure = {
	[20] = true,
	[60] = true,
	[100] = true,
	[140] = true,
	[180] = true,
	[220] = true,
}

for line in io.lines() do
	local instruction, value = string.match(line, "(%g+) (%-?%d+)")

	if instruction == "noop" then
    table.insert(register_history, register_history[#register_history])
	else
		if instruction == "addx" then
      table.insert(register_history, register_history[#register_history])
			register = register + tonumber(value)
      cycle = cycle + 1
		end
	end
end
print(signal_strength_sum)
