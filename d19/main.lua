local blueprints, blueprints_max_costs = {}, {}
for line in io.lines() do
	local iter = string.gmatch(line, "(%d+)")
	iter() -- Blueprint number, throw away

	local blueprint = {
		{ tonumber(iter()), 0, 0, 0 },
		{ tonumber(iter()), 0, 0, 0 },
		{ tonumber(iter()), tonumber(iter()), 0, 0 },
		{ tonumber(iter()), 0, tonumber(iter()), 0 },
	}
	table.insert(blueprints, blueprint)

	table.insert(blueprints_max_costs, {
		math.max(blueprint[1][1], blueprint[2][1], blueprint[3][1], blueprint[4][1]),
		math.max(blueprint[3][2]),
		math.max(blueprint[4][3]),
	})
end

local max, cache = math.max, {}
local function solve(blueprint_i, minutes, robots, resources)
	if minutes == 0 then
		return resources[4]
	end

	local bp = blueprints[blueprint_i]
	local max_costs = blueprints_max_costs[blueprint_i]

	local max_geodes = 0

	local num_robot_key = robots[1] + max_costs[1] * (robots[2] + max_costs[2] * (robots[3] + max_costs[3] * robots[4]))
	local resources_key = resources[1]
		+ max_costs[1] * (resources[2] + max_costs[2] * (resources[3] + max_costs[3] * resources[4]))
	local key = blueprint_i + #blueprints * (minutes + 32 * (num_robot_key + 10000000 * resources_key))
	if cache[key] then
		return cache[key]
	end

	local build_robot = function(i)
		local r = { resources[1], resources[2], resources[3], resources[4] } -- new resources
		local cost = bp[i]
		r[1] = r[1] - cost[1] -- pay cost of new robot
		r[2] = r[2] - cost[2]
		r[3] = r[3] - cost[3]
		r[4] = r[4] - cost[4]
		if r[1] >= 0 and r[2] >= 0 and r[3] >= 0 and r[4] >= 0 then -- can build robot?
			local new_robots = { robots[1], robots[2], robots[3], robots[4] }
			new_robots[i] = new_robots[i] + 1 -- increase count of robot we just built

			max_geodes = max(
				max_geodes,
				solve(blueprint_i, minutes - 1, new_robots, {
					-- Don't gather resources we don't need
					r[1] > max_costs[1] and r[1] or r[1] + robots[1], -- gather resources AFTER paying
					r[2] > max_costs[2] and r[2] or r[2] + robots[2],
					r[3] > max_costs[3] and r[3] or r[3] + robots[3],
					r[4] + robots[4],
				})
			)
		end
	end

	build_robot(4) -- always try to build geode cracker
	for i = 3, 1, -1 do
    -- don't build robots if we already have enough robots of a kind
		if robots[i] < max_costs[i] then
			build_robot(i)
		end
	end

  -- do nothing must always (?) be evaluated
	local r = resources
	max_geodes = max(
		max_geodes,
		solve(blueprint_i, minutes - 1, robots, {
			r[1] > max_costs[1] and r[1] or r[1] + robots[1], -- gather without paying anything
			r[2] > max_costs[2] and r[2] or r[2] + robots[2],
			r[3] > max_costs[3] and r[3] or r[3] + robots[3],
			r[4] + robots[4],
		})
	)

	cache[key] = max_geodes
	return max_geodes
end

local p1, p2 = 0, 1
for i in ipairs(blueprints) do
	local result = solve(i, 24, { 1, 0, 0, 0 }, { 0, 0, 0, 0 })
	p1 = p1 + i * result
	print(string.format("Case #%d: %d", i, result))
	if i <= 3 then
		local result2 = solve(i, 32, { 1, 0, 0, 0 }, { 0, 0, 0, 0 })
		p2 = p2 * result2
		print(string.format("P2 Case #%d: %d", i, result2))
	end
end
print("p1", p1)
print("p2", p2)
