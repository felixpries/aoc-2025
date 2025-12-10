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


local main = function()
  local bytes_matrix = {}
  local accessible = 0

  for line in io.lines() do
    bytes_matrix[#bytes_matrix + 1] = { line:byte(1, #line) }
    for i, value in ipairs(bytes_matrix[#bytes_matrix]) do
      bytes_matrix[#bytes_matrix][i] = (value == 64) and 1 or 0
    end
  end

  for x = 1, #bytes_matrix do
    for y = 1, #bytes_matrix[x] do
      if bytes_matrix[x][y] == 1 then
        local neighbors = get_neighbors(bytes_matrix, x, y)
        if neighbors < 4 then
          accessible = accessible + 1
        end
      end
    end
  end

  print(accessible)
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
