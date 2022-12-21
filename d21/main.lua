local function key(s)
	local t = {}
	for c in string.gmatch(s, ".") do
		table.insert(t, string.byte(c) - 97)
	end
	return t[1] + 25 * (t[2] + 25 * (t[3] + 25 * t[4]))
end

local op_map = {
	["+"] = function(a, b)
		return a + b
	end,
	["/"] = function(a, b)
		return a / b
	end,
	["*"] = function(a, b)
		return a * b
	end,
	["-"] = function(a, b)
		return a - b
	end,
}

-- Each monkey name is an index and the value is either a number or a function
local cache = {}
for line in io.lines() do
	if string.find(line, "%d") then
		cache[key(string.match(line, "(%l+):"))] = tonumber(string.match(line, "(%d+)"))
	else
		local name, left, op, right = string.match(line, "(%l+): (%l+) ([+*/-]) (%l+)")
		cache[key(name)] = {
			left = key(left),
			right = key(right),
			fn = op_map[op],
		}
	end
end

local function p1(i)
	local cur = cache[i]
	return type(cur) == "table" and cur.fn(p1(cur.left), p1(cur.right)) or cur
end
print(string.format("p1\t%.i", p1(key("root"))))

local l, r, target = cache[key("root")].left, cache[key("root")].right, key("humn")

-- I observed but don't understand that the difference between left and right
-- for root reacts differently when changing the target number. For my input it
-- goes up, for my example it goes down. Depending on this behavior I need to
-- flip left and right. Note that it doesn't depend on which branch is fixed.
cache[target] = 1
local diff = p1(l) - p1(r)
cache[target] = 2
if p1(l) - p1(r) > diff then
	r, l = l, r
end

local low, high = 0, 1 << 60
while low < high do
	local mid = (high + low) / 2
	cache[target] = mid
	diff = p1(l) - p1(r)
	if diff > 0 then
		low = mid
	elseif diff == 0 then
		print("p2", mid)
		os.exit()
	else
		high = mid
	end
end
