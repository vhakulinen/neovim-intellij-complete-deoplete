if exists("g:intellij_loaded")
    finish
endif
let g:intellij_loaded = 1

function! IntellijCodeSmell()
    call setqflist([])
    let smells = rpcrequest(g:intellijID, "IntellijCodeSmell", expand("%:p"), getline(0, '$'))
    if len(smells) > 0
        for smell in smells
            caddexpr expand("%") . ":" . (smell['line'] + 1) . ":" . (smell['column'] + 1) . ":" . smell['text']
        endfor
        copen
    endif
endfunction

function! IntellijGetProblems()
    let problems = rpcrequest(g:intellijID, "IntellijProblems", expand("%:p"), getline(0, '$'), line('.') - 1, col('.'))
    if len(problems) == 0
        return
    endif
    let out = ''
    for problem in problems
        let out .= problem['fixId'] . ':' . problem['description'] . "\n"
    endfor
    echo out

    let a = input("Select one: ")

    let found = 0
    for problem in problems
        if problem['fixId'] == a
            call rpcnotify(g:intellijID, "IntellijFixProblem", expand("%:p"), getline(0, '$'), a)
            echo "Executed fix '" . problem['description'] . "'"
            let found = 1
            break
        endif
    endfor
    if found == 0
        echo "Invalid choise"
    else
        sleep 500 m
        e!
    endif
endfunction
