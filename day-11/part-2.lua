---@alias Counters {all: integer, dac: integer, fft: integer, dac_and_fft: integer}
---@alias NodePart2 { children: string[], counters: Counters, parents: string[]}
---@alias NodesPart2 table<string, NodePart2>

local bfs_walk_func = function(node_ids, nodes, visited_nodes)
  local node_id = table.remove(node_ids, 1)
  if not node_id then
    return
  end

  local node = nodes[node_id]
  if not node then
    return
  end


  for _, parent_id in ipairs(node.parents) do
    if not visited_nodes[parent_id] then
      node_ids[#node_ids + 1] = node_id
      return
    end
  end

  if visited_nodes[node_id] then
    return
  end

  visited_nodes[node_id] = true


  if node_id == "dac" then
    node.counters.dac = node.counters.all
    node.counters.dac_and_fft = node.counters.fft
  end

  if node_id == "fft" then
    node.counters.fft = node.counters.all
    node.counters.dac_and_fft = node.counters.dac
  end


  for _, child_id in ipairs(node.children) do
    local child_node = nodes[child_id]
    if not child_node then
      child_node = {
        children = {},
        parents = {},
        counters = {

          all = 0,
          dac = 0,
          dac_and_fft = 0,
          fft = 0
        }
      }
      nodes[child_id] = child_node
    end
    child_node.counters.all = child_node.counters.all + node.counters.all
    child_node.counters.dac = child_node.counters.dac + node.counters.dac
    child_node.counters.dac_and_fft = child_node.counters.dac_and_fft + node.counters.dac_and_fft
    child_node.counters.fft = child_node.counters.fft + node.counters.fft

    node_ids[#node_ids + 1] = child_id
  end
end

---@param start_node_id string
---@param nodes NodesPart2
local bfs_walk = function(start_node_id, nodes)
  local node_ids = { start_node_id }
  local visited_nodes = {}

  while #node_ids ~= 0 do
    bfs_walk_func(node_ids, nodes, visited_nodes)
  end
end

local main = function()
  ---@type NodesPart2
  local nodes = {}
  local start_node_id = "svr"
  local end_node_id = "out"

  for line in io.lines() do
    local matcher = string.gmatch(line, "[^: ]+")

    local id = matcher()

    ---@type NodePart2
    local node = {
      children = {},
      parents = {},
      counters = {
        all = 0,
        dac = 0,
        dac_and_fft = 0,
        fft = 0
      }
    }

    for out in matcher do
      node.children[#node.children + 1] = out
    end

    nodes[id] = node
  end

  for node_id, node in pairs(nodes) do
    for _, child_id in ipairs(node.children) do
      local child_node = nodes[child_id]
      if child_node then
        child_node.parents[#child_node.parents + 1] = node_id
      end
    end
  end

  nodes[start_node_id].counters.all = 1

  bfs_walk(start_node_id, nodes)

  print(string.format("The number of possible ways between `%s` and `%s` is %d", start_node_id, end_node_id,
    nodes[end_node_id].counters.dac_and_fft))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
