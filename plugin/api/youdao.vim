" Maintainer: Rui Xiang
" Version: 1.0.0

if !exists("g:yd_url")
    let g:yd_url = "http://dict.youdao.com/suggest""
endif

function! api#youdao#Translator()
    let a:queries = {"q": expand("<cword>"), "num": "1", "le": "eng", "doctype": "json"}
    let a:result = json#Parse(curl#Get(g:yd_url, a:queries))

    if a:result["result"]["code"] == 200
        let a:entries = a:result["data"]["entries"]
        echo a:entries[0]['explain']
    else
        echo "Translatored failed."
    endif
endfunction

