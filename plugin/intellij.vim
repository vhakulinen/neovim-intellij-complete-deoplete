if exists("g:intellij_loaded")
    finish
endif
let g:intellij_loaded = 1

function! IntellijCodeSmell()
    call setqflist([])
    let smells = rpcrequest(g:intellijID, "IntellijCodeSmell", expand("%:p"), getline(0, '$'))
    for smell in smells
        caddexpr expand("%") . ":" . smell['line'] . ":" . smell['column'] . ":" . smell['text']
    endfor
    copen
endfunction
