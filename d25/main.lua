local convert = {
	["2"] = 2,
	["1"] = 1,
	["="] = -2,
	["-"] = -1,
	["0"] = 0,
}

local sum = 0
for line in io.lines() do
	local cur, n = 5 ^ (#line - 1), 0
	for c in string.gmatch(line, ".") do
		n, cur = n + convert[c] * cur, cur / 5
	end
	sum = sum + n
end

local nums = {}
while sum > 0 do
	sum = sum + 2
	table.insert(nums, 1, sum % 5)
	sum = sum // 5
end

local base5_to_snafu = {
	[4] = 2,
	[3] = 1,
	[2] = 0,
	[1] = "-",
	[0] = "=",
}
for _, v in ipairs(nums) do
	io.write(base5_to_snafu[v])
end
