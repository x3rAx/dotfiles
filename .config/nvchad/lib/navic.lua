local M = {}

function M.get_location(opts, bufnr)
    local navic = require('nvim-navic')
    local data = navic.get_data(bufnr) or {}

    -- Add current file to the top of the list
    table.insert(data, 1, {
        -- Get basename of current file
        name = vim.fn.fnamemodify(vim.fn.bufname(), ':t'),
        type = 'File',
        kind = 1,
        -- Make it clickable -> jump to top of file
        scope = {
            ['start'] = { line = 1, character = 0 },
            ['end'] = { line = 1, character = 0 },
        }
    })

    return navic.format_data(data, opts)
end

return M
