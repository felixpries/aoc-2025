---@alias NodePart1 {children: string[], counter: integer}
---@alias NodesPart1 table<string, NodePart1>

local bfs_walk_func = function(node_ids, nodes, visited_nodes)
  local node_id = table.remove(node_ids, 1)
  if not node_id then
    return
  end

  if visited_nodes[node_id] then
    return
  end

  visited_nodes[node_id] = true

  local node = nodes[node_id]
  if not node then
    return
  end

  for _, child_id in ipairs(node.children) do
    local child_node = nodes[child_id]
    if not child_node then
      child_node = { children = {}, counter = 0 }
      nodes[child_id] = child_node
    end
    child_node.counter = child_node.counter + node.counter
    node_ids[#node_ids + 1] = child_id
  end
end

---@param start_node_id string
---@param nodes NodesPart1
local bfs_walk = function(start_node_id, nodes)
  local node_ids = { start_node_id }
  local visited_nodes = {}

  while #node_ids ~= 0 do
    bfs_walk_func(node_ids, nodes, visited_nodes)
  end
end

local main = function()
  ---@type NodesPart1
  local nodes = {}
  local start_node_id = "you"
  local end_node_id = "out"

  for line in io.lines() do
    local matcher = string.gmatch(line, "[^: ]+")

    local id = matcher()

    ---@type NodePart1
    local node = {
      children = {},
      counter = 0
    }

    for out in matcher do
      node.children[#node.children + 1] = out
    end

    nodes[id] = node
  end

  nodes[start_node_id].counter = 1

  bfs_walk(start_node_id, nodes)
  print(string.format("The number of possible ways between `%s` and `%s` is %d", start_node_id, end_node_id,
    nodes[end_node_id].counter))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
