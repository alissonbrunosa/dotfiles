" Ruby

if exists("b:did_ftplugin")
  finish
endif

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set fileformat=unix

function! s:handler_output(ch, output, ...)
  let result = split(a:output, "\n")
  cexpr result
  cw
  wincmd w
endfunction

function! s:clean(job, exit_status)
  if a:exit_status == 0
    cclose
  endif
endfunction

function! s:run_job(cmd)
  if exists("s:job")
    if job_status(s:job) == "dead"
      unlet s:job
    else
      return 0
    endif
  endif

  let s:job = job_start(a:cmd, { "mode": "raw", "out_cb": function("s:handler_output"), "exit_cb": function("s:clean") })
endfunction

function! s:check_rubocop()
  let extension = expand('%:e')
  if extension != 'rb'
    return
  endif

  let cmd = 'bundle exec rubocop '. @% . ' --format emacs'
  call s:run_job(cmd)
endfunction

function! s:fix_offenses()
  let cmd = 'bundle exec rubocop '. @% . ' --format emacs --auto-correct'
  call s:run_job(cmd)
endfunction

augroup actions
  autocmd!
  autocmd BufWritePost * call s:check_rubocop()
augroup END

command! -nargs=0 RuboCop :call <SID>fix_offenses()

nnoremap <Leader>rcf :RuboCop<CR>
