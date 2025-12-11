local main = function()
  local last_line = {}
  local splits = 0
  local dot_char = 46
  local splitter_char = 94
  local start_char = 83
  local beam_char = 124

  for line in io.lines() do
    local current_line = {}
    for i, char in ipairs({ string.byte(line, 1, #line) }) do
      local upper_char = last_line[i]

      if upper_char == start_char or (upper_char == beam_char and char == dot_char) then
        char = beam_char
      elseif upper_char == beam_char and char == splitter_char then
        splits = splits + 1
        current_line[i - 1] = beam_char
        current_line[i + 1] = beam_char
      end

      if current_line[i] == nil then
        current_line[i] = char
      end
    end
    last_line = current_line
  end
  print(string.format("The total number of splits is %d", splits))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
