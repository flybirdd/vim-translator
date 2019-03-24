" Maintainer: Rui Xiang
" Version: 1.0.0

function! word#UnderCursor()
    let cursor = col(".") - 1
    let line = getline(".") 

    let letter = "[a-zA-Z]" 
    
    let word = []
    
    let char = strcharpart(line, cursor, 1)
    if char =~ letter
        let word = add(word, char)
    else
        throw "'" . char . "' is not a letter"
    endif

    let next = cursor + 1
    let char = strcharpart(line, next, 1)
    while char =~ letter
        let word = add(word, char)

        let next = next + 1
        let char = strcharpart(line, next, 1)
    endwhile

    let back = cursor - 1
    let char= strcharpart(line, back, 1)
    while char =~ letter
        let word= insert(word, char, 0)

        let back = back - 1
        let char = strcharpart(line, back, 1)
    endwhile
    
    return join(word, "") 
    
endfunction
