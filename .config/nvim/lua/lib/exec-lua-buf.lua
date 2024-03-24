return function()
  -- Get the current buffer's content
  local code = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Concatenate the lines to form a single string
  local lua_code = table.concat(code, "\n")

  -- Execute the Lua code
  local success, result = pcall(load(lua_code))

  -- Handle any errors
  if not success then
    print("Error executing Lua code:")
    print(result)
  end
end
