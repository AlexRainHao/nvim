let g:python3_host_prog = '/usr/local/bin/python3'
if has('python3')
    silent! python3 1
endif
" Configuration file for vim
set modelines=0     " CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility " remove change the following statements
set nocompatible    " Use Vim defaults instead of 100% vi compatibility
set backspace=2     " more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

let skip_defaults_vim=1
let g:vim_json_conceal=0
let g:vim_json_syntax_conceal = 0

set foldmethod=indent
set foldlevel=99
set foldenable

" rowNumber
set nu
" highLight
syntax on

set cursorline
set showcmd
set wrap
set wildmenu

set scrolloff    =7

" tab indent
set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set smarttab
set tabstop      =4
set shiftwidth   =4        " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set softtabstop  =4        " Tab key indents by 4 spaces.

set list
set listchars=tab:‣\ ,trail:▫,precedes:«,extends:»

" encoding
set encoding=utf-8
set hidden
set nocp
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set relativenumber number
set timeoutlen=500
set statusline+=%F
set laststatus=2
set hlsearch
set incsearch
set ignorecase
set smartcase

" mouse yank
" alt+mouse while selection could disable it, and then copied to system-os
" clipboard in `mac-os`
set mouse=a
"set clipboard=unnamed
"  "clipboard
if has("clipboard")
    if has("unnamedplus")
    " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else
    " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" history restore
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
set backupdir=~/.config/nvim/tmp/backup
set directory=~/.config/nvim/tmp/backup
if has('persistent_undo')
    set undofile
    set undodir=~/.config/nvim/tmp/undo
endif

" indentLine
let g:indentLine_char = '┆'
let g:indentLine_color_term = 238
let g:indentLine_color_gui  = '#333333'
let g:indentLine_enabled    = 1
let g:indentLine_setConceal = 1
let g:netrw_keepdir = 0
let g:netrw_fastbrowse = 0

" ----------------
"  Theme
let g:onedark_termcolors=256
let g:airline_theme='everforest'

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Enable true color 启用终端24位色
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

syntax on

" ----------------
"  Keybinds
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

let mapleader="\<space>"
inoremap jk <esc>

" noremap <Up> <NOP>
" noremap <Down> <NOP>
" noremap <Left> <NOP>
" noremap <Right> <NOP>

map <up> :res -5<CR>
map <down> :res +5<CR>
map <left> :vertical resize -5<CR>
map <right> :vertical resize +5<CR>

map <Space><Space> <Esc>/<++><CR>:nohlsearch<CR>c4l

inoremap <c-k> <c-o>d$
inoremap <c-d> <c-o>s

map tu :tabe<CR>
"map gt$ :tabl<CR>
"map gt0 :tabfir<CR>

nmap Q :q<CR>
nmap <leader>Q :q!<CR>
nmap W :w<CR>
nmap <Leader>W :wa<CR>

nmap <M-C-d> $a;<Esc>o
imap <M-C-d> <Esc>:call nvim_input("<M-C-d>")<CR>

nmap <M-]> :tabn<CR>
nmap <M-[> :tabp<CR>

" terminal behavior
let g:neoterm_autoscroll=1

autocmd TermOpen term://* startinsert

func! OpenARightTerm(direction)
    if a:direction == "l"
        set splitright
        :vs
    elseif a:direction == "j"
        set splitbelow
        :sp
    endif
    :term
endfunc

nmap <silent> <leader>Tl :call OpenARightTerm("l")<CR>
nmap <silent> <leader>Tj :call OpenARightTerm("j")<CR>
tnoremap <Esc> <C-\><C-n>

" noremap <Leader>qq ciw""<Esc>P
" noremap <Leader>qu di"hPl2x
" noremap <Leader>qr ciw${}<Esc>P

" run code
" " Compile function
noremap <Leader>R :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		set splitbelow
		:sp
		:res -5
		term gcc % -o %< && time ./%<
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!clang++ -std=c++11 % -Wall -g -o %<"
		:sp
		:res -10
		:term ./%<
	elseif &filetype == 'cs'
		set splitbelow
		silent! exec "!mcs %"
		:sp
		:res -5
		:term mono %<.exe
	elseif &filetype == 'java'
		set splitbelow
		:sp
		:res -5
		term javac % && time java %<
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
        :res -10
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "InstantMarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
		silent! exec "CocCommand flutter.dev.openDevLog"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'racket'
		set splitbelow
		:sp
		:res -5
		term racket %
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run .
	endif
endfunc

" =====================
" lazygit
" =====================
noremap <c-g> :tabe<CR>:-tabmove<CR>:term lazygit<CR>

" =====================
" NERDTree
" =====================
" autocmd VimEnter * NERDTree
" autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"nnoremap <Leader>nn :NERDTreeFocus<CR>
nnoremap <Leader>nn :silent! NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>

" =====================
" FZF.vim
" =====================
let g:fzf_buffers_jump=1
let g:fzf_layout = {'down':'40%'}

imap<c-x><c-k> <plug>(fzf-complete-word)
imap<c-x><c-f> <plug>(fzf-complete-path)
imap<c-x><c-l> <plug>(fzf-complete-buffer-line)

command! -nargs=? -bang -complete=dir Files
        \ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : {}, <bang>0)

