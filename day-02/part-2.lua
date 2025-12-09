local input = io.read()

local result = 0

local is_repeating_n_times = function(product_id, num_parts)
  local length = #product_id
  local substring_inital = nil

  for part_index = 0, (length // num_parts) - 1 do
    local substring = string.sub(product_id, (num_parts * part_index) + 1, (num_parts * (part_index + 1)))

    if not substring_inital then
      substring_inital = substring
    elseif substring_inital ~= substring then
      return false
    end
  end
  return true
end

local is_valid_product_id = function(product_id)
  local product_id_string = tostring(product_id)
  local length = #product_id_string
  for num_parts = 1, length // 2 do
    if length % num_parts == 0 then
      if is_repeating_n_times(product_id_string, num_parts) then
        return true
      end
    end
  end
  return false
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
