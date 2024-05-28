local M = {}

local function hex2dec(hex)
  return tonumber(hex, 16)
end

local function dec2hex(dec, pad)
  pad = pad or 0
  return string.format("%0" .. pad .. "x", dec)
end

local function dec2hexColor(dec)
  return "#" .. dec2hex(dec, 6)
end

local function rgb2hex(r, g, b)
  return "#" .. dec2hex(r, 2) .. dec2hex(g, 2) .. dec2hex(b, 2)
end

local function rgb2dec(r, g, b)
  return bit.lshift(r, 16) + bit.lshift(g, 8) + b
end

local function splitHexColor(color)
  if color:len() == 4 then
    local r, g, b = color:match("^#(%x)(%x)(%x)$")
    return r, g, b
  end
  local r, g, b = color:match("^#(%x%x)(%x%x)(%x%x)$")
  return r, g, b
end

local function keyOf(tbl, value)
  for k, v in pairs(tbl) do
    if v == value then
      return k
    end
  end
  return nil
end

function M.color2hex(color)
  if color:sub(1, 1) == "#" then
    return color
  end
  local dec = vim.api.nvim_get_color_by_name(color)
  if dec < 0 then
    error("Invalid color name: " .. color)
  end
  return dec2hexColor(dec)
end

function M.color2rgb(color)
  color = M.color2hex(color)
  local r, g, b = splitHexColor(color)
  return hex2dec(r), hex2dec(g), hex2dec(b)
end

function M.rgb2color(r, g, b)
  local dec = rgb2dec(r, g, b)
  local colorMap = vim.api.nvim_get_color_map()
  local color = keyOf(colorMap, dec)
  if color then
    return color
  end
  return dec2hexColor(dec)
end

function M.rgb2hsv(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local c_max, c_min = math.max(r, g, b), math.min(r, g, b)
  local delta = c_max - c_min

  local h = 0
  if delta == 0 then
    h = 0
  elseif c_max == r then
    h = 60 * (((g - b) / delta) % 6)
  elseif c_max == g then
    h = 60 * (((b - r) / delta) + 2)
  elseif c_max == b then
    h = 60 * (((r - g) / delta) + 4)
  end
  local s = 0

  if c_max ~= 0 then
    s = delta / c_max
  end

  local v = c_max

  return h, s, v
end

function M.hsv2rgb(h, s, v)
  local c = v * s
  local x = c * (1 - math.abs((h / 60) % 2 - 1))
  local m = v - c

  local r, g, b = 0, 0, 0

  if 0 <= h and h < 60 then
    r, g, b = c, x, 0
  elseif 60 <= h and h < 120 then
    r, g, b = x, c, 0
  elseif 120 <= h and h < 180 then
    r, g, b = 0, c, x
  elseif 180 <= h and h < 240 then
    r, g, b = 0, x, c
  elseif 240 <= h and h < 300 then
    r, g, b = x, 0, c
  elseif 300 <= h and h < 360 then
    r, g, b = c, 0, x
  end

  return (r + m) * 255, (g + m) * 255, (b + m) * 255
end

function M.dimmed(rgbHex, factor)
  local r, g, b = M.color2rgb(rgbHex)
  local h, s, v = M.rgb2hsv(r, g, b)
  v = v * factor
  r, g, b = M.hsv2rgb(h, s, v)
  return M.rgb2color(r, g, b)
end

function M.get_hl_color(hl_group, attribute)
  local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_group)), attribute)
  if color == "" then
    return nil
  end
  return color
end

function M.set_hl_color(hl_group, attribute, color)
  local hl = vim.api.nvim_get_hl(0, { name = hl_group })
  hl[attribute] = color
  vim.api.nvim_set_hl(0, hl_group, hl)
end

return M
