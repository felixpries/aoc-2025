local input = io.read()

local result = 0

local is_valid_product_id = function(product_id)
  local product_id_string = tostring(product_id)
  local length = #product_id_string

  if length % 2 == 1 then
    return
  end

  local first_half = string.sub(product_id_string, 1, length // 2)
  local second_half = string.sub(product_id_string, (length // 2) + 1, nil)

  return first_half == second_half
end


for product_id_range in string.gmatch(input, "([^,]+)") do
  local product_id_matcher = string.gmatch(product_id_range, "([0-9]+)")
  local start_product_id = tonumber(product_id_matcher())
  local end_product_id = tonumber(product_id_matcher())

  for product_id = start_product_id, end_product_id do
    if is_valid_product_id(product_id) then
      result = result + product_id
    end
  end
end

print(result)
