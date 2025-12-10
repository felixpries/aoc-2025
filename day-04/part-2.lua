local get_neighbors = function(bytes_matrix, x, y)
  local neighbors = 0
  for delta_x = -1, 1 do
    for delta_y = -1, 1 do
      if delta_x ~= 0 or delta_y ~= 0 then
        neighbors = neighbors + ((bytes_matrix[x + delta_x] or {})[y + delta_y] or 0)
      end
    end
  end
  return neighbors
end

local retrieve_rolls = function(bytes_matrix)
  local retrieved = 0
  for x = 1, #bytes_matrix do
    for y = 1, #bytes_matrix[x] do
      if bytes_matrix[x][y] == 1 then
        local neighbors = get_neighbors(bytes_matrix, x, y)
        if neighbors < 4 then
          retrieved = retrieved + 1
          bytes_matrix[x][y] = 0
        end
      end
    end
  end
  return retrieved
end


local main = function()
  local bytes_matrix = {}
  local retrieved_sum = 0

  for line in io.lines() do
    bytes_matrix[#bytes_matrix + 1] = { line:byte(1, #line) }
    for i, value in ipairs(bytes_matrix[#bytes_matrix]) do
      bytes_matrix[#bytes_matrix][i] = (value == 64) and 1 or 0
    end
  end

  while true do
    local retrieved = retrieve_rolls(bytes_matrix)
    if retrieved == 0 then break end
    retrieved_sum = retrieved_sum + retrieved
  end

  print(retrieved_sum)
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
