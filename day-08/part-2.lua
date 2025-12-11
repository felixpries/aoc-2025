local get_circuit_for_point = function(circuits, point_id)
  for i, circuit in pairs(circuits) do
    if circuit[point_id] then
      return i
    end
  end
end

local merge_circuits = function(circuits, circuit_id_1, circuit_id_2)
  if circuit_id_1 == circuit_id_2 then
    return false
  end

  for i, _ in pairs(circuits[circuit_id_2]) do
    circuits[circuit_id_1][i] = true
  end
  circuits[circuit_id_2] = nil
  return true
end


local main = function()
  local points = {}
  local circuits = {}
  local result = 0

  for line in io.lines() do
    local point_matcher = string.gmatch(line, "([^,]+)")
    local i = #points + 1
    points[i] = { point_matcher(), point_matcher(), point_matcher() }
    circuits[i] = { [i] = true }
  end
  local circuit_count = #circuits

  local point_distances = {}
  for i, point_a in ipairs(points) do
    for j, point_b in ipairs(points) do
      if i < j then
        local distance = math.sqrt(
          (point_a[1] - point_b[1]) ^ 2 +
          (point_a[2] - point_b[2]) ^ 2 +
          (point_a[3] - point_b[3]) ^ 2
        )
        point_distances[#point_distances + 1] = { distance, i, j }
      end
    end
  end

  table.sort(point_distances, function(a, b) return a[1] < b[1] end)

  local i = 1
  while true do
    local point_distance = point_distances[i]
    local circuit_id_1 = get_circuit_for_point(circuits, point_distance[2])
    local circuit_id_2 = get_circuit_for_point(circuits, point_distance[3])
    local merged_circuit = merge_circuits(circuits, circuit_id_1, circuit_id_2)
    if merged_circuit then
      circuit_count = circuit_count - 1
    end

    if circuit_count == 1 then
      local point_1 = points[point_distance[2]]
      local point_2 = points[point_distance[3]]
      result = point_1[1] * point_2[1]
      break
    end

    i = i + 1
  end

  print(string.format("The result is %d", result))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
