local count_numbers = 100
local dial_position = 50

local password = 0

while true do
  local line = io.read()
  if line == nil then break end
  local operator = string.sub(line, 1, 1)
  local num = tonumber(string.sub(line, 2, nil))

  local overshoot_count = math.floor(num / count_numbers)
  password = password + overshoot_count

  if operator == "L" then
    num = -num
  end

  local dial_position_prev = dial_position

  dial_position = (num + dial_position) % count_numbers

  if dial_position_prev ~= 0 and (
        dial_position == 0
        or ((dial_position_prev < dial_position) and operator == "L")
        or ((dial_position_prev > dial_position) and operator == "R")) then
    password = password + 1
  end
end

print(password)
