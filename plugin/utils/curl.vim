" Maintainer: Rui Xiang
" Version: 1.0.0

if exists('g:loaded_curl')
    finish
endif
let g:loaded_curl = 1

if !exists("g:curl_headers")
    let g:curl_headers = {}
endif

function! curl#Curl(method, url, argments, data)
    let a:http_method = toupper(a:method)
    if index(['GET', 'DELETE', 'HEAD', 'POST', 'PUT'], a:http_method) < 0
        echoerr "No such method ".a:method
        return -1
    endif

    let a:command = ""
    
    for header_key in keys(g:curl_headers)
        let a:command += "-H " . header_key . " " . g:curl_headers[header_key] . " "
    endfor

    let a:command = a:command . a:url

    let a:queries=""
    for arg_key in keys(a:argments)
        if strlen(a:queries) == 0
            let a:queries = arg_key . "=" . a:argments[arg_key]
            continue
        endif
        let a:queries = a:queries . "&" . arg_key . "=" . a:argments[arg_key]
    endfor

    if strlen(a:queries) > 0
        let a:command = a:command . "?" . a:queries . " "
    endif

    let a:body=""
    if a:http_method == "POST" || a:http_method == "PUT"
        for data_key in keys(a:data)
            if strlen(a:body) == 0
                let a:body = data_key . "=" . a:data[data_key]
                continue
            endif
            let a:body = a:body . "&" . data_key . "=" . a:data[data_key]
        endfor
    endif

    if strlen(a:body) > 0
        let a:command = a:command . "--data " . a:body
    endif

    let a:response = system("curl " . shellescape(a:command))

    return join(split(a:response, "\n")[3:], "\n")
endfunction

function! curl#Get(url, argments)
    return curl#Curl("GET", a:url, a:argments, {})
endfunction

function! curl#Post(url, argments, data)
    return curl#Curl("POST", a:url, a:argments, a:data)
endfunction

