---@alias IntegerSet table<integer, boolean>
---
---@alias MachineSchematicPart1 {
---  light_diagram: string,
---  initial_state: boolean[],
---  button_wirings: IntegerSet[],
---}


local parse_machine_schematics = function()
  ---@type MachineSchematicPart1[]
  local machine_schematics = {}

  for line in io.lines() do
    local matcher = string.gmatch(line, "[^ ]+")

    ---@type MachineSchematicPart1
    local machine_schematic = {
      initial_state = {},
      button_wirings = {},
    }
    local light_diagram = matcher()
    machine_schematic.light_diagram = string.sub(light_diagram, 2, #light_diagram - 1)

    for i, v in ipairs({ string.byte(machine_schematic.light_diagram, 1, -1) }) do
      machine_schematic.initial_state[i] = false
    end


    for match in matcher do
      if string.sub(match, 1, 1) == "(" then
        ---@type IntegerSet
        local wires = {}
        for wire in string.gmatch(match, "%d+") do
          wires[tonumber(wire)] = true
        end
        machine_schematic.button_wirings[#machine_schematic.button_wirings + 1] = wires
      end
    end
    machine_schematics[#machine_schematics + 1] = machine_schematic
  end

  return machine_schematics
end

---@param initial_state boolean[]
---@param wiring IntegerSet
---@return boolean[]
local push_button = function(initial_state, wiring)
  local next_state = {}

  for i, v in ipairs(initial_state) do
    if wiring[i - 1] then
      next_state[i] = not v
    else
      next_state[i] = v
    end
  end

  return next_state
end

local state_to_string = function(state)
  local m = {}
  for i, v in ipairs(state) do
    m[i] = v and "#" or "."
  end

  return table.concat(m)
end


local wiring_to_string = function(wiring)
  local temp = {}
  for k, _ in pairs(wiring) do
    temp[#temp + 1] = k
  end
  return table.concat(temp)
end

---@param machine_schematic MachineSchematicPart1
local get_min_for_schematic = function(machine_schematic)
  local seen_states = { [state_to_string(machine_schematic.initial_state)] = true }

  local states_to_process = { machine_schematic.initial_state }

  local iteration = 1
  while #states_to_process >= 1 do
    local next_states_to_process = {}
    for _, state_to_process in ipairs(states_to_process) do
      for _, wiring in ipairs(machine_schematic.button_wirings) do
        local next_state = push_button(state_to_process, wiring)
        local state_string = state_to_string(next_state)

        if state_string == machine_schematic.light_diagram then
          return iteration
        end

        if not seen_states[state_string] then
          seen_states[state_string] = true
          next_states_to_process[#next_states_to_process + 1] = next_state
        end
      end
    end
    iteration = iteration + 1
    states_to_process = next_states_to_process
  end

  return 0
end

local main = function()
  local machine_schematics = parse_machine_schematics()

  local min_sum = 0


  for _, machine_schematic in ipairs(machine_schematics) do
    local min = get_min_for_schematic(machine_schematic)
    min_sum = min_sum + min
  end

  print(string.format("The result is %d", min_sum))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
