-- Sort Nix packages by name
--
-- In a nix file, the list of packages may not only contain the plain package
-- names. It may also contain things like `unstable.<package-name>` or
-- `pythonPackages.<package-name>`.
--
-- This function will sort the list of packages by the part after the last
-- period. If no period is found, the entire line will be used as the sort
-- key.
--
-- BTW: The same could be acieved doing the following:
--
-- ```
-- Vip                                  # Select visual block
-- :'<,'>s/\v(.*\.|\s*)?(.+)$/\2\t\1\2  # Add sort key to each line
-- gv                                   # Restore previous selection
-- :'<,'>sort                           # Sort the lines
-- gv                                   # Restore previous selection
-- :'<,'>s/^.\{-}\t//                   # Remove the sort keys
-- ```
--
return function(args)
  if args.range == 0 then
    vim.notify("Please select a range", vim.log.levels.WARN)
    return
  end

  -- Get the selected lines
  -- local start_line = vim.fn.line("'<")
  -- local end_line = vim.fn.line("'>")
  local start_line = args.line1
  local end_line = args.line2

  -- Get the lines from the buffer in the visual selection
  local lines = vim.fn.getline(start_line, end_line)

  -- Create a table to store keys and their original indices
  local keys_with_indices = {}

  -- Function to get the part after the last period or the entire line if no period
  local function get_sort_key(line)
    -- Remove comment symbol at the beginning of the line (commented out packages should be sorted as if they were not commented out)
    line = line:gsub("^(%s*)#(.*)$", "%1%2")
    -- Remove comments at the end of the line (prevent false sorting when comment contains a `.`)
    line = line:gsub("^(.*)#.*$", "%1")

    local package_name_pos = line:match("^.*%.()") or line:match("^%s*()") or 0
    if package_name_pos > 0 then
      return line:sub(package_name_pos)
    else
      return line
    end
  end

  -- Build the key and index table
  for i, line in ipairs(lines) do
    local key = get_sort_key(line)
    table.insert(keys_with_indices, { index = i, key = key, line = line })
  end

  -- Sort the keys, tracking the original indices
  table.sort(keys_with_indices, function(a, b)
    return a.key < b.key --and a.line < b.line
  end)

  -- Rearrange the lines based on the sorted indices
  local sorted_lines = {}
  for _, item in ipairs(keys_with_indices) do
    table.insert(sorted_lines, lines[item.index])
  end

  -- Replace the buffer lines with the sorted result
  vim.fn.setline(start_line, sorted_lines)

  print("Sorted " .. #lines .. " packages in range", start_line, end_line)
end
