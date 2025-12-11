local get_circuit_for_point = function(circuits, point_id)
  for i, circuit in pairs(circuits) do
    if circuit[point_id] then
      return i
    end
  end
end

local merge_circuits = function(circuits, circuit_id_1, circuit_id_2)
  if circuit_id_1 == circuit_id_2 then
    return
  end

  for i, _ in pairs(circuits[circuit_id_2]) do
    circuits[circuit_id_1][i] = true
  end
  circuits[circuit_id_2] = nil
end

local get_circuit_sizes = function(circuits)
  local sizes = {}
  for _, circuit in pairs(circuits) do
    local count = 0
    for _ in pairs(circuit) do
      count = count + 1
    end
    sizes[#sizes + 1] = count
  end
  return sizes
end


local main = function()
  local total_connection = 1000
  local points = {}
  local circuits = {}

  for line in io.lines() do
    local point_matcher = string.gmatch(line, "([^,]+)")
    local i = #points + 1
    points[i] = { point_matcher(), point_matcher(), point_matcher() }
    circuits[i] = { [i] = true }
  end
  if #points == 20 then
    total_connection = 10
  end

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

  for i = 1, total_connection do
    local point_distance = point_distances[i]
    local circuit_id_1 = get_circuit_for_point(circuits, point_distance[2])
    local circuit_id_2 = get_circuit_for_point(circuits, point_distance[3])
    merge_circuits(circuits, circuit_id_1, circuit_id_2)
  end

  local circuits_sizes = get_circuit_sizes(circuits)
  table.sort(circuits_sizes, function(a, b) return a > b end)
  local product_three_largest = circuits_sizes[1] * circuits_sizes[2] * circuits_sizes[3]

  print(string.format("The product of the three largest circuits is %d", product_three_largest))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
