local main = function()
  for line in io.lines() do
    print(line)
  end
end



local before = os.clock()
main()
local after = os.clock()

print(string.format("It took %0.6f seconds to run", after - before))
