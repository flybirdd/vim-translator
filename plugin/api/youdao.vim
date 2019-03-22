" Maintainer: Rui Xiang
" Version: 1.0.0

if !exists("g:yd_url")
    let g:yd_url = "http://dict.youdao.com/suggest""
endif

function! api#youdao#Translator()

    let word = expand("<cword>")

    let queries = {"q": word, "num": "1", "le": "eng", "doctype": "json"}

    let result = json_decode(curl#Get(g:yd_url, queries))

    if result["result"]["code"] == 200
        let entries = result["data"]["entries"]
        echo entries[0]["explain"]
    else
        echo "Failed: '" . word . "' " . result["result"]["code"] . " " . result["result"]["msg"]
    endif
    
endfunction

