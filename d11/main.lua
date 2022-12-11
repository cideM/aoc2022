local monkeys, all_divisors = {}, {}

for line in io.lines() do
	local monkey_num = string.match(line, "Monkey (%d+):")
	if monkey_num then
		table.insert(monkeys, {
			name = tonumber(monkey_num) + 1,
			items = {},
			inspection_count = 0,
			op = nil,
			test = nil,
			if_true = nil,
			if_false = nil,
		})
	end

	local m = monkeys[#monkeys]

	if string.match(line, "Starting") then
		for item in string.gmatch(line, "(%d+)") do
			table.insert(m.items, tonumber(item))
		end
	end

	if string.match(line, "Operation") then
		m.op = string.match(line, "Operation: (.*)")
	end

	if string.match(line, "Test:") then
		local divisible_by = string.match(line, "(%d+)")
		divisible_by = tonumber(divisible_by)
		table.insert(all_divisors, divisible_by)
		m.test = function(n)
			return n % divisible_by == 0
		end
	end

	if string.match(line, "If true:") then
		m.if_true = tonumber(string.match(line, "(%d+)")) + 1 -- adjust for Lua indices
	end

	if string.match(line, "If false:") then
		m.if_false = tonumber(string.match(line, "(%d+)")) + 1 -- adjust for Lua indices
	end
end

local function simulate(rounds, manage_worry, fresh_monkeys)
	for _ = 1, rounds do
		for _, m in ipairs(fresh_monkeys) do
			for item_num, worry_level in ipairs(m.items) do
				m.inspection_count = m.inspection_count + 1
				local env = { new = 1, old = worry_level }
				assert(load(m.op, m.name, "t", env))()
				local new_worry = manage_worry(env.new)
				m.items[item_num] = new_worry
				local target = m.test(new_worry) and m.if_true or m.if_false
				table.insert(fresh_monkeys[target].items, new_worry)
			end
			m.items = {}
		end
	end
end

local function make_fresh_monkeys(original)
	local out = {}
	for _, m in ipairs(original) do
		table.insert(out, m)
		out[#out].items = table.move(m.items, 1, #m.items, 1, {})
	end
	return out
end

local function monkey_business(fresh_monkeys)
	local counts = {}
	for _, m in ipairs(fresh_monkeys) do
		table.insert(counts, m.inspection_count)
	end
	table.sort(counts)
	print(counts[#counts] * counts[#counts - 1])
end

local monkeys_1 = make_fresh_monkeys(monkeys)
local manage_worry_p1 = function(n)
	return math.floor(n / 3)
end
simulate(20, manage_worry_p1, monkeys_1)
monkey_business(monkeys_1)

local divisors_product = all_divisors[1]
for _, n in ipairs({ table.unpack(all_divisors, 2) }) do
	divisors_product = divisors_product * n
end

local monkeys_2 = make_fresh_monkeys(monkeys)
local manage_worry_p2 = function(n)
	return n % divisors_product
end
simulate(10000, manage_worry_p2, monkeys_2)
monkey_business(monkeys_2)
