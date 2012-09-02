" Maintainer:       Kojo Sugita<kojo.sugita@gmail.com>
" Latest Revision:  2009-08-21

" {{{ Common setting
"/* --- フォント, 背景色設定 --- */
"背景色

colorscheme rootwater

set transparency=10

" set imdisable
set imdisableactivate

"フォント設定
if has("unix")

	" set guifontwide=IPAMonaGothic\ 12
	"set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
	"set guifontwide=Bitstream\ Vera\ Sans\ Mono\ 12
	"set printfont=IPAMonaGothic\ 12
	autocmd GUIEnter * winpos 200 100
	autocmd GUIEnter * winsize 80 80

elseif has("gui_win32")
	" set guifont=HGｺﾞｼｯｸM:h11
	" set guifontwide=HGｺﾞｼｯｸM:h11
	set guifont=sazanami_gothic:h10
	set guifontwide=sazanami_gothic:h10
	set printfont=MS_Gothic:h11:cSHIFTJIS
	autocmd GUIEnter * winpos 200 100
	autocmd GUIEnter * winsize 100 50

endif

"/* --- 表示 --- */
syntax on           "シンタックス有効

set number          "行番号を表示
set laststatus=2    "ステータスラインを表示
set showcmd         "入力中のコマンドをステータスに表示する
set ruler           "現在のカーソル位置を表示
set wrap! = nowrap  "折り返ししない
set foldmethod=marker "折りたたみを有効にする

"/* --- 検索設定 --- */
set hlsearch        "検索結果文字列のハイライトを有効にする
set ignorecase      "大文字小文字を区別なく検索する
set smartcase       "検索文字列に大文字が含まれている場合は区別して検索する
set incsearch       "インクリメンタルサーチ

"選択範囲内から検索できるようにする
vnoremap <silent> / :<C-U>call RangeSearch('/')<CR>:if  strlen(g:srchstr) > 0\|exec '/'.g:srchstr\|endif<CR>
vnoremap <silent> ? :<C-U>call RangeSearch('?')<CR>:if strlen(g:srchstr) > 0\|exec '?'.g:srchstr\|endif<CR>

"/* --- "括弧の設定 --- */
set showmatch       "括弧の対応表示

