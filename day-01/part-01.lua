local count_numbers = 100
local dial_position = 50

local password = 0

while true do
  local line = io.read()
  if line == nil then break end
  local operator = string.sub(line, 1, 1)
  local num = tonumber(string.sub(line, 2, nil))

  if operator == "L" then
    num = -num
  end
  dial_position = (num + dial_position) % count_numbers

  if dial_position == 0 then
    password = password + 1
  end
end

print(password)
