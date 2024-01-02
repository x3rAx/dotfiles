local M = {}

local colorMap = {
    Black = "#000000",
    White = "#ffffff",
    Red = "#ff0000",
    Green = "#00ff00",
    Blue = "#0000ff",
    Yellow = "#ffff00",
    Magenta = "#ff00ff",
    Cyan = "#00ffff",
    Gray = "#808080",
    Grey = "#808080",
    LightGray = "#d0d0d0",
    LightGrey = "#d0d0d0",
    DarkGray = "#a9a9a9",
    DarkGrey = "#a9a9a9",
    LightRed = "#ffBBBB",
    LightGreen = "#90ee90",
    LightBlue = "#add8e6",
    LightYellow = "#ffffe0",
    LightMagenta = "#ffBBff",
    LightCyan = "#e0ffff",
    DarkRed = "#8b0000",
    DarkGreen = "#006400",
    DarkBlue = "#00008b",
    DarkYellow = "#bbbb00",
    DarkMagenta = "#8b008b",
    DarkCyan = "#008b8b",
}

local function hex2dec(hex)
    return tonumber(hex, 16)
end

function M.color2rgb(color)
    if colorMap[color] then
        color = colorMap[color]
    end
    local r, g, b = color:match("^#(%x%x)(%x%x)(%x%x)$")
    return hex2dec(r), hex2dec(g), hex2dec(b)
end

function M.rgb2color(r, g, b)
    local color = string.format("#%02x%02x%02x", r, g, b)
    for k, v in pairs(colorMap) do
        if v == color then
            return k
        end
    end
    return color
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

return M
