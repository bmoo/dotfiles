call plug#begin()
Plug 'avakhov/vim-yaml' " autoindent yaml files
Plug 'fatih/vim-go' " go dev
Plug 'scrooloose/nerdtree' " file browser
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " code completion
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'} " more code completion
Plug 'ctrlpvim/ctrlp.vim' " quick search
Plug 'tpope/vim-fugitive' " git
Plug 'machakann/vim-highlightedyank' " highlight code to be yanked
Plug 'Mofiqul/vscode.nvim' " vscode theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator' " enable tmux keybinds while using vim
Plug 'lifepillar/vim-wwdc16-theme'
Plug 'ayu-theme/ayu-vim' " or other package manager
Plug 'rmagatti/auto-session'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" react
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

call plug#end()

set termguicolors     " enable true colors support
let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
colorscheme ayu

" basic stuff

set number
set mouse=a

" NERDTree
let NERDTreeShowHidden=1

" Prettier plugin
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html PrettierAsync

" ctrlp remap
let g:ctrlp_map = '<c-f>'
let g:ctrlp_cmd = 'CtrlP'

" colorscheme wwdc16
" colorscheme vscode
" vs-code color scheme
" For dark theme
" let g:vscode_style = "dark"
" For light theme
" let g:vscode_style = "light"
" Enable transparent background.
" let g:vscode_transparency = 1
" Enable italic comment
" let g:vscode_italic_comment = 1
" colorscheme dim


let mapleader = ","
map <leader>f :NERDTreeToggle<CR>

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

nnoremap gb :Git blame<CR>

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
nnoremap gr :GoReferrers<CR>

" vim-go settings
set autowrite
" Use new vim 8.2 popup windows for Go Doc
let g:go_doc_popup_window = 1
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

let g:go_metalinter_command = 'golangci-lint run --new-from-rev=origin/develop'
autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

" use go-imports to format
let g:go_fmt_command = "goimports"

" vim-go highlights
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_diagnostic_warnings = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_diagnostics_level = 2

" vim-go alternates
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

" Go debugging
let g:go_debug_windows = {
      \ 'vars':       'rightbelow 50vnew',
      \ 'stack':      'rightbelow 10new',
      \ }
      " \ 'goroutines':      'rightbelow 10new',
let g:go_debug_mappings = {
      \ '(go-debug-continue)': {'key': 'c', 'arguments': '<nowait>'},
      \ '(go-debug-next)': {'key': 'n', 'arguments': '<nowait>'},
      \ '(go-debug-step)': {'key': 's'},
      \ '(go-debug-print)': {'key': 'p'},
  \}
map <leader>ds :GoDebugStart<cr>
map <leader>dt :GoDebugTestFunc<cr>
map <leader>dd :GoDebugStop<cr>
map <leader>db :GoDebugBreakpoint<cr>

" Tab settings
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 
autocmd BufNewFile,BufRead *.js setlocal expandtab tabstop=2 shiftwidth=2

" Use deoplete.
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" import lua config
lua require('init')
