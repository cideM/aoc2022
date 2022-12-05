local a = {"a", "b", "c"}
local b = {"f"}

-- from a to b
local to_move = 2
table.move(a, #a - (to_move - 1), #a, #b + 1, b)
table.move({}, 1, to_move, #a - (to_move - 1), a)
print(table.unpack(a))
print(table.unpack(b))
