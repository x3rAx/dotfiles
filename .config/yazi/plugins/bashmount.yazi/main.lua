--- @sync entry
return {
    entry = function()
        if os.getenv('TMUX') then
            ya.manager_emit('shell', {
                interactive = false,
                'tmux popup -E -h90% bashmount'
            })
        else
            ya.manager_emit('shell', {
                interactive = false,
                block = true,
                'bashmount'
            })
        end
    end,
}