"括弧が入力されたときに自動的に閉じ括弧を入力する
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap { {}<LEFT>

"/* --- インデント, Tab文字, EOFなどの設定 --- */
set autoindent      "自動インデント
set smartindent     "自動インデント
set shiftwidth=4    "autoindent時に挿入されるタブの幅
set tabstop=4       "タブ幅の設定
set list            "Tab文字や、EOFを表示

"tab文字や、EOLを変更
set lcs=tab:..,eol:<,extends:\

"全角スペース, 行末半角スペースの色変え
if has("syntax")
	syntax on
	function! ActivateInvisibleIndicator()
		"全角スペースを表示
		syntax match InvisibleJISX0208Space "　" display containedin=ALL
		highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=#6666ff
		"行末の半角スペースを表示
		syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
		highlight InvisibleTrailedSpace term=underline ctermbg=red guibg=#ff6666
	endf
	augroup invisible
		autocmd! invisible
		autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
	augroup ENDendif
endif

"Smarter Table Editing
map <S-Tab> :call NextField(' \{2,}',2,' ',0)<CR>
imap <S-Tab> <C-O>:call NextField(' \{2,}',2,' ',0)<CR>

"/* --- ヤンクの設定 --- */
"選択した範囲に行番号をつけてレジスタ * にヤンク
vnoremap \y :call YankWithLineNumber()<CR>

"無名レジスタに入るデータを、*レジスタにも入れる。
set clipboard+=unnamed

"/* --- 文字コード --- */
" 文字コードの自動認識(http://www.kawaz.jp/pukiwiki/?vim#g59923b3から頂戴)
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
		" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	set ambiwidth=double
endif

"日本語設定
if has('multi_byte_ime') || has('xim')
    " 日本語入力ON時のカーソルの色を設定
    highlight CursorIM guibg=Red guifg=NONE
endif


"/* --- その他編集 --- */
"表示行単位で移動
noremap j gj
noremap k gk
vnoremap j gj
vnoremap k gk

" インサートモードでバックスペースを押したときの対策
"noremap ^? 
"noremap! ^? 
"noremap 
"noremap!  

"前後移動をEmacsのようなキーバインドにする
inoremap <C-f> <Right>
inoremap  <Right>
inoremap <C-b> <Left>
inoremap  <Left>

"/* --- その他 --- */
filetype plugin on  "ファイルタイププラグインを有効にする
set vb t_vb=        "ビープ音をならさない
set guioptions=F    "GUIオプション
set nobackup        "バックアップしない
set autoread        "編集されたら読み直す
set wildchar=<Tab>  "Tabで補完できるようにする
set nocompatible    "VI互換をオフ

"completeを初期化
au FileType * set complete=.,w,b,u,t,i

"<Leader>を,にする
" let mapleader = '\'
map , <Leader>

"連続する空白行を圧縮する
nnoremap <silent> <C-x><C-o> :call DeleteBlankLines()<CR>

".vimrcの再読み込み
if has("unix")
	noremap <C-F12> :source ~/.vimrc<CR>
elseif has("gui_win32")
	noremap <C-F12> :source $VIM/_gvimrc<CR>
endif

" 注意: この内容は:filetype onよりも後に記述すること。
autocmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif

" }}}
" {{{ Programing language
au BufNewFile,BufRead *.bat,*.cmd call DosBatchSettings()
au BufNewFile,BufRead *.vb,*vbs call VBScriptSettings()
au BufNewFile,BufRead *.c,*.h,*.cpp,*.java,*.js,*.pl,*.cgi call CCommonSettings()
au BufNewFile,BufRead *.c,*.h call CSettings()
au BufNewFile,BufRead *.cpp call CppSettings()
au BufNewFile,BufRead *.java call JavaSettings()
au BufNewFile,BufRead *.js call JavaScriptSettings()
au BufNewFile,BufRead *.m call ObjectiveCSettings()
au BufNewFile,BufRead *.html,*.htm,*.xhtml,*.xml,*.xsl,*.xslt,*.xul call TagCommonSettings()
au BufNewFile,BufRead *.html,*.htm,*.xhtml call HTMLSettings()
au BufNewFile,BufRead *.css call CssSettings()
au BufNewFile,BufRead *.xml call XmlSettings()
au BufNewFile,BufRead *.xul call XulSettings()
au BufNewFile,BufRead *.rb call RubySettings()
au BufNewFile,BufRead *.py call PythonSettings()
au BufNewFile,BufRead *.php call PHPSettings()
au BufNewFile,BufRead *.pl,*.cgi call PerlSettings()
au BufNewFile,BufRead *.tex call LaTeXSettings()
au BufNewFile,BufRead *.s,*.src call AssemblySettings()
au BufNewFile,BufRead *.scm call SchemeSettings()
au BufNewFile,BufRead *.txt call TextSettings()
au BufNewFile,BufRead *.gpi,*.gih call GnuplotSettings()

" {{{ Windows batch file
function! DosBatchSettings()
	"Windowsバッチファイルの辞書ファイルをセット
	set dictionary=$VIMRUNTIME/dict/dosbatch.dict

	"実行
	noremap <F5> <Esc>:! %<Enter>

endfunction
" }}}
" {{{ VBScript
function! VBScriptSettings()
	"VBScriptの辞書ファイルをセット
	set dictionary=$VIMRUNTIME/dict/vbscript.dict,$VIMRUNTIME/dict/wsh.dict

	"Enterが押されたときに自動補完する
	inoremap <expr> <CR> AutoEndForVBScript()

	"実行
	noremap <F5> <Esc>:! %<Enter>

endfunction
" }}}
" {{{ C,C++,Java,JavaScript commonness
function! CCommonSettings()

	set cindent

	"キーマップを変更
	inoremap <expr> ; GetSemicolonForC()
	inoremap <expr> { GetBraceForC()
	inoremap <expr> " GetDoubleQuotes()
	inoremap <expr> ' GetSingleQuotesForC()
	inoremap <expr> <Space> GetSpace()
	inoremap , ,<Space>

	"関数を範囲選択(VimWikiより)
	nnoremap vf ][v[[?^?s*$<CR>

	"ブロック選択(VimWikiより)
	nnoremap vb /{<CR>%v%0

endfunction

"
" }}}
" {{{ C
function! CSettings()
	"cの辞書ファイルをセット
	if has("unix")
		set dictionary=$HOME/.vim/dict/c.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/c.dict
	endif
	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=ccomplete#Complete
	endif

	" inoremap <expr> :st GetStructForC("struct")
	" inoremap <expr> :em GetStructForC("enum")

	" inoremap <expr> :fv GetFunctionForC_2select("void")
	" inoremap <expr> :fc GetFunctionForC_4select("char")
	" inoremap <expr> :fs GetFunctionForC_4select("short")
	" inoremap <expr> :fi GetFunctionForC_4select("int")
	" inoremap <expr> :fl GetFunctionForC_4select("long")
	" inoremap <expr> :ff GetFunctionForC_2select("float")
	" inoremap <expr> :fd GetFunctionForC_2select("double")

	"gccコンパイラ設定
	nmap <F5> :call MakeC_gcc()<cr>

	"bccコンパイラ設定
	nmap <F6> :call MakeC_bcc()<cr>

	set nowrap tabstop=4 tw=0 sw=4 expandtab

endfunction
" }}}
" {{{ C++
function! CppSettings()
	"C++言語のキーワードをハイライト
	:let java_allow_cpp_keywords=1
endfunction
" }}}
" {{{ Java
function! JavaSettings()
	"javaの辞書ファイルをセット
	if has("unix")
		set dictionary=$HOME/.vim/dict/j2se14.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/j2se14.dict
	endif

	"ハイライト
	:let java_highlight_all=1 "Java言語の標準のクラス名をハイライト
	:let java_highlight_debug=1 "デバッグ文のハイライト
	:let java_space_errors=1 "余分な空白に対してハイライト
	:let java_highlight_functions=1 "メソッド宣言文をハイライト

	"コンパイラ設定(Java)
	compiler javac

	"コンパイル
	nmap <F5> :call MakeJava()<CR>

	"javacomplete
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=javacomplete#Complete
		set completefunc=javacomplete#CompleteParamsInfo
	endif

endfunction
" }}}
" {{{ JavaScript
function! JavaScriptSettings()
	"JavaScriptの辞書ファイルをセット
	if has("unix")
		set dictionary=$HOME/.vim/dict/javascript.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/javascript.dict
	endif

	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=javascriptcomplete#CompleteJS
	endif

endfunction
" }}}
" {{{ Objective-C
function! ObjectiveCSettings()
	"gccコンパイラ設定
	nmap <F5> :call MakeObjectiveC_gcc()<cr>
endfunction
" }}}
" {{{ Ruby
function! RubySettings()
	"Rubyのときは、タブ幅を2に設定 & タブ文字の代わりに同じ幅の空白文字を入れる
	set nowrap tabstop=2 tw=0 sw=2 expandtab

	"コンパイラ設定(RUBY)
	compiler ruby

	nmap <F5> :call DebugRuby()<cr>

	"<F6>でバッファのRubyスクリプトを実行し、結果をプレビュー表示
	vmap <silent> <F6> :call Ruby_eval_vsplit()<CR>
	nmap <silent> <F6> mzggVG<F6>`z
	map  <silent> <S-F6> :pc<CR>

	"<C-F10>でRubyスクリプトを保存後コマンドプロンプトから実行
	nmap <silent> <C-F6> :w<CR>:!ruby %<CR>
endfunction
" }}}
" {{{ HTML,XHTML,XML,XUL commonness
function! TagCommonSettings()

	"タブ幅を2に設定
	set nowrap tabstop=2 tw=0 sw=2

	inoremap <expr> " GetDoubleQuotes()
	inoremap <buffer> < <><LEFT>

	"句読点を.や,に変換する
	nmap <F12> :call ConvertHTMLPunctuation()<CR>

endfunction
" }}}
" {{{ HTML
function! HTMLSettings()

	"マークアップ記号を補完する
	inoremap <buffer> \" &quot;
    inoremap <buffer> \& &amp;
    inoremap <buffer> \< &lt;
    inoremap <buffer> \> &gt;
    inoremap <buffer> \<Space> &nbsp;

	"<F5>でHtmlを表示する
	nmap <F5> :! %<CR>
	" noremap <Leader>W :silent !start firefox %<CR>
	" noremap <F5> :silent !start firefox %<CR>

	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=htmlcomplete#CompleteTags
	endif

endfunction
" }}}
" {{{ Cascading Style Sheets
function! CssSettings()

	"タブ幅を2に設定
	set nowrap tabstop=2 tw=0 sw=2

	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=csscomplete#CompleteCSS
	endif

	"キーマップ変更
	inoremap ; ;<CR>
	inoremap : : 
	inoremap { {<CR>}<Esc>0bo
	
endfunction
" }}}
" {{{ XML
function! XmlSettings()

	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=xmlcomplete#CompleteTags
	endif
endfunction
" }}}
" {{{ XUL
function! XulSettings()
	set filetype=xul

	"XULの辞書ファイルをセット
	if has("unix")
		set dictionary=$HOME/.vim/dict/xul.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/xul.dict
	endif

	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=xmlcomplete#CompleteTags
	endif
endfunction
" }}}
" {{{ Perl
function! PerlSettings()
	compiler perl
	"Perlの辞書ファイルをセット
	if has("unix")
		set dictionary=$HOME/.vim/dict/perl.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/perl.dict
	endif

	"キーマップを変更
	nmap <F5> :call MakePerl()<CR>
	nmap <F6> :! perl %<CR>

endfunction

" }}}
" {{{ Python
function! PythonSettings()
	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=pythoncomplete#Complete
	endif
endfunction
" }}}
" {{{ PHP
function! PHPSettings()
	"辞書ファイルの設定
	if has("unix")
		set dictionary=$HOME/.vim/dict/PHP.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/PHP.dict
	endif

	"オムニ補完
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=phpcomplete#CompletePHP
	endif

endfunction
" }}}
" {{{ LaTeX
function! LaTeXSettings()

	"四則演算
	inoremap <buffer> \* \times 
	inoremap <buffer> \/ \div 
	inoremap <buffer> \= \equiv 
	inoremap <buffer> \!= \neq 

	"その他演算子
	inoremap <buffer> \<= \leq 
	inoremap <buffer> \>= \geq 
	inoremap <buffer> \<< \ll 
	inoremap <buffer> \>> \gg 
	inoremap <buffer> \+- \pm 
	inoremap <buffer> \-+ \mp 

	"数式モード
	inoremap $ $$<LEFT>
	" inoremap _ _{}<LEFT>
	" inoremap ^ ^{}<LEFT>

	"LaTeXのときは、タブ幅を2に設定 & タブ文字の代わりに同じ幅の空白文字を入れる
	set nowrap tabstop=2 tw=0 sw=2 expandtab

	"辞書ファイルの設定
	if has("unix")
		set dictionary=$HOME/.vim/dict/tex.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/tex.dict
	endif

	"LaTeXをコンパイル
	nmap <C-F5> :! platex %<CR>

	"PDF変換
	nmap <C-F6> :! dvipdfmx %<<CR>

	"句読点を.や,に変換する
	nmap <F12> :call ConvertTexPunctuation()<CR>

	"/* -- VIM-LaTeX用設定 -- */
	set shellslash

	" grepを持っている場合
	set grepprg=grep\ -nH\ $*

	" OPTIONAL: This enables automatic indentation as you type.
	filetype indent on

	" dviファイル生成コマンド
	let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'

	" dviファイルビューワー
	let g:Tex_ViewRule_dvi = 'dviout' 

	" pdf生成
	let g:Tex_FormatDependency_pdf = 'dvi,pdf'
	let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
	let g:Tex_ViewRule_pdf = 'C:\Program Files\Adobe\Acrobat 7.0\Acrobat\Acrobat.exe' 

	" jbitex設定
	let g:Tex_BibtexFlavor = 'jbibtex -kanji=sjis'

endfunction
" }}}
" {{{ Assembly
function! AssemblySettings()

	"タブ幅を8に設定
	set nowrap tabstop=8 tw=0 sw=8

endfunction
" }}}
" {{{ Scheme
function! SchemeSettings()
	
	"タブ幅を2に設定
	" set nowrap tabstop=2 tw=0 sw=2

	"辞書ファイルの設定
	if has("unix")
		set dictionary=$HOME/.vim/dict/R5RS.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/R5RS.dict
	endif

	"インデントの設定(ボクノス様http://d.hatena.ne.jp/tanakaBox/20070609/1181382818より頂戴)
	set nocindent
	set lisp
	set lispwords=define

	inoremap <expr> <Space> GetSpace()

endfunction
" }}}
" {{{ Text
function! TextSettings()
	set nocindent
	"タブ幅を2, タブ文字の変わりにスペース
	set nowrap tabstop=2 tw=0 sw=2 expandtab
endfunction
" }}}
" {{{ Gnuplot
function! GnuplotSettings()
	"Gnuplotの辞書ファイルをセット
	if has("unix")
		set dictionary=$HOME/.vim/dict/gnuplot.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/gnuplot.dict
	endif
endfunction
" }}}
" }}}
" {{{ Plugins
"
"NERD_comments
let NERDSpaceDelims = 1
let NERDShutUp = 1

"fuzzyfinder
nnoremap <silent> <C-x><C-b> :FuzzyFinderBuffer<CR>
nnoremap <silent> <C-x><C-f> :FuzzyFinderFile<CR>
nnoremap <silent> <C-x><C-d> :FuzzyFinderDir<CR>

"matchit
:source $VIMRUNTIME/macros/matchit.vim

" }}}
" {{{ Functions
"/* ----------------------------------------------------------------------
" brief:  選択した範囲に行番号をつけてレジスタ * にヤンクする
" param:  -
" #http://vimwiki.net/?tips%2F91より頂戴
"---------------------------------------------------------------------- */
function! YankWithLineNumber() range
	let a = ""
	let i = a:firstline
	while i <= a:lastline
		let a = a . i . "    " . getline(i) . "\n"
		let i = i + 1
	endwhile
	call setreg('*', a, "l")
endfunction

"/* ----------------------------------------------------------------------
" brief:  Emacs の delete-blank-lines 相当の関数
" param:  -
" #http://vimwiki.net/?tips%2F88より頂戴
"---------------------------------------------------------------------- */
function! DeleteBlankLines()
	if search('\S','bW')
		let b = line('.') + 1
	else
		let b = 1
	endif
	if search('^\s*\n.*\S', 'eW')
		let e = line('.') - 1
	else
		let e = line('$')
	endif
	if b == e
		exe b . "d"
	else
		exe (b+1) . "," . e  . "d"
		exe b
	endif
endfunction

"/* ----------------------------------------------------------------------
" brief:  Smarter Table Editing
" param:  fieldsep フィールドのセパレータ(正規表現)
"         minlensep フィールドのセパレータの最小の長さ
"         padstr 次のフィールドまでの間隔を埋める文字  
"         offset 次のフィールドの先頭から何文字目にジャンプするかのオフセット
" #http://vimwiki.net/?tips%2F46より頂戴
"---------------------------------------------------------------------- */
function! NextField(fieldsep,minlensep,padstr,offset)
	let curposn = col(".")
	let linenum = line(".")
	let prevline = getline(linenum-1)
	let curline = getline(linenum)
	let nextposn = matchend(prevline,a:fieldsep,curposn-a:minlensep)+1
	let padding = ""

	if nextposn > strlen(prevline) || linenum == 1 || nextposn == 0
		echo "last field or no fields on line above"
		return
	endif

	echo ""

	if nextposn > strlen(curline)
		if &modifiable == 0
			return
		endif
		let i = strlen(curline)
		while i < nextposn - 1
			let i = i + 1
			let padding = padding . a:padstr
		endwhile
		call setline(linenum,substitute(curline,"$",padding,""))
	endif
	call cursor(linenum,nextposn+a:offset)
	return
endfunction

"/* ----------------------------------------------------------------------
" brief:  選択範囲内から検索
" param:  検索キー
" #http://vimwiki.net/?tips%2F45より頂戴
"---------------------------------------------------------------------- */
function! RangeSearch(direction)
	call inputsave()
	let g:srchstr = input(a:direction)
	call inputrestore()
	if strlen(g:srchstr) > 0
		let g:srchstr = g:srchstr.
					\ '\%>'.(line("'<")-1).'l'.
					\ '\%<'.(line("'>")+1).'l'
	else
		let g:srchstr = ''
	endif
endfunction

"/* ----------------------------------------------------------------------
" brief:  C言語系(C,C++,Java,JavaScript)のセミコロン設定(呼出し側)
"         セミコロンが押されたときに一緒に改行するようにする。
" param:  -
" return: ; or ;+改行
"---------------------------------------------------------------------- */
function! GetSemicolonForC()
	";+改行 or ;
	return AutoSemicolonEnterForC()
endfunction

"/* ----------------------------------------------------------------------
" brief:  C言語系(C,C++,Java,JavaScript)のセミコロン設定
"         セミコロンが押されたときに一緒に改行するようにする。
" param:  -
" return: ; or ;+改行
"---------------------------------------------------------------------- */
function! AutoSemicolonEnterForC()
	let line = strpart(getline('.'), 0, col('.') - 1)

	" if line =~ '^\t*for \=('
	if line =~ '^[\t| ]*for \=('
		"for文を記述中
		return "; "

	else
		let words = [
					\ "cString",
					\ "cCppString",
					\ "cCharacter",
					\ "cComment",
					\ "cCommentStart",
					\ "cCommentL",
					\ "javaString",
					\ "javaCharacter",
					\ "javaComment",
					\ "javaLineComment",
					\ "javaScriptStringD",
					\ "javaScriptStringS",
					\ "javaScriptComment",
					\ "javaScriptLineComment"
					\ ]
		"let s = synIDattr(synID(line("."),col(".")-1,0),"name")
		let s = synIDattr(synID(line("."),col("."),0),"name")
		for word in words
			if s == word
				return ";"
			endif
		endfor

		return ";\<CR>"

	endif
endfunction

"/* ----------------------------------------------------------------------
" brief:  {が入力されたときに改行+閉じ括弧を補完する
" param:  -
" return: {} or { + 改行 + }
"---------------------------------------------------------------------- */
function! GetBraceForC()
	let line = strpart(getline('.'), 0, col('.') - 1)
	if line =~ ') \=$'
		return "{\n}\<Esc>0bo"
	else
		return "{}\<Left>"
	endif
endfunction

"/* ----------------------------------------------------------------------
" brief:  括弧内でスペースが押された場合に、( ←ココにカーソル )状態にする
" param:  -
" return: <Space> or <Space><Space><Left>
"---------------------------------------------------------------------- */
function! GetSpace()
	let nextChar = strpart(getline('.'), col('.') - 1, 1)
	let prevChar = strpart(getline('.'), col('.') - 2, 1)

	if nextChar == ")"
		if prevChar == "("
			return "\<Space>\<Space>\<Left>"
		endif
	endif

	return "\<Space>"

endfunction

"/* ----------------------------------------------------------------------
" brief:  文字列中にある検索ワードがマッチした件数を返す
" param:  行, 検索文字列
" return: マッチした件数
"---------------------------------------------------------------------- */
function! GetMatchCount(line,serchWord)
	let l:i = 0
	let l:str = a:line
	let l:index = match(a:line, a:serchWord)
	while l:index != -1
		let l:str = strpart(l:str,index + 1)
		let l:index = match(l:str, a:serchWord)
		let l:i = i + 1
	endwhile
	return l:i

endfunction

"/* ----------------------------------------------------------------------
" brief:  開きダブルクォートが入力されたときに閉じダブルクォートを挿入する
" param:  -
" return: " or ""
"---------------------------------------------------------------------- */
function! GetDoubleQuotes()
	if IsExistCorrespondDoubleQuote(getline('.'))
		return "\"\"\<LEFT>"
	else
		return '"'
	endif
endfunction

"/* ----------------------------------------------------------------------
" brief:  開きシングルクォートが入力されたときに閉じシングルクォートを挿入する
" param:  -
" return: ' or ''
"---------------------------------------------------------------------- */
function! GetSingleQuotesForC()
	if IsExistCorrespondSingleQuote(getline('.'))
		return "''\<LEFT>"
	else
		return "'"
	endif

endfunction

"/* ----------------------------------------------------------------------
" brief:  ダブルクォーテーションの存在チェック
" param:  行
" return: 1 or 0
"---------------------------------------------------------------------- */
function! IsExistCorrespondDoubleQuote(line)
	let l:matchCount = GetMatchCount(a:line,'"') - GetMatchCount(a:line,'\\"')
	if ( l:matchCount % 2 ) == 0
		return 1
	else
		return 0
	endif

endfunction

"/* ----------------------------------------------------------------------
" brief:  シングルクォートの存在チェック
" param:  行
" return: 1 or 0
"---------------------------------------------------------------------- */
function! IsExistCorrespondSingleQuote(line)
	let l:matchCount = GetMatchCount(a:line,"'")
	if ( l:matchCount % 2 ) == 0
		return 1
	else
		return 0
	endif

endfunction

"/* ----------------------------------------------------------------------
" brief:  VBScriptのEnd XXXを自動的に補完する
" param:  -
" return: 改行 or End XXX
"---------------------------------------------------------------------- */
function! AutoEndForVBScript()
	let line = strpart(getline('.'), 0, col('.') - 1)

	if strlen(line) != strlen(getline('.'))
		return "\<CR>"
	endif

	"ポップアップメニューが表示されているか?
	if pumvisible()
		return "\<CR>"
	endif

	"Function, If, Select-Case, While, Do-While, Do-Until, Do-Loop, For
	let serchWords = [
				\ '^\t*Sub.*)$',
				\ '^\t*Function.*)$',
				\ '^\t*If ',
				\ '^\t*Select Case ',
				\ '^\t*While ',
				\ '^\t*Do While ',
				\ '^\t*Do Until ',
				\ '^\t*Do \=$',
				\ '^\t*For '
				\ ]
	"End
	let endsStatements = [
				\ "End Sub",
				\ "End Function",
				\ "End If",
				\ "End Select",
				\ "Wend",
				\ "Loop",
				\ "Loop",
				\ "Loop",
				\ "Next"
				\]
	let i = 0
	for regexp in serchWords
		if line =~ regexp
			return "\<CR>" . endsStatements[i] . "\<UP>\<Esc>o"
		endif
		let i = i + 1
	endfor

	return "\<CR>"

endfunction

"/* ----------------------------------------------------------------------
" brief:  gccコンパイラ設定
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! MakeC_gcc()
	:w
	:compiler gcc
	:set makeprg=gcc
	" :make -Wall -g %
	:make -Wall --std=c99 %
	" :make -std=c99 -pedantic -Wall %
	:cw
endfunction

"/* ----------------------------------------------------------------------
" brief:  bccコンパイラ設定
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! MakeC_bcc()
	:compiler bcc
	:set makeprg=bcc32
	:make %
	:cw
endfunction

"/* ----------------------------------------------------------------------
" brief:  Javaコンパイラ設定
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! MakeJava()
	:make %
	:cw
endfunction

"デバッグ
function! DebugRuby()
	:make -Ks %
	:cw
endfunction

"/* ----------------------------------------------------------------------
" brief:  perlシンタックスエラー設定
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! MakePerl()
	:make % -c
	:cw
endfunction

"/* ----------------------------------------------------------------------
" brief:  gccコンパイラ設定 (Objective-C)
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! MakeObjectiveC_gcc()
	:w
	:compiler gcc
	:set makeprg=gcc
	:make % -I C:/GNUstep/GNUstep/System/Library/Headers -L C:/GNUstep//GNUstep/System/Library/Libraries -lobjc -lgnustep-base -fconstant-string-class=NSConstantString -enable-auto-import
	:cw
endfunction

"/* ----------------------------------------------------------------------
" preview interpreter's output(Tip #1244)
"---------------------------------------------------------------------- */
function! Ruby_eval_vsplit() range
	if &filetype == "ruby"
		let src = tempname()
		let dst = "Ruby Output"
		" put current buffer's content in a temp file
		silent execute ": " . a:firstline . "," . a:lastline . "w " . src
		" open the preview window
		silent execute ":pedit! " . dst
		" change to preview window
		wincmd P
		" set options
		setlocal buftype=nofile
		setlocal noswapfile
		setlocal syntax=none
		setlocal bufhidden=delete
		" replace current buffer with ruby's output
		silent execute ":%! ruby " . src . " 2>&1 "
		" change back to the source buffer
		wincmd p
	endif
endfunction

"/* ----------------------------------------------------------------------
" brief:  句読点を.や,に変換する(Tex)
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! ConvertTexPunctuation()

	let choice = inputlist( 
				\ ['run?',
				\ ' 1. Yes',
				\ ' 2. Cancel']
				\ )
	if choice == 1
		:%s/。/．/g
		:%s/、/，/g
	endif

endfunction

"/* ----------------------------------------------------------------------
" brief:  句読点を.や,に変換する(HTML)
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! ConvertHTMLPunctuation()

	let choice = inputlist( 
				\ ['run?',
				\ ' 1. Yes',
				\ ' 2. Cancel']
				\ )
	if choice == 1
		:%s/。/. /g
		:%s/、/, /g
	endif

endfunction
" }}}
" {{{ Alternate functions

" " /* ----------------------------------------------------------------------
" " brief:  C言語系(C,C++,Java,JavaScript)のセミコロン設定(呼出し側)
		" " セミコロンが押されたときに一緒に改行するようにする。
" " param:  -
" " return: ; or ;+改行
" " snippetsEmu.vimが使えない環境のときに有効になっているGetSemicolonForCと差し替えること
" " ---------------------------------------------------------------------- */
" function! GetSemicolonForC()
	" "自動的に(){}を付与する
	" let result =  AutoEndForC()
	" if result == "NF"
		" ";+改行 or ;
		" return AutoSemicolonEnterForC()

	" endif

	" return result

" endfunction

" "/* ----------------------------------------------------------------------
" " brief:  C言語系(C,C++,Java,JavaScript)のif文や for文の入力補助
" " param:  -
" " return: keymap or 'NF'
" "---------------------------------------------------------------------- */
" function! AutoEndForC()
	" let line = strpart(getline('.'), 0, col('.'))

	" "if, else, else-if, switch, for, while, do-while
	" let serchWords = [
				" \ '^\t*if$',
				" \ '^\t*} \=else$',
				" \ '^\t*} \=else if$',
				" \ '^\t*switch$',
				" \ '^\t*for$',
				" \ '^\t*while$',
				" \ '^\t*do$'
				" \ ]

	" let endsStatements = [
				" \ "\ (  ) {\n<++>\n}<++>\<Esc>0b0b4\<LEFT>a",
				" \ "\ {\n}<++>\<Esc>0bo",
				" \ "\ (  ) {\n<++>\n}<++>\<Esc>0b0b4\<LEFT>a",
				" \ "\ (  ) {\n<++>\n}<++>\<Esc>0b0b4\<LEFT>a",
				" \ "\ (  ) {\n<++>\n}<++>\<Esc>0b0b4\<LEFT>a",
				" \ "\ (  ) {\n<++>\n}<++>\<Esc>0b0b4\<LEFT>a",
				" \ "\ {\n} while( <++> );<++>\<Esc>0bo"
				" \]
	" let i = 0
	" for regexp in serchWords
		" if line =~ regexp
			" return endsStatements[i]
		" endif
		" let i = i + 1
	" endfor

	" return "NF"

" endfunction

" inoremap <expr> : GetColonForC()
" "/* ----------------------------------------------------------------------
" " brief:  switch-case文中の:を:+が入力されたときに+改行を行う
" " param:  -
" " return: : or :+改行+break;
" " snippetsEmu.vimが使えない環境のときにコメントアウトをはずすこと
" "---------------------------------------------------------------------- */
" function! GetColonForC()
	" let line = strpart(getline('.'), 0, col('.') - 1)

	" "switch文のcase or defaultを記述中か?
	" let serchWords = [
				" \ '^\t*case \=',
				" \ '^\t*default$'
				" \ ]

	" let actions = [
				" \ ":\<CR>break;<++>\<UP>\<Esc>o",
				" \ ":\<CR>break;<++>\<UP>\<Esc>o"
				" \]

	" let i = 0
	" for regexp in serchWords
		" if line =~ regexp
			" return actions[i]
		" endif
		" let i = i + 1
	" endfor

	" return ":"

" endfunction

" "/* ----------------------------------------------------------------------
" " brief:  プレースホルダ間の移動を有効にする
" " param:  -
" " Vim-LaTeXからプレーホルダ間の移動に関するコードを抜き出してカスタマイズしたやつ
" " snippetsEmu.vimが使えない環境のときにコメントアウトをはずすこと
" "---------------------------------------------------------------------- */
" let g:Imap_DeleteEmptyPlaceHolders = 1
" let s:RemoveLastHistoryItem = ':call histdel("/", -1)|let @/=g:Tex_LastSearchPattern'
" function! IMAP_Jumpfunc(direction, inclusive)
	" call KillTab()
	" " The user's placeholder settings.
	" let phsUser = "<+"
	" let pheUser = "+>"


	" let line = strpart(getline('.'), 0, col('.') - 1)
	" if line =~ '^\t*$'
		" " execute "normal a \<Esc>0i"
		" execute "normal a\<Esc>0i"
	" endif

	" let searchString = ''
	" " If this is not an inclusive search or if it is inclusive, but the
	" " current cursor position does not contain a placeholder character, then
	" " search for the placeholder characters.
	" if !a:inclusive || strpart(getline('.'), col('.')-1) !~ '\V\^'.phsUser
		" let searchString = '\V'.phsUser.'\_.\{-}'.pheUser
	" endif

	" " If we didn't find any placeholders return quietly.
	" if searchString != '' && !search(searchString, a:direction)
		" return ''
	" endif

	" " Open any closed folds and make this part of the text visible.
	" silent! foldopen!

	" " Calculate if we have an empty placeholder or if it contains some
	" " description.
	" let template = 
		" \ matchstr(strpart(getline('.'), col('.')-1),
		" \          '\V\^'.phsUser.'\zs\.\{-}\ze\('.pheUser.'\|\$\)')
	" let placeHolderEmpty = !strlen(template)

	" " If we are selecting in exclusive mode, then we need to move one step to
	" " the right
	" let extramove = ''
	" if &selection == 'exclusive'
		" let extramove = 'l'
	" endif

	" " Select till the end placeholder character.
	" " let movement = "\<C-o>v/\\V".pheUser."/e\<CR>".extramove
	" let movement = "\<C-o>v/\\V".pheUser."/e\<CR>".extramove

	" " First remember what the search pattern was. s:RemoveLastHistoryItem will
	" " reset @/ to this pattern so we do not create new highlighting.
	" let g:Tex_LastSearchPattern = @/

	" " Now either goto insert mode or select mode.
	" if placeHolderEmpty && g:Imap_DeleteEmptyPlaceHolders
		" " delete the empty placeholder into the blackhole.
		" " echo movement."\"_c\<C-o>:".s:RemoveLastHistoryItem."\<CR>"
		" return movement."\"_c\<C-o>:".s:RemoveLastHistoryItem."\<CR>"
	" else
		" " echo movement."\<C-\>\<C-N>:".s:RemoveLastHistoryItem."\<CR>gv\<C-g>"
		" return movement."\<C-\>\<C-N>:".s:RemoveLastHistoryItem."\<CR>gv\<C-g>"
	" endif
	
" endfunction

" " Maps for IMAP_Jumpfunc {{{
" "
" " These mappings use <Plug> and thus provide for easy user customization. When
" " the user wants to map some other key to jump forward, he can do for
" " instance:
" "   nmap ,f   <plug>IMAP_JumpForward
" " etc.

" " jumping forward and back in insert mode.
" imap <silent> <Plug>IMAP_JumpForward    <c-r>=IMAP_Jumpfunc('', 0)<CR>
" imap <silent> <Plug>IMAP_JumpBack       <c-r>=IMAP_Jumpfunc('b', 0)<CR>

" " jumping in normal mode
" nmap <silent> <Plug>IMAP_JumpForward        i<c-r>=IMAP_Jumpfunc('', 0)<CR>
" nmap <silent> <Plug>IMAP_JumpBack           i<c-r>=IMAP_Jumpfunc('b', 0)<CR>

" " deleting the present selection and then jumping forward.
" vmap <silent> <Plug>IMAP_DeleteAndJumpForward       "_<Del>i<c-r>=IMAP_Jumpfunc('', 0)<CR>
" vmap <silent> <Plug>IMAP_DeleteAndJumpBack          "_<Del>i<c-r>=IMAP_Jumpfunc('b', 0)<CR>

" " jumping forward without deleting present selection.
" vmap <silent> <Plug>IMAP_JumpForward       <C-\><C-N>i<c-r>=IMAP_Jumpfunc('', 0)<CR>
" vmap <silent> <Plug>IMAP_JumpBack          <C-\><C-N>`<i<c-r>=IMAP_Jumpfunc('b', 0)<CR>

" " }}}

" function! KillTab()
	" let line = strpart(getline('.'), 0, col('.') - 1)
	" if line =~ '^\t*$'
		" call setline(line("."),"")
	" endif
" endfunction

" " Default maps for IMAP_Jumpfunc {{{
" " map only if there is no mapping already. allows for user customization.
" " NOTE: Default mappings for jumping to the previous placeholder are not
" "       provided. It is assumed that if the user will create such mappings
" "       hself if e so desires.
" if !hasmapto('<Plug>IMAP_JumpForward', 'i')
	" imap <C-J> <Plug>IMAP_JumpForward
" endif
" if !hasmapto('<Plug>IMAP_JumpForward', 'n')
	" nmap <C-J> <Plug>IMAP_JumpForward
" endif
" if exists('g:Imap_StickyPlaceHolders') && g:Imap_StickyPlaceHolders
	" if !hasmapto('<Plug>IMAP_JumpForward', 'v')
		" vmap <C-J> <Plug>IMAP_JumpForward
	" endif
" else
	" if !hasmapto('<Plug>IMAP_DeleteAndJumpForward', 'v')
		" vmap <C-J> <Plug>IMAP_DeleteAndJumpForward
	" endif
" endif
" " }}}

" nmap <silent> <script> <plug><+SelectRegion+> `<v`>

" }}}

" vim: set foldmethod=marker: set fenc=utf-8:
"
