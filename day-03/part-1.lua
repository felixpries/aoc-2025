local get_largest_char_with_index = function(input)
  local largest_char = nil
  local largest_index = nil

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

while true do
  local input = io.read()
  if input == nil then break end

  local index, char = get_largest_char_with_index(string.sub(input, 1, #input - 1))
  local _, char_2 = get_largest_char_with_index(string.sub(input, index + 1, #input))

  result = result + tonumber(char .. char_2)
end

print(result)
