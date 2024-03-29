set encoding=utf-8
scriptencoding utf-8
" ↑1行目は読み込み時の文字コードの設定
" ↑2行目はVim Script内でマルチバイトを使う場合の設定
" Vim scritptにvimrcも含まれるので、日本語でコメントを書く場合は先頭にこの設定が必要になる

let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

"----------------------------------------------------------
" dein.vim
"----------------------------------------------------------
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('$DATA/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('$CONFIG/nvim/dein')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

"----------------------------------------------------------
" dein.vimパッケージ.
" ~/.vim/rc/(dein.toml|dein_lazy)にtoml形式で書いている
" パッケージもある
"----------------------------------------------------------
" ステータスラインの表示内容強化
" call dein#add('itchyny/lightline.vim')
" インデントの可視化
call dein#add('Yggdroot/indentLine')
"" 行末の無駄な空白を可視化する。
"" :StripWhitespace を実行すると空白を削除できる
call dein#add('ntpeters/vim-better-whitespace')
" 非同期で各種Lintを実行できる ale
call dein#add('dense-analysis/ale')
" vimproc
call dein#add('Shougo/vimproc.vim', {'build': 'make'})
" 多機能セレクタ
call dein#add('ctrlpvim/ctrlp.vim')
" CtrlPの拡張プラグイン. 関数検索
call dein#add('tacahiroy/ctrlp-funky')
" CtrlPの拡張プラグイン. コマンド履歴検索
call dein#add('suy/vim-ctrlp-commandline')
" CtrlPの検索にagを使う
call dein#add('rking/ag.vim')
" ビジュアルモードでまとめてコメントアウト(gcでコメントアウトされる)
call dein#add('tpope/vim-commentary')
" jupyterノートブックを扱えるようにする
call dein#add('goerz/jupytext.vim')
" jupyter-vim
call dein#add('jupyter-vim/jupyter-vim')
" Directory treeを表示
call dein#add('scrooloose/nerdtree')
" Dev Icons
call dein#add('ryanoasis/vim-devicons')
" 括弧をレインボー表示
call dein#add('luochen1990/rainbow')
let g:rainbow_active = 1
" 括弧を自動補完
call dein#add('jiangmiao/auto-pairs')
"syntax hilight
call dein#add('nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'})

" 辞書
"" 範囲選択後 :Translate で翻訳
"" :terminalでターミナル起動後
"" C-w Nでノーマルモード
"" ノーマルモードでiを押すとジョブモードに移行
call dein#add('skanehira/translate.vim')
" ポップアップ窓を使うなら値を1にする（デフォルト1)
let g:translate_popup_window = 0
" ポップアップ窓を使わない場合でのバッファ窓の高さを設定
let g:translate_winsize = 10

" 文章整形プラグイン ビジュアルモードで選択しEnter
" 複数個ある場合は Enter->* をタイプ
call dein#add('junegunn/vim-easy-align', {
  \ 'autoload': {
  \   'commands' : ['EasyAlign'],
  \   'mappings' : ['<Plug>(EasyAlign)'],
  \ }})

" Rust
call dein#add('rust-lang/rust.vim')
"" 保存時に自動でrustfmt(整形)
let g:rustfmt_autosave = 1
"" Testがある場所で:RustTestと入力するとテストを実行し結果を見れる

" Windowsサイズを高速に変更できるようにする
"" Ctrl+Eでリサイズモードに入り,h,j,k,lでそれぞれリサイズしEnterで確定
""に qを押せば変更はキャンセルされる
call dein#add('simeji/winresizer')

" git 変更箇所のマーキング
call dein#add('airblade/vim-gitgutter')

"----------------------------------------------------------
" 補完用設定
"----------------------------------------------------------
" 補完をしてくれるdeoplete
" call dein#add('Shougo/deoplete.nvim')
" if !has('nvim')
"   call dein#add('roxma/nvim-yarp')
"   call dein#add('roxma/vim-hug-neovim-rpc')
" endif

" let g:deoplete#enable_at_startup = 1
" let g:deoplete#auto_complete_delay = 0
" let g:deoplete#auto_complete_start_length = 1
" let g:deoplete#enable_camel_case = 0
" let g:deoplete#enable_ignore_case = 0
" let g:deoplete#enable_refresh_always = 0
" let g:deoplete#enable_smart_case = 1
" let g:deoplete#file#enable_buffer_path = 1
" let g:deoplete#max_list = 10000

" neosnippet
call dein#add('Shougo/neosnippet.vim')
" Ctrl + k でジャンプ
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

"neosnippet-snippets
call dein#add('Shougo/neosnippet-snippets')
" 非同期補完
" call dein#add('prabirshrestha/asyncomplete.vim')

