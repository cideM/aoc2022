local one = {
	["A X"] = 4,
	["A Y"] = 8,
	["A Z"] = 3,
	["B X"] = 1,
	["B Y"] = 5,
	["B Z"] = 9,
	["C X"] = 7,
	["C Y"] = 2,
	["C Z"] = 6,
}

local two = {
	["A X"] = 3,
	["A Y"] = 4,
	["A Z"] = 8,
	["B X"] = 1,
	["B Y"] = 5,
	["B Z"] = 9,
	["C X"] = 2,
	["C Y"] = 6,
	["C Z"] = 7,
}

local score_one, score_two = 0, 0
for line in io.lines() do
	score_one = score_one + one[line]
	score_two = score_two + two[line]
end
print(score_one, score_two)
