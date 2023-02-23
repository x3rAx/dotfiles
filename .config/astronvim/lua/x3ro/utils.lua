local M = {}

-- @tparam[opt='info'] string level
--local function alert(body, level)
--  level = level or 'info'
--  require('notify')(body, level, { title = "^x3ro" })
--end


M.contains = function(list, x)
  for _, v in ipairs(list) do
    if v == x then return true end
  end
  return false
end


M.count = function(list)
  local c = 0
  for _ in ipairs(list) do
    c = c + 1
  end
  return c
end


M.dumpVar = function(var, opts)
  opts = opts or {}
  local allTypes = opts.allTypes or false
  local pretty = opts.pretty or false
  local indent = opts.indent or 2
  local showType = opts.showType or false

  local _indent = opts._indent or 0

  local s

  function escape(str)
    return str
        :gsub("\\", "\\\\")
        :gsub("\n", "\\n")
        :gsub("\"", "\\\"")
  end

  if type(var) == 'string' then
    s = '"' .. escape(var) .. '"'
  elseif type(var) == 'boolean' then
    s = (var and "true" or "false")
  elseif type(var) == 'number' then
    s = tostring(var)
  elseif type(var) == 'table' then
    local nl = ' '
    local ind1 = ''
    local ind2 = ''
    if pretty then
      nl = "\n"
      ind1 = string.rep(' ', _indent)
      ind2 = string.rep(' ', _indent + indent)
    end

    s = '{' .. nl
    for k, v in pairs(var) do
      if type(k) ~= 'number' then
        k = '"' .. escape(k) .. '"'
      end
      s = s .. ind2 .. '[' .. k .. '] = '

      local tmp = M.dumpVar(v, {
        allTypes = allTypes,
        pretty = pretty,
        indent = indent,
        showType = showType,
        _indent = _indent + indent,
      })

      s = s .. tmp .. ',' .. nl
    end
    s = s .. ind1 .. '}'
  elseif type(var) == 'function' then
    showType = true
    if not pcall(function()
      s = "loadstring(require('ext.base64').decode(\""
          .. require('ext.base64').encode(string.dump(var))
          .. "\"))"
    end) then
      s = '"--function--"'
    end
  elseif type(var) == "nil" then
    s = 'nil'
  else
    showType = true
    s = '"--data--"'
  end

  if allTypes or showType then
    s = "--[[" .. type(var) .. "]] " .. s
  end

  return s
end


M.dumpVarToBuf = function(tbl)
  local win = vim.api.nvim_get_current_win()

  local listed = true
  local scratch = false
  local buf = vim.api.nvim_create_buf(listed, scratch)

  vim.api.nvim_win_set_buf(win, buf)

  local dump = M.dumpVar(tbl, { pretty = true })
  local lines = vim.split(dump, '\n', true)
  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, lines)

  --vim.opt_local.buftype = 'nofile'
  vim.bo.filetype = 'lua'
end


M.shallowcopy = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end


-- If this turns out to be insufficient, consider using this:
-- https://gist.github.com/3985043
M.deepcopy = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
    end
    setmetatable(copy, M.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end


-- Deep copy table with support for recursive tables.
M.deepcopy_recursive = function(orig, _copies)
  -- Save copied tables in `_copies`, indexed by original table.
  _copies = _copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if _copies[orig] then
      copy = _copies[orig]
    else
      copy = {}
      _copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[M.deepcopy_recursive(orig_key, _copies)] = M.deepcopy_recursive(orig_value, _copies)
      end
      setmetatable(copy, M.deepcopy_recursive(getmetatable(orig), _copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end


return M
