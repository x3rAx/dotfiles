local function limit_str_len(str, max_len)
  if str == nil then
    return nil
  end

  if #str <= max_len then
    return str
  end

  return string.sub(str, 1, max_len - 1) .. "…"
end

local function call_original_formatter(opts, entry, item)
  if not opts.formatting or not opts.formatting.format then
    return item
  end
  return opts.formatting.format(entry, item)
end

return {
  --- Limit width of cmp window
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        formatting = {
          format = function(entry, item)
            item = call_original_formatter(opts, entry, item)

            item.abbr = limit_str_len(item.abbr, 50)
            item.menu = limit_str_len(item.menu, 50)

            return item
          end,
        },
      })
    end,
  },
}
