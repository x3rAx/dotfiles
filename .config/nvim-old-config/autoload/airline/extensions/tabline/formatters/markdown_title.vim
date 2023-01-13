fun! s:isZetFile(name)
    let dir = fnamemodify(a:name, ':p:h')
    let zetDir = expand("~/Zettelkasten")

    let isSubDir = stridx(dir, zetDir) == 0
    if !isSubDir
        return 0
    endif

    let ext = fnamemodify(a:name, ':e')
    let isMarkdown = (ext == 'md')
    if !isMarkdown
        return 0
    endif

    let lines = getbufline(a:name, 1)
    if len(lines) == 0
        return 0
    endif

    let firstLine = lines[0]
    let hasMarkdownMeta = (firstLine == "---")

    return hasMarkdownMeta
endfun

fun! s:getTitle(name)
    let title = ''
    let found = 0

    let chunksize = 10
    let offset = 2
    let lines = getbufline(a:name, offset, chunksize)

    while (len(lines) > 0)
        for line in lines
            if line =~ '^title:'
                let found = 1
                let title = matchlist(lines, '^title: \([''"]\{0,1\}\)\(.*\)\1$')[2]
                break
            endif
            if line == '---'
                break
            endif
        endfor

        let offset = (offset + chunksize)
        let lines = getbufline(a:name, offset, offset+chunksize)
    endwhile

    return {'found': found, 'title': title}
endfun

fun! airline#extensions#tabline#formatters#markdown_title#format(bufnr, buffers)
    "let name = bufname(a:bufnr)
    "return  fnamemodify(name, ':p:h:t') . '/' . fnamemodify(name, ':t')

    let name = bufname(a:bufnr)

    if !s:isZetFile(name)
        return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
    endif

    let title = s:getTitle(name)

    if !title.found
        return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
    endif

    return a:bufnr . ': Z/[' . title.title . ']'
endfun

