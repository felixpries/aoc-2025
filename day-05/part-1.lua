local preprocess_input = function()
  local id_ranges = {}
  local ids = {}

  local state = 0

  for line in io.lines() do
    if line == "" then
      state = 1
    elseif state == 0 then
      local matcher = string.gmatch(line, "([^-]+)")
      local left = tonumber(matcher())
      local right = tonumber(matcher())
      id_ranges[#id_ranges + 1] = { left, right }
    else
      ids[#ids + 1] = tonumber(line)
    end
  end

  return id_ranges, ids
end

local ranges_sorter = function(a, b)
  return a[1] < b[1]
end


local main = function()
  local valid_ids_count = 0
  local id_ranges_pointer = 1
  local ids_pointer = 1

  local id_ranges, ids = preprocess_input()
  table.sort(id_ranges, ranges_sorter)
  table.sort(ids)

  while true do
    if (id_ranges_pointer > #id_ranges) or (ids_pointer > #ids) then
      break
    end
    local id = ids[ids_pointer]
    local id_range_lower = id_ranges[id_ranges_pointer][1]
    local id_range_upper = id_ranges[id_ranges_pointer][2]

    if id < id_range_lower then
      ids_pointer = ids_pointer + 1
    elseif id <= id_range_upper then
      ids_pointer = ids_pointer + 1
      valid_ids_count = valid_ids_count + 1
    else
      id_ranges_pointer = id_ranges_pointer + 1
    end
  end

  print(valid_ids_count)
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
