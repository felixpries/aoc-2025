local dot_char = 46
local splitter_char = 94
local start_char = 83
local beam_char = 124

local parse_tachyon_manifold = function()
  local all_lines = {}
  local last_line = {}

  for line in io.lines() do
    local current_line = {}
    for i, char in ipairs({ string.byte(line, 1, #line) }) do
      local upper_char = last_line[i]

      if upper_char == start_char or (upper_char == beam_char and char == dot_char) then
        char = beam_char
      elseif upper_char == beam_char and char == splitter_char then
        current_line[i - 1] = beam_char
        current_line[i + 1] = beam_char
      end

      if current_line[i] == nil then
        current_line[i] = char
      end
    end
    last_line = current_line
    all_lines[#all_lines + 1] = current_line
  end

  return all_lines
end

local calculate_paths = function(tachyon_manifold)
  local lower_path_numbers = {}

  for i = #tachyon_manifold, 1, -1 do
    local current_path_numbers = {}

    for j, char in ipairs(tachyon_manifold[i]) do
      local lower_char = (tachyon_manifold[i + 1] or {})[j] or beam_char
      local lower_path_number = lower_path_numbers[j] or 1

      local current_path_number = 0

      if lower_char == beam_char and char == beam_char then
        current_path_number = lower_path_number
      elseif lower_char == splitter_char and char == beam_char then
        current_path_number = lower_path_numbers[j - 1] + lower_path_numbers[j + 1]
      elseif char == start_char then
        return lower_path_number
      end

      current_path_numbers[#current_path_numbers + 1] = current_path_number
    end
    lower_path_numbers = current_path_numbers
  end
  return 0
end

local main = function()
  local tachyon_manifold = parse_tachyon_manifold()
  local num_paths = calculate_paths(tachyon_manifold)
  print(string.format("The total number of paths is %d", num_paths))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