"FZF Buffer Delete

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>p :Files<CR>
nnoremap <silent> <leader>P :Files!<CR>
"nnoremap <silent> <leader>t :Tags<CR>
nnoremap <silent> <leader>w :Buffers<CR>
nnoremap <silent> <leader>b :BLines<CR>
nnoremap <silent> <leader>B :Lines<CR>
nnoremap <silent> <leader>rg :Rg<CR>
nnoremap <silent> <leader>bb :BD<CR>

" =====================
" Cheat40
" =====================
nnoremap <Leader>? :Cheat40

" =====================
" Tagbar
" =====================
nmap <silent> <Leader><C-t> :TagbarToggle<CR>

" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.local/share/nvim/plugged/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes --sro=»',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '»',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" YMC
let g:ycm_use_clangd = 0

" =====================
" MarkdownPreview
" =====================
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0
" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/10
" default empty
let g:mkdp_open_ip = ''

let g:mkdp_browser = ''
let g:mkdp_echo_preview_url = 0

let g:mkdp_browserfunc = ''

let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

let g:mkdp_markdown_css = ''

let g:mkdp_highlight_css = ''

let g:mkdp_port = ''

let g:mkdp_page_title = '「${name}」'

let g:mkdp_filetypes = ['markdown']

let g:mkdp_theme = 'everforest'


" =====================
" NerdTree-git
" =====================
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

" =====================
" vim-indent-guides
" =====================
let g:indent_guides_enable_on_vim_startup = 0

let g:TableModeToggle = "<leader>tm"
let g:table_mode_relign_map = '<Leader>trr'
let g:table_mode_delete_column_map = '<Leader>tdcc'
let g:table_mode_insert_column_before_map = '<Leader>ticC'
let g:table_mode_insert_column_after_map = '<Leader>ticc'

" =====================
" vim-signature
" =====================
let g:SignatureMap = {
        \ 'Leader'             :  "m",
        \ 'PlaceNextMark'      :  "m,",
        \ 'ToggleMarkAtLine'   :  "m.",
        \ 'PurgeMarksAtLine'   :  "dm-",
        \ 'DeleteMark'         :  "dm",
        \ 'PurgeMarks'         :  "dm/",
        \ 'PurgeMarkers'       :  "dm?",
        \ 'GotoNextLineAlpha'  :  "m<LEADER>",
        \ 'GotoPrevLineAlpha'  :  "",
        \ 'GotoNextSpotAlpha'  :  "m<LEADER>",
        \ 'GotoPrevSpotAlpha'  :  "",
        \ 'GotoNextLineByPos'  :  "",
        \ 'GotoPrevLineByPos'  :  "",
        \ 'GotoNextSpotByPos'  :  "mn",
        \ 'GotoPrevSpotByPos'  :  "mp",
        \ 'GotoNextMarker'     :  "",
        \ 'GotoPrevMarker'     :  "",
        \ 'GotoNextMarkerAny'  :  "",
        \ 'GotoPrevMarkerAny'  :  "",
        \ 'ListLocalMarks'     :  "m/",
        \ 'ListLocalMarkers'   :  "m?"
        \ }

" =====================
" delimitmate
" =====================

let delimitMate_matchpairs ='(:),[:],{:}'

" =====================
" vim-closetag
" =====================
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

" =====================
" emmet.vim
" =====================
" let g:user_emmet_mode="n"
let g:user_emmet_leader_key="~"

imap <Leader>ee ~,
map <Leader>ee ~,

