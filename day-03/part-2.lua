local get_largest_char_with_index = function(input)
  local largest_char = nil
  local largest_index = 1

  for i = 1, #input do
    local char = string.sub(input, i, i)

    if largest_char == nil or char > largest_char then
      largest_char = char
      largest_index = i
    end
  end

  return largest_index, largest_char
end

local result = 0
local battery_count = 12

while true do
  local input = io.read()
  if input == nil then break end

  local number_string = ""
  local last_index = 1

  for i = 1, battery_count do
    local index, char = get_largest_char_with_index(string.sub(input, last_index, #input - battery_count + i))
    last_index = last_index + index
    number_string = number_string .. char
  end

  result = result + tonumber(number_string)
end

print(result)
