local main = function()
  local problems_raw = {}
  local operators = {}
  local lines_count = 0
  local sum = 0

  for line in io.lines() do
    lines_count = lines_count + 1
    local i = 1
    local is_last = false

    for c in string.gmatch(line, ".") do
      if c == "*" or c == "+" then
        is_last = true
        operators[#operators + 1] = { c, i }
      end

      if is_last == false then
        if problems_raw[i] == nil then
          problems_raw[i] = {}
        end
        problems_raw[i][#problems_raw[i] + 1] = c
      end
      i = i + 1
    end
  end

  for i = 1, #operators do
    local operator = operators[i][1]
    local operator_start = operators[i][2]
    local operator_end = ((operators[i + 1] or {})[2] or (#problems_raw + 2)) - 2

    local problem_sum = 0
    if operator == "*" then
      problem_sum = 1
    end

    for j = operator_start, operator_end do
      local number = tonumber(table.concat(problems_raw[j]))
      if number == nil then
        -- no op
      elseif operator == "*" then
        problem_sum = problem_sum * number
      else
        problem_sum = problem_sum + number
      end
    end
    sum = sum + problem_sum
  end
  print(string.format("The grand total is %d", sum))
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
