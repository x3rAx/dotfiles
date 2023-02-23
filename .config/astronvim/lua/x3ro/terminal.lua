local Terminal = require('toggleterm.terminal').Terminal

local term = Terminal:new({
        direction = 'horizontal',
    })

return {
    toggle = function() term:toggle() end
}