imap <Leader>en ~n
map <Leader>en ~n

imap <Leader>eN ~N
map <Leader>eN ~N

imap <Leader>ek ~k
map <Leader>ek ~k

imap <Leader>ed ~d
map <Leader>ed ~d

imap <Leader>eD ~D
map <Leader>eD ~D

imap <Leader>ej ~j

" =====================
" coc.nvim
" =====================
"
let g:coc_global_extentions = [
        \ "coc-json",
        \ "coc-css",
        \ "coc-prettier",
        \ "coc-yaml",
        \ "coc-pyright",
        \ "coc-cmake",
        \ "coc-volar",
        \ "coc-clangd",
        \ "coc-tsserver",
        \ "coc-docker",
        \ "coc-yank",
        \ "coc-snippets",
        \ "coc-marksman", 
        \ "coc-go" ]

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-p> coc#refresh()
else
  inoremap <silent><expr> <c-p> coc#refresh()
endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent><leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
nmap <leader>ff  :call CocAction("format")<CR>

" Coc-Yank
nnoremap <silent> <Leader>Y :<C-u>CocList -A --normal yank<cr>

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-sele)

" Show all diagnostics
nnoremap <silent><nowait> <space>oa  :<C-u>CocList diagnostics<cr>
" Show commands
nnoremap <silent><nowait> <space>oc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>oo  :<C-u>CocList outline<cr>

" =====================
" golang lsp
" =====================
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

autocmd FileType go nmap <M-g>fi :CocCommand go.test.generate.file<cr>
autocmd FileType go nmap <M-g>fu :CocCommand go.test.generate.function<cr>
autocmd FileType go nmap <M-g>ff :CocCommand go.test.toggle<cr>

" =====================
" vimspector
" =====================
let g:vimspector_enable_mappings="HUMAN"
let g:vimspector_variables_display_mode = 'full'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB', 'vscode-bash-debug' ]

function! s:read_template_into_buffer(template)
	" has to be a function to avoid the extra space fzf#run insers otherwise
	execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
			\   'source': 'ls ~/.config/nvim/sample_vimspector_json',
			\   'down': 20,
			\   'sink': function('<sid>read_template_into_buffer')
			\ })

nmap <leader>f5 :w :call vimspector#Launch()<CR>
nmap <leader>d<f5> :VimspectorReset<CR>
nmap <leader>vw :VimspectorWatch
nmap <leader>ve :VimspectorEval
nmap <leader>vi <Plug>VimspectorBalloonEval
xmap <leader>vi <Plug>VimspectorBalloonEval
nmap <leader>vr <Plug>VimspectorRestart

" =====================
" semshi
" =====================
let g:semshi#filetypes = ['python']
let g:semshi#error_sign = 'false'

function MyCustomHighlights()
    hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f
endfunction
autocmd FileType python call MyCustomHighlights()

" =====================
" vim-instant-markdown
" =====================
" let g:instant_markdown_slow = 0
let g:instant_markdown_autostart = 0
 let g:instant_markdown_open_to_the_world = 1
" let g:instant_markdown_allow_unsafe_content = 1
" let g:instant_markdown_allow_external_content = 0
" let g:instant_markdown_mathjax = 1
let g:instant_markdown_autoscroll = 1
let g:instant_markdown_logfile='/tmp/instant_markdown.log'
" =====================
" undotree
" =====================
nmap <Leader>U :UndotreeToggle<CR>

" =====================
" far.vim
" =====================
set lazyredraw            " improve scrolling performance when navigating through large results
set regexpengine=1        " use old regexp engine
set ignorecase smartcase  " ignore case only when the pattern contains no capital letters
let g:far#enable_undo = 1
let g:far#debug = 0

" =====================
" ultisnips
" =====================
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
" let g:UltiSnipsSnippetDirectories = [$HOME.'/.config/nvim/Ultisnips/', $HOME.'/.config/nvim/plugged/vim-snippets/UltiSnips/']
" silent! au BufEnter,BufRead,BufNewFile * silent! unmap <c-r>
" " Solve extreme insert-mode lag on macOS (by disabling autotrigger)
" augroup ultisnips_no_auto_expansion
"     au!
"     au VimEnter * au! UltiSnips_AutoTrigger
" augroup END
"
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
"
" =====================
" coc-snippets
" =====================
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" =====================
" wildfire
" =====================
nmap <leader>s <Plug>(wildfire-quick-select)

