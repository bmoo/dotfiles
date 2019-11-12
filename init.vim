call plug#begin()
Plug 'avakhov/vim-yaml'
Plug 'fatih/molokai'
Plug 'fatih/vim-go'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
Plug 'ayu-theme/ayu-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'sonph/onehalf'
call plug#end()

map <C-\> :NERDTreeToggle<CR>
set number
set mouse=a

" highlight substitutions
set inccommand=nosplit

" git
function! s:ToggleBlame()
    if &l:filetype ==# 'fugitiveblame'
        close
    else
        Gblame
    endif
endfunction

nnoremap gb :call <SID>ToggleBlame()<CR>

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
" fatih vim-go color scheme
" let g:rehash256 = 1
" let g:molokai_original = 1
" colorscheme molokai

" ayu color theme
" set termguicolors
" let ayucolor="light"
let g:airline_theme='onehalflight'
set background=light
colorscheme PaperColor

 
" vim-go auto type information
"let g:go_auto_type_info = 1
"set updatetime=100
" let g:go_debug = ["lsp"]
let g:go_info_mode = "gopls"
let g:go_def_mode = "gopls"

" vim-go quickfix hotkeys
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
let g:go_list_type = "quickfix" " only use quickfixes

" go callers
nnoremap gc :GoCallers<CR>

" vim-go settings
let mapleader = ","
set autowrite
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

" use go-imports to format
let g:go_fmt_command = "goimports"

" vim-go highlights
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1

" vim-go alternates
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

" make tab show as four spaces
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 

" gometalinter
" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
" let g:go_metalinter_autosave = 1
" let g:go_metalinter_deadline = "5s"


" Use deoplete.
let g:deoplete#enable_at_startup = 1
