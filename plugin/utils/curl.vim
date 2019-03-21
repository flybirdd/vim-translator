" Maintainer: Rui Xiang
" Version: 1.0.0

if exists('g:loaded_curl')
    finish
endif
let g:loaded_curl = 1

function! curl#Curl(method, url, argments, data)
    let a:http_method = toupper(a:method)
    if index(['GET', 'DELETE', 'HEAD', 'POST', 'PUT'], a:http_method) < 0
        echoerr "No such method ".a:method
        return -1
    endif
 
    let a:full_url = ""
    
    let a:full_url= a:full_url . a:url

    let a:queries=""
    for arg_key in keys(a:argments)
        if strlen(a:queries) == 0
            let a:queries = arg_key . "=" . a:argments[arg_key]
            continue
        endif
        let a:queries = a:queries . "&" . arg_key . "=" . a:argments[arg_key]
    endfor

    if strlen(a:queries) > 0
        let a:full_url = a:full_url . "?" . a:queries . " "
    endif

    let a:req_body=""
    if a:http_method == "POST" || a:http_method == "PUT"
        for data_key in keys(a:data)
            if strlen(a:req_body) == 0
                let a:req_body = data_key . "=" . a:data[data_key]
                continue
            endif
            let a:req_body = a:req_body . "&" . data_key . "=" . a:data[data_key]
        endfor
    endif

    let a:command = a:full_url

    if strlen(a:req_body) > 0
        let a:command = a:command . " --data " . shellescape(a:req_body)
    endif

    let a:message = system("curl -sSi " . a:command)

    if v:shell_error
        throw a:message
    endif

    let a:response = split(a:message, '\r\n')

    let a:http_code = a:response[0]
    if matchstr(a:http_code, "20") != 20
        throw a:http_code
    endif

    let a:body = ""
    for line_num in range(1, len(a:response) - 1) 
        if a:response[line_num] == ""
            let a:body = join(a:response[line_num + 1:], '\n')
        endif
    endfor
    
    return a:body
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