" =====================
" nerdcommenter
" =====================
let g:NERDAltDelims_java = 0
let g:NERDCustomDelimiters = { 'javascript': { 'left': '// ', 'leftAlt': '/**','rightAlt': '*/' } }
map <leader>/<leader> <plug>NERDCommenterToggle
map <leader>// <plug>NERDCommenterComment
map <leader>/$ <plug>NERDCommenterToEOL
map <leader>/A <plug>NERDCommenterAppend
map <leader>/l <plug>NERDCommenterAlignLeft

" =====================
" ack.vim
" =====================
if executable('ag')
    let g:ackprg = "ag --vimgrep"
endif

nmap <Leader>a :Ack!<Space>

command Todo Ack! 'TODO|FIXME|NOTE|BUG'

if has("autocmd")
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|NOTE\|BUG\)')
endif
" =====================
" vim-doge
" =====================
let g:doge_filetype_aliases = {
\  'javascript': ['vue']
\}

let g:doge_mapping = "<Leader>d"
let g:doge_mapping_comment_jump_forward = "<C-j>"
let g:doge_mapping_comment_jump_backward= "<C-k>"

" =====================
" duck.nvim
" =====================
nnoremap \dd :lua require("duck").hatch("🐈", 1)<CR>
nnoremap \dk :lua require("duck").cook("🐈", 1)<CR>

" =====================
" vundle
" =====================
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
" set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/local/opt/fzf
call plug#begin()
" Plug 'VundleVim/Vundle.vim'
let g:plug_url_format = 'git@github.com:%s.git'
Plug 'dstein64/vim-startuptime'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'lifepillar/vim-cheat40'
Plug 'preservim/tagbar'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown'}
Plug 'nathanaelkane/vim-indent-guides'
Plug 'kshenoy/vim-signature'
Plug 'raimondi/delimitmate'
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript', 'css'] }
Plug 'gcmt/wildfire.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'preservim/nerdcommenter'
Plug 'numirias/semshi', { 'for' :['python', 'vim-plug'],  'do': ':UpdateRemotePlugins'  }
Plug 'puremourning/vimspector'
Plug 'godlygeek/tabular'
Plug 'mhinz/vim-startify'
Plug 'mbbill/undotree'
Plug 'brooth/far.vim'
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'gisphm/vim-gitignore'
Plug 'mileszs/ack.vim'
Plug 'kkoomen/vim-doge', { 'do': 'pnpm i --no-save && pnpm run build:binary:unix' }
Plug 'jszakmeister/markdown2ctags'
Plug 'ggandor/leap.nvim'
Plug 'tamton-aquib/duck.nvim'
Plug 'ojroques/nvim-osc52'
Plug 'ap/vim-css-color'
Plug 'sainnhe/edge'
Plug 'NLKNguyen/papercolor-theme'
unlet g:plug_url_format
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-repeat'
Plug 'https://github.com/tpope/vim-surround.git'
" Plugin 'dense-analysis/ale'

call plug#end()

" The configuration options should be placed before `colorscheme edge`.
let g:edge_style = 'aura'
let g:edge_dim_foreground = 1
let g:edge_better_performance = 1

colorscheme PaperColor

hi CocUnusedHighlight ctermbg=NONE guibg=NONE guifg=#808080

" set ideajoin
" =====================
" leap.nvim
" =====================
lua <<EOF
-- require('leap').add_default_mappings()
require('leap').opts.safe_labels = {}
require('leap').opts.highlight_unlabeled_phase_one_targets = true
vim.keymap.set({'x', 'o', 'n'}, 'e', '<Plug>(leap-forward-to)')
vim.keymap.set({'x', 'o', 'n'}, 'E', '<Plug>(leap-backward-to)')
vim.keymap.set({'x', 'o', 'n'}, 'ge', '<Plug>(leap-cross-window)')
EOF

function! SaveWithMatches(s)
    " get help through `h: a:var`
    let @" .= a:s . "\n"
    return a:s
endfunction

command! -nargs=+ Pmatch call SaveWithMatchess(<f-args>)

function! SaveWithMatchess(...)
    let @" = ''
    " get help through `h :s\=`
    execute printf('%%substitute/%s/\=SaveWithMatches(submatch(0))/g', a:1)
endfunction

" =====================
" nvim osc52
" =====================
lua <<EOF
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)
EOF

