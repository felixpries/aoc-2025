local main = function()
  local problems = {}
  local sum = 0

  for line in io.lines() do
    local i = 1
    for match in string.gmatch(line, "([^ ]+)") do
      if problems[i] == nil then
        problems[i] = {}
      end
      problems[i][#problems[i] + 1] = match
      i = i + 1
    end
  end

  for i = 1, #problems do
    local problem = problems[i]
    local operator = problem[#problem]

    local problem_sum = 0
    if operator == "*" then
      problem_sum = 1
    end

    for j = 1, #problem - 1 do
      local number = tonumber(problem[j])
      if operator == "*" then
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
