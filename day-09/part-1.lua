local main = function()
  local points = {}
  local rect_sizes = {}

  for line in io.lines() do
    local int_matcher = string.gmatch(line, "[^,]+")
    points[#points + 1] = { int_matcher(), int_matcher() }
  end


  for i, point_a in ipairs(points) do
    for j, point_b in ipairs(points) do
      if i > j then
        rect_sizes[#rect_sizes + 1] = (math.abs(point_a[1] - point_b[1]) + 1) * (math.abs(point_a[2] - point_b[2]) + 1)
      end
    end
  end

  table.sort(rect_sizes, function(a, b) return b < a end)

  print(string.format("The largest rectancle has an area of %d", rect_sizes[1]))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
