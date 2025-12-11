local main = function()
  local points = {}

  local horizontal_lines = {}
  local vertical_lines = {}
  local tile_cache = {}

  local add_line = function(point, previous_point)
    if previous_point == nil then
    elseif previous_point.y == point.y then
      vertical_lines[#vertical_lines + 1] = {
        y = point.y,
        x1 = previous_point.x < point.x and previous_point.x or point.x,
        x2 = previous_point.x > point.x and previous_point.x or point.x,
      }
    elseif previous_point.x == point.x then
      horizontal_lines[#horizontal_lines + 1] = {
        x = point.x,
        y1 = previous_point.y < point.y and previous_point.y or point.y,
        y2 = previous_point.y > point.y and previous_point.y or point.y,
      }
    end
  end


  local is_green_or_red = function(x, y)
    local left = 0
    local right = 0
    local top = 0
    local bottom = 0

    for _, horizontal_line in ipairs(horizontal_lines) do
      if x == horizontal_line.x and horizontal_line.y1 <= y and y <= horizontal_line.y2 then
        return true
      end

      if horizontal_line.y1 <= y and y < horizontal_line.y2 then
        if x < horizontal_line.x then
          top = top + 1
        else
          bottom = bottom + 1
        end
      end
    end

    for _, vertical_line in ipairs(vertical_lines) do
      if y == vertical_line.y and vertical_line.x1 <= x and x <= vertical_line.x2 then
        return true
      end
      if vertical_line.x1 <= x and x < vertical_line.x2 then
        if y < vertical_line.y then
          right = right + 1
        else
          left = left + 1
        end
      end
    end

    return ((right % 2) == 1 and (left % 2) == 1) or ((top % 2) == 1 and (bottom % 2) == 1)
  end

  local is_green_or_red_with_cache = function(x, y)
    if not tile_cache[x] then
      tile_cache[x] = {}
    end

    if tile_cache[x][y] ~= nil then
      return tile_cache[x][y]
    end

    local result = is_green_or_red(x, y)
    tile_cache[x][y] = result
    return result
  end

  local rect_is_valid = function(point_a, point_b)
    -- check opposite corner
    if not (
          is_green_or_red_with_cache(point_a.x, point_b.y)
          and is_green_or_red_with_cache(point_b.x, point_a.y))
    then
      return false
    end

    for x = point_a.x, point_b.x, point_a.x < point_b.x and 1 or -1 do
      if not (
            is_green_or_red_with_cache(x, point_a.y)
            and is_green_or_red_with_cache(x, point_b.y)) then
        return false
      end
    end
    for y = point_a.y, point_b.y, point_a.y < point_b.y and 1 or -1 do
      if not (
            is_green_or_red_with_cache(point_a.x, y)
            and is_green_or_red_with_cache(point_b.x, y)) then
        return false
      end
    end

    return true
  end

  for line in io.lines() do
    local int_matcher = string.gmatch(line, "[^,]+")
    local point = { x = tonumber(int_matcher()), y = tonumber(int_matcher()) }
    local previous_point = points[#points]

    points[#points + 1] = point
    add_line(point, previous_point)
  end
  add_line(points[1], points[#points])

  local rect_sizes = {}

  for i, point_a in ipairs(points) do
    for j, point_b in ipairs(points) do
      if i > j then
        local rect_size = (math.abs(point_a.x - point_b.x) + 1) * (math.abs(point_a.y - point_b.y) + 1)
        rect_sizes[#rect_sizes + 1] = { size = rect_size, a = point_a, b = point_b }
      end
    end
  end

  table.sort(rect_sizes, function(a, b) return a.size > b.size end)

  for _, v in ipairs(rect_sizes) do
    if rect_is_valid(v.a, v.b) then
      print(string.format("The largest rectancle has an area of %d", v.size))
      break
    end
  end
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