"----------------------------------------------------------
" LSPクライアント(要node.js, npm, yarn)
" sudo apt install nodejs && npm
" npm install -g yarn
" CocInstall hoge でhogeのプラグインをインストール
" プラグインがなければ:CocConfigに設定を追加することで使える
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" error等出るとき:call coc#util#install()
"----------------------------------------------------------
call dein#add('neoclide/coc.nvim', { 'merged': 0, 'do': 'yarn install --frozen-lockfile' })
set statusline^=%{coc#status()}
set nobackup
set nowritebackup
" displaying messages
set cmdheight=2
" having longer updatetime(default=4000ms) delays and poor UX
set updatetime=300
" Don't pass messages to ins-completion-menu
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" if has("nvim-0.5.0") || has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif

set signcolumn=yes

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-@> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-@> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction


" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"----------------------------------------------------------
" カラースキーム
"----------------------------------------------------------
call dein#add('tomasr/molokai', {'merged': 0})
call dein#source('molokai')
colorscheme molokai " カラースキームにmolokaiを設定する
set t_Co=256 " iTerm2など既に256色環境なら無くても良い
syntax enable " 構文に色を付ける
set pumblend=10 " 透過率の設定
set termguicolors

"----------------------------------------------------------
" 文字
"----------------------------------------------------------
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決
" if exists('&ambw')
"   set ambiwidth=single
" endif
"

"----------------------------------------------------------
" バッファ
"----------------------------------------------------------
" :bd でバッファ閉じる -> :bd [バッファ番号]も可
" :%bd で全てのバッファを閉じる
" :sp or <C-w>s 今開いているバッファを水平分割して表示
" :vs or <C-w>v 今開いているバッファを垂直分割して表示
" :ls でバッファを確認して :b [バッファ番号]で現在のウィンドウに表示
" :ls h+ 未保存の非表示バッファのみ表示する
" :sb [バッファ番号]でウィンドウを分割してバッファを表示させる

" カーソルキーでBuffer移動
nnoremap <Left> :bp<CR>
nnoremap <Right> :bn<CR>

"----------------------------------------------------------
" ステータスライン
"----------------------------------------------------------
" set laststatus=2 " ステータスラインを常に表示
" set showmode " 現在のモードを表示
" set showcmd " 打ったコマンドをステータスラインの下に表示
" set ruler " ステータスラインの右側にカーソルの位置を表示する

"" airline設定
" dein.tomlに記載

"----------------------------------------------------------
" コマンドモード
"----------------------------------------------------------
set wildmenu " コマンドモードの補完
set history=10000 " 保存するコマンド履歴の数

"----------------------------------------------------------
" タブ・インデント
"----------------------------------------------------------
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" 拡張子ごとの設定
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.ts setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

"----------------------------------------------------------
" 文字列検索
"----------------------------------------------------------
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"----------------------------------------------------------
" カーソル
"----------------------------------------------------------
set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set number " 行番号を表示
set cursorline " カーソルラインをハイライト

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" バックスペースキーの有効化
set backspace=indent,eol,start

"----------------------------------------------------------
" カッコ・タグの対応
"----------------------------------------------------------
set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

"----------------------------------------------------------
" マウスでカーソル移動とスクロール
"----------------------------------------------------------
"if has('mouse')
"    set mouse=a
"    if has('mouse_sgr')
"        set ttymouse=sgr
"    elseif v:version > 703 || v:version is 703 && has('patch632')
"        set ttymouse=sgr
"    else
"        set ttymouse=xterm2
"    endif
"endif

"----------------------------------------------------------
" クリップボードからのペースト
"----------------------------------------------------------
" 挿入モードでクリップボードからペーストする時に自動でインデントさせないようにする
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" クリップボード共有
set clipboard&
set clipboard^=unnamedplus

"----------------------------------------------------------
" nvim-treesitter
"----------------------------------------------------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  },
  indent = {
    enable = true, --これを設定するとtree-sitterによるインデントを有効にできる
  },
}
EOF

"----------------------------------------------------------
" ale
"----------------------------------------------------------
" LSP無効
let g:ale_disable_lsp = 1
" 保存時のみ実行する
let g:ale_lint_on_text_changed = 0
" 表示に関する設定
let g:ale_sign_column_always = 1
"let g:ale_sign_error = ''
"let g:ale_sign_warning = ''
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '=='
let g:airline#extensions#ale#open_lnum_symbol = '('
let g:airline#extensions#ale#close_lnum_symbol = ')'
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass
" Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let js_fixers = ['prettier', 'eslint']
let g:ale_linters = {
  \   'javascript': ['eslint'],
  \   'javascript.jsx': ['eslint'],
  \   'typescript': ['eslint'],
  \   'typescriptreact': ['eslint'],
  \ }
