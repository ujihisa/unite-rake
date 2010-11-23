let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {'name': 'rake'}

function! s:unite_source.gather_candidates(args, context)
  let result = unite#util#system('rake -sT')
  if unite#util#get_last_status()
    echoerr 'No Rakefile in current directory'
    return []
  endif
  return map(
        \ map(split(result, '\n'), "[split(v:val, '\\s\\+#')[0], v:val]"),
        \ '{
        \ "word": v:val[0],
        \ "abbr": substitute(v:val[1], "^rake ", "", ""),
        \ "source": "rake",
        \ "kind": "command",
        \ "action__command": "VimProcBang " . v:val[0],
        \ }')
endfunction

let vimshellinteractive = {}
function! vimshellinteractive.func(x)
  execute 'VimShellInteractive' a:x.word
endfunction
call unite#custom_action('source/rake/*', 'vimshellinteractive', vimshellinteractive)

"let vimshellsendstring = {}
"function! vimshellsendstring.func(x)
"  execute 'VimShellSendString' a:x.word
"endfunction
"call unite#custom_action('source/rake/*', 'vimshellsendstring', vimshellsendstring)

function! unite#sources#rake#define()
  return executable('rake') ? s:unite_source : []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
