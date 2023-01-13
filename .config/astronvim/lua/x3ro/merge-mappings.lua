-- Input to this function are multiple tables, each containing keys for normal (n), insert (i), visual (v) etc. mode.
-- Those keys hold tables with key mappings
return function(...)
  local mappings = {}

  -- First iterate all arguments
  for _, arg in ipairs({ ... }) do

    -- Merge each mode into the mapping table
    for mode, tbl in pairs(arg) do

      -- Create the mode in the mappings table if it does not exist
      if mappings[mode] == nil then
        mappings[mode] = {}
      end

      -- Add the mapping to the mappings table
      for key, val in pairs(tbl) do
        mappings[mode][key] = val
      end
    end
  end
  return mappings
end