let g:ale_fixers = {
  \   '*': ['remove_trailing_lines', 'trim_whitespace'],
  \   'python': ['flake8'],
  \   'javascript': js_fixers,
  \   'javascript.jsx': js_fixers,
  \   'typescript': js_fixers,
  \   'typescriptreact': js_fixers,
  \   'css': ['prettier'],
  \   'json': ['prettier'],
  \ }

"----------------------------------------------------------
" vim-autopep8の設定
"----------------------------------------------------------
"autopep8を<shift>+fで実行
function! Preserve(command)
    " Save the last search.
    let search = @/
    " Save the current cursor position.
    let cursor_position = getpos('.')
    " Save the current window position.
    normal! H
    let window_position = getpos('.')
    call setpos('.', cursor_position)
    " Execute the command.
    execute a:command
    " Restore the last search.
    let @/ = search
    " Restore the previous window position.
    call setpos('.', window_position)
    normal! zt
    " Restore the previous cursor position.
    call setpos('.', cursor_position)
endfunction
function! Autopep8()
    call Preserve(':silent %!autopep8 --ignore=E501 -')
endfunction
autocmd FileType python nnoremap <S-f> :call Autopep8()<CR>

"----------------------------------------------------------
" ctrlp
"----------------------------------------------------------
let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100' " マッチウインドウの設定. 「下部に表示, 大きさ20行で固定, 検索結果100件」
let g:ctrlp_show_hidden = 1 " .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_types = ['fil'] "ファイル検索のみ使用
let g:ctrlp_extensions = ['funky', 'commandline'] " CtrlPの拡張として「funky」と「commandline」を使用

" CtrlPCommandLineの有効化
command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())

" CtrlPFunkyの絞り込み検索設定
let g:ctrlp_funky_matchtype = 'path'

if executable('ag')
  let g:ctrlp_use_caching=0 " CtrlPのキャッシュを使わない
  let g:ctrlp_user_command='ag %s -i --hidden -g ""' " 「ag」の検索設定
endif

"----------------------------------------------------------
" Jupytext.vim向けの設定
"----------------------------------------------------------
" セルの区切り文字をVSCode互換の # %% に指定する
let g:jupytext_fmt = 'py:percent'
" vimのPython向けシンタックスハイライトを有効にする
let g:jupytext_filetype_map = {'py': 'python'}

"----------------------------------------------------------
" 透過用の設定
"----------------------------------------------------------
highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none
highlight LineNr ctermbg=none guibg=none
highlight Folded ctermbg=none guibg=none
highlight EndOfBuffer ctermbg=none guibg=none

" augroup TransparentBG
"   	autocmd!
" 	autocmd Colorscheme * highlight Normal ctermbg=none
" 	autocmd Colorscheme * highlight NonText ctermbg=none
" 	autocmd Colorscheme * highlight LineNr ctermbg=none
" 	autocmd Colorscheme * highlight Folded ctermbg=none
" 	autocmd Colorscheme * highlight EndOfBuffer ctermbg=none
" augroup END

"----------------------------------------------------------
" NERD Treeの表示非表示を切り替える
"----------------------------------------------------------
" Ctrl + nで切り替える
map <C-n> :NERDTreeToggle<CR>
let g:webdevicons_enable_nerdtree = 1

"----------------------------------------------------------
" vim-easy-alignの設定
"----------------------------------------------------------
" vim-easy-align {{{
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
" }}}

"----------------------------------------------------------
" google suggestによる補完の設定
" 要curl, <c-x><c-u>でサジェスト
"----------------------------------------------------------
set completefunc=GoogleComplete
function! GoogleComplete(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\S'
            let start -= 1
        endwhile
        return start
    else
        let ret = system('curl -s -G --data-urlencode "q='
                    \ . a:base . '" "http://suggestqueries.google.com/complete/search?&client=firefox&hl=ja&ie=utf8&oe=utf8"')
        let res = split(substitute(ret,'\[\|\]\|"',"","g"),",")
        return res
    endif
endfunction

"----------------------------------------------------------
" fzf-vimの設定
"----------------------------------------------------------
" fzf
" 要fzfインストール
call dein#add('junegunn/fzf', {'build': './install --all'})
call dein#add('junegunn/fzf.vim')

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let mapleader="\<Space>"
nnoremap <silent> <Leader>,p :GFiles<CR>
nnoremap <silent> <Leader>p :Files<CR>
nnoremap <silent> <Leader>,s :RG<CR>
nnoremap <silent> <Leader>,c :Commits<CR>
"
"----------------------------------------------------------
" vim-gitgutterの設定
"----------------------------------------------------------
nmap <silent> <C-g><C-n> <Plug>GitGutterNextHunk
nmap <silent> <C-g><C-p> <Plug>GitGutterPrevHunk
