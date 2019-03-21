" Maintainer: Rui Xiang
" Version: 1.0.0

if exists('g:loaded_curl')
    finish
endif
let g:loaded_curl = 1

function! curl#Curl(method, url, argments, data)
    let http_method = toupper(a:method)
    if index(['GET', 'DELETE', 'HEAD', 'POST', 'PUT'], http_method) < 0
        echoerr "No such method ". a:method
        return -1
    endif
 
    let full_url = a:url

    let queries=""
    for arg_key in keys(a:argments)
        if strlen(queries) == 0
            let queries = arg_key . "=" . a:argments[arg_key]
            continue
        endif
        let queries = queries . "&" . arg_key . "=" . a:argments[arg_key]
    endfor

    if strlen(queries) > 0
        let full_url = full_url . "?" . queries . " "
    endif

    let req_body=""
    if http_method == "POST" || http_method == "PUT"
        for data_key in keys(a:data)
            if strlen(req_body) == 0
                let req_body = data_key . "=" . data[data_key]
                continue
            endif
            let req_body = req_body . "&" . data_key . "=" . data[data_key]
        endfor
    endif

    let command = shellescape(full_url)
    if strlen(req_body) > 0
        let command = command . " --data " . shellescape(req_body)
    endif

    let message = system("curl -sSi " . command)

    if v:shell_error
        throw message
    endif

    let response = split(message, '\r\n')

    let http_code = response[0]
    if matchstr(http_code, "20") != 20
        throw http_code
    endif

    let body = ""
    for line_num in range(1, len(response) - 1) 
        if response[line_num] == ""
            let body = join(response[line_num + 1:], '\n')
        endif
    endfor
    
    return body
endfunction

function! curl#Get(url, argments)
    return curl#Curl("GET", a:url, a:argments, {})
endfunction

function! curl#Post(url, argments, data)
    return curl#Curl("POST", a:url, a:argments, a:data)
endfunction

function! curl#Put(url, argments, data)
    return curl#Curl("PUT", a:url, a:argments, a:data)
endfunction

function! curl#Delete(url, argments)
    return curl#Curl("DELETE", a:url, a:argments, {})
endfunction
