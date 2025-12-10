local preprocess_input = function()
  local id_ranges = {}

  for line in io.lines() do
    if line == "" then
      break
    else
      local matcher = string.gmatch(line, "([^-]+)")
      local left = tonumber(matcher())
      local right = tonumber(matcher())
      id_ranges[#id_ranges + 1] = { left, right }
    end
  end

  return id_ranges
end

local ranges_sorter = function(a, b)
  return a[1] < b[1]
end


local main = function()
  local valid_ids_count = 0
  local last_highest_id = 0

  local id_ranges = preprocess_input()
  table.sort(id_ranges, ranges_sorter)

  for i = 1, #id_ranges do
    local id_range_lower = id_ranges[i][1]
    local id_range_upper = id_ranges[i][2]

    if id_range_lower < last_highest_id then
      id_range_lower = last_highest_id
    end

    if id_range_lower <= id_range_upper then
      valid_ids_count = valid_ids_count + id_range_upper - id_range_lower + 1
      last_highest_id = id_range_upper + 1
    end
  end

  print(valid_ids_count)
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
