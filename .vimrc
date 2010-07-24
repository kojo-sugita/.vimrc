" Maintainer:       Kojo Sugita<kojo.sugita@gmail.com>
" Latest Revision:  2009-08-21

" {{{ Common setting
"/* --- �t�H���g, �w�i�F�ݒ� --- */
"�w�i�F
colorscheme rootwater

"�t�H���g�ݒ�
if has("unix")
	" set guifont=IPAMonaGothic\ 12
	" set guifontwide=IPAMonaGothic\ 12
	set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
	set guifontwide=Bitstream\ Vera\ Sans\ Mono\ 12
	set printfont=IPAMonaGothic\ 12
	autocmd GUIEnter * winpos 200 100
	autocmd GUIEnter * winsize 80 50

elseif has("gui_win32")
	" set guifont=HG�޼��M:h11
	" set guifontwide=HG�޼��M:h11
	set guifont=sazanami_gothic:h10
	set guifontwide=sazanami_gothic:h10
	set printfont=MS_Gothic:h11:cSHIFTJIS
	autocmd GUIEnter * winpos 200 100
	autocmd GUIEnter * winsize 100 50
endif

"/* --- �\�� --- */
syntax on           "�V���^�b�N�X�L��

set number          "�s�ԍ���\��
set laststatus=2    "�X�e�[�^�X���C����\��
set showcmd         "���͒��̃R�}���h���X�e�[�^�X�ɕ\������
set ruler           "���݂̃J�[�\���ʒu��\��
set wrap! = nowrap  "�܂�Ԃ����Ȃ�
set foldmethod=marker "�܂肽���݂�L���ɂ���

"/* --- �����ݒ� --- */
set hlsearch        "�������ʕ�����̃n�C���C�g��L���ɂ���
set ignorecase      "�啶������������ʂȂ���������
set smartcase       "����������ɑ啶�����܂܂�Ă���ꍇ�͋�ʂ��Č�������
set incsearch       "�C���N�������^���T�[�`

"�I��͈͓����猟���ł���悤�ɂ���
vnoremap <silent> / :<C-U>call RangeSearch('/')<CR>:if  strlen(g:srchstr) > 0\|exec '/'.g:srchstr\|endif<CR>
vnoremap <silent> ? :<C-U>call RangeSearch('?')<CR>:if strlen(g:srchstr) > 0\|exec '?'.g:srchstr\|endif<CR>

"/* --- "���ʂ̐ݒ� --- */
set showmatch       "���ʂ̑Ή��\��

"���ʂ����͂��ꂽ�Ƃ��Ɏ����I�ɕ����ʂ���͂���
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap { {}<LEFT>

"/* --- �C���f���g, Tab����, EOF�Ȃǂ̐ݒ� --- */
set autoindent      "�����C���f���g
set smartindent     "�����C���f���g
set shiftwidth=4    "autoindent���ɑ}�������^�u�̕�
set tabstop=4       "�^�u���̐ݒ�
set list            "Tab������AEOF��\��

"tab������AEOL��ύX
set lcs=tab:..,eol:<,extends:\

"�S�p�X�y�[�X, �s�����p�X�y�[�X�̐F�ς�
if has("syntax")
	syntax on
	function! ActivateInvisibleIndicator()
		"�S�p�X�y�[�X��\��
		syntax match InvisibleJISX0208Space "�@" display containedin=ALL
		highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=#6666ff
		"�s���̔��p�X�y�[�X��\��
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

"/* --- �����N�̐ݒ� --- */
"�I�������͈͂ɍs�ԍ������ă��W�X�^ * �Ƀ����N
vnoremap \y :call YankWithLineNumber()<CR>

"�������W�X�^�ɓ���f�[�^���A*���W�X�^�ɂ������B
set clipboard+=unnamed

"/* --- �����R�[�h --- */
" �����R�[�h�̎����F��(http://www.kawaz.jp/pukiwiki/?vim#g59923b3���璸��)
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconv��eucJP-ms�ɑΉ����Ă��邩���`�F�b�N
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
		" iconv��JISX0213�ɑΉ����Ă��邩���`�F�b�N
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodings���\�z
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
	" �萔������
	unlet s:enc_euc
	unlet s:enc_jis
endif
" ���{����܂܂Ȃ��ꍇ�� fileencoding �� encoding ���g���悤�ɂ���
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" ���s�R�[�h�̎����F��
set fileformats=unix,dos,mac
" ���Ƃ����̕����������Ă��J�[�\���ʒu������Ȃ��悤�ɂ���
if exists('&ambiwidth')
	set ambiwidth=double
endif

"���{��ݒ�
if has('multi_byte_ime') || has('xim')
    " ���{�����ON���̃J�[�\���̐F��ݒ�
    highlight CursorIM guibg=Red guifg=NONE
endif


"/* --- ���̑��ҏW --- */
"�\���s�P�ʂňړ�
noremap j gj
noremap k gk
vnoremap j gj
vnoremap k gk

" �C���T�[�g���[�h�Ńo�b�N�X�y�[�X���������Ƃ��̑΍�
"noremap ^? 
"noremap! ^? 
"noremap 
"noremap!  

"�O��ړ���Emacs�̂悤�ȃL�[�o�C���h�ɂ���
inoremap <C-f> <Right>
inoremap  <Right>
inoremap <C-b> <Left>
inoremap  <Left>

"/* --- ���̑� --- */
filetype plugin on  "�t�@�C���^�C�v�v���O�C����L���ɂ���
set vb t_vb=        "�r�[�v�����Ȃ炳�Ȃ�
set guioptions=F    "GUI�I�v�V����
set nobackup        "�o�b�N�A�b�v���Ȃ�
set autoread        "�ҏW���ꂽ��ǂݒ���
set wildchar=<Tab>  "Tab�ŕ⊮�ł���悤�ɂ���
set nocompatible    "VI�݊����I�t

"complete��������
au FileType * set complete=.,w,b,u,t,i

"<Leader>��\�ɂ���
let mapleader = '\'

"�A������󔒍s�����k����
nnoremap <silent> <C-x><C-o> :call DeleteBlankLines()<CR>

".vimrc�̍ēǂݍ���
if has("unix")
	noremap <C-F12> :source ~/.vimrc<CR>
elseif has("gui_win32")
	noremap <C-F12> :source $VIM/_gvimrc<CR>
endif

" ����: ���̓��e��:filetype on������ɋL�q���邱�ƁB
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
	"Windows�o�b�`�t�@�C���̎����t�@�C�����Z�b�g
	set dictionary=$VIMRUNTIME/dict/dosbatch.dict

	"���s
	noremap <F5> <Esc>:! %<Enter>

endfunction
" }}}
" {{{ VBScript
function! VBScriptSettings()
	"VBScript�̎����t�@�C�����Z�b�g
	set dictionary=$VIMRUNTIME/dict/vbscript.dict,$VIMRUNTIME/dict/wsh.dict

	"Enter�������ꂽ�Ƃ��Ɏ����⊮����
	inoremap <expr> <CR> AutoEndForVBScript()

	"���s
	noremap <F5> <Esc>:! %<Enter>

endfunction
" }}}
" {{{ C,C++,Java,JavaScript commonness
function! CCommonSettings()

	set cindent

	"�L�[�}�b�v��ύX
	inoremap <expr> ; GetSemicolonForC()
	inoremap <expr> { GetBraceForC()
	inoremap <expr> " GetDoubleQuotes()
	inoremap <expr> ' GetSingleQuotesForC()
	inoremap <expr> <Space> GetSpace()
	inoremap , ,<Space>

	"�֐���͈͑I��(VimWiki���)
	nnoremap vf ][v[[?^?s*$<CR>

	"�u���b�N�I��(VimWiki���)
	nnoremap vb /{<CR>%v%0

endfunction

"
" }}}
" {{{ C
function! CSettings()
	"c�̎����t�@�C�����Z�b�g
	if has("unix")
		set dictionary=$HOME/.vim/dict/c.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/c.dict
	endif
	"�I���j�⊮
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

	"gcc�R���p�C���ݒ�
	nmap <F5> :call MakeC_gcc()<cr>

	"bcc�R���p�C���ݒ�
	nmap <F6> :call MakeC_bcc()<cr>

	set nowrap tabstop=4 tw=0 sw=4 expandtab

endfunction
" }}}
" {{{ C++
function! CppSettings()
	"C++����̃L�[���[�h���n�C���C�g
	:let java_allow_cpp_keywords=1
endfunction
" }}}
" {{{ Java
function! JavaSettings()
	"java�̎����t�@�C�����Z�b�g
	if has("unix")
		set dictionary=$HOME/.vim/dict/j2se14.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/j2se14.dict
	endif

	"�n�C���C�g
	:let java_highlight_all=1 "Java����̕W���̃N���X�����n�C���C�g
	:let java_highlight_debug=1 "�f�o�b�O���̃n�C���C�g
	:let java_space_errors=1 "�]���ȋ󔒂ɑ΂��ăn�C���C�g
	:let java_highlight_functions=1 "���\�b�h�錾�����n�C���C�g

	"�R���p�C���ݒ�(Java)
	compiler javac

	"�R���p�C��
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
	"JavaScript�̎����t�@�C�����Z�b�g
	if has("unix")
		set dictionary=$HOME/.vim/dict/javascript.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/javascript.dict
	endif

	"�I���j�⊮
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=javascriptcomplete#CompleteJS
	endif

endfunction
" }}}
" {{{ Objective-C
function! ObjectiveCSettings()
	"gcc�R���p�C���ݒ�
	nmap <F5> :call MakeObjectiveC_gcc()<cr>
endfunction
" }}}
" {{{ Ruby
function! RubySettings()
	"Ruby�̂Ƃ��́A�^�u����2�ɐݒ� & �^�u�����̑���ɓ������̋󔒕���������
	set nowrap tabstop=2 tw=0 sw=2 expandtab

	"�R���p�C���ݒ�(RUBY)
	compiler ruby

	nmap <F5> :call DebugRuby()<cr>

	"<F6>�Ńo�b�t�@��Ruby�X�N���v�g�����s���A���ʂ��v���r���[�\��
	vmap <silent> <F6> :call Ruby_eval_vsplit()<CR>
	nmap <silent> <F6> mzggVG<F6>`z
	map  <silent> <S-F6> :pc<CR>

	"<C-F10>��Ruby�X�N���v�g��ۑ���R�}���h�v�����v�g������s
	nmap <silent> <C-F6> :w<CR>:!ruby %<CR>
endfunction
" }}}
" {{{ HTML,XHTML,XML,XUL commonness
function! TagCommonSettings()

	"�^�u����2�ɐݒ�
	set nowrap tabstop=2 tw=0 sw=2

	inoremap <expr> " GetDoubleQuotes()
	inoremap <buffer> < <><LEFT>

	"��Ǔ_��.��,�ɕϊ�����
	nmap <F12> :call ConvertHTMLPunctuation()<CR>

endfunction
" }}}
" {{{ HTML
function! HTMLSettings()

	"�}�[�N�A�b�v�L����⊮����
	inoremap <buffer> \" &quot;
    inoremap <buffer> \& &amp;
    inoremap <buffer> \< &lt;
    inoremap <buffer> \> &gt;
    inoremap <buffer> \<Space> &nbsp;

	"<F5>��Html��\������
	nmap <F5> :! %<CR>
	" noremap <Leader>W :silent !start firefox %<CR>
	" noremap <F5> :silent !start firefox %<CR>

	"�I���j�⊮
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=htmlcomplete#CompleteTags
	endif

endfunction
" }}}
" {{{ Cascading Style Sheets
function! CssSettings()

	"�^�u����2�ɐݒ�
	set nowrap tabstop=2 tw=0 sw=2

	"�I���j�⊮
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=csscomplete#CompleteCSS
	endif

	"�L�[�}�b�v�ύX
	inoremap ; ;<CR>
	inoremap : : 
	inoremap { {<CR>}<Esc>0bo
	
endfunction
" }}}
" {{{ XML
function! XmlSettings()

	"�I���j�⊮
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=xmlcomplete#CompleteTags
	endif
endfunction
" }}}
" {{{ XUL
function! XulSettings()
	set filetype=xul

	"XUL�̎����t�@�C�����Z�b�g
	if has("unix")
		set dictionary=$HOME/.vim/dict/xul.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/xul.dict
	endif

	"�I���j�⊮
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=xmlcomplete#CompleteTags
	endif
endfunction
" }}}
" {{{ Perl
function! PerlSettings()
	compiler perl
	"Perl�̎����t�@�C�����Z�b�g
	if has("unix")
		set dictionary=$HOME/.vim/dict/perl.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/perl.dict
	endif

	"�L�[�}�b�v��ύX
	nmap <F5> :call MakePerl()<CR>
	nmap <F6> :! perl %<CR>

endfunction

" }}}
" {{{ Python
function! PythonSettings()
	"�I���j�⊮
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=pythoncomplete#Complete
	endif
endfunction
" }}}
" {{{ PHP
function! PHPSettings()
	"�����t�@�C���̐ݒ�
	if has("unix")
		set dictionary=$HOME/.vim/dict/PHP.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/PHP.dict
	endif

	"�I���j�⊮
	if has("autocmd") && exists("+omnifunc")
		"<C-x><C-o>
		set omnifunc=phpcomplete#CompletePHP
	endif

endfunction
" }}}
" {{{ LaTeX
function! LaTeXSettings()

	"�l�����Z
	inoremap <buffer> \* \times 
	inoremap <buffer> \/ \div 
	inoremap <buffer> \= \equiv 
	inoremap <buffer> \!= \neq 

	"���̑����Z�q
	inoremap <buffer> \<= \leq 
	inoremap <buffer> \>= \geq 
	inoremap <buffer> \<< \ll 
	inoremap <buffer> \>> \gg 
	inoremap <buffer> \+- \pm 
	inoremap <buffer> \-+ \mp 

	"�������[�h
	inoremap $ $$<LEFT>
	" inoremap _ _{}<LEFT>
	" inoremap ^ ^{}<LEFT>

	"LaTeX�̂Ƃ��́A�^�u����2�ɐݒ� & �^�u�����̑���ɓ������̋󔒕���������
	set nowrap tabstop=2 tw=0 sw=2 expandtab

	"�����t�@�C���̐ݒ�
	if has("unix")
		set dictionary=$HOME/.vim/dict/tex.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/tex.dict
	endif

	"LaTeX���R���p�C��
	nmap <C-F5> :! platex %<CR>

	"PDF�ϊ�
	nmap <C-F6> :! dvipdfmx %<<CR>

	"��Ǔ_��.��,�ɕϊ�����
	nmap <F12> :call ConvertTexPunctuation()<CR>

	"/* -- VIM-LaTeX�p�ݒ� -- */
	set shellslash

	" grep�������Ă���ꍇ
	set grepprg=grep\ -nH\ $*

	" OPTIONAL: This enables automatic indentation as you type.
	filetype indent on

	" dvi�t�@�C�������R�}���h
	let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'

	" dvi�t�@�C���r���[���[
	let g:Tex_ViewRule_dvi = 'dviout' 

	" pdf����
	let g:Tex_FormatDependency_pdf = 'dvi,pdf'
	let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
	let g:Tex_ViewRule_pdf = 'C:\Program Files\Adobe\Acrobat 7.0\Acrobat\Acrobat.exe' 

	" jbitex�ݒ�
	let g:Tex_BibtexFlavor = 'jbibtex -kanji=sjis'

endfunction
" }}}
" {{{ Assembly
function! AssemblySettings()

	"�^�u����8�ɐݒ�
	set nowrap tabstop=8 tw=0 sw=8

endfunction
" }}}
" {{{ Scheme
function! SchemeSettings()
	
	"�^�u����2�ɐݒ�
	" set nowrap tabstop=2 tw=0 sw=2

	"�����t�@�C���̐ݒ�
	if has("unix")
		set dictionary=$HOME/.vim/dict/R5RS.dict
	elseif has("gui_win32")
		set dictionary=$VIMRUNTIME/dict/R5RS.dict
	endif

	"�C���f���g�̐ݒ�(�{�N�m�X�lhttp://d.hatena.ne.jp/tanakaBox/20070609/1181382818��蒸��)
	set nocindent
	set lisp
	set lispwords=define

	inoremap <expr> <Space> GetSpace()

endfunction
" }}}
" {{{ Text
function! TextSettings()
	set nocindent
	"�^�u����2, �^�u�����̕ς��ɃX�y�[�X
	set nowrap tabstop=2 tw=0 sw=2 expandtab
endfunction
" }}}
" {{{ Gnuplot
function! GnuplotSettings()
	"Gnuplot�̎����t�@�C�����Z�b�g
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
" brief:  �I�������͈͂ɍs�ԍ������ă��W�X�^ * �Ƀ����N����
" param:  -
" #http://vimwiki.net/?tips%2F91��蒸��
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
" brief:  Emacs �� delete-blank-lines �����̊֐�
" param:  -
" #http://vimwiki.net/?tips%2F88��蒸��
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
" param:  fieldsep �t�B�[���h�̃Z�p���[�^(���K�\��)
"         minlensep �t�B�[���h�̃Z�p���[�^�̍ŏ��̒���
"         padstr ���̃t�B�[���h�܂ł̊Ԋu�𖄂߂镶��  
"         offset ���̃t�B�[���h�̐擪���牽�����ڂɃW�����v���邩�̃I�t�Z�b�g
" #http://vimwiki.net/?tips%2F46��蒸��
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
" brief:  �I��͈͓����猟��
" param:  �����L�[
" #http://vimwiki.net/?tips%2F45��蒸��
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
" brief:  C����n(C,C++,Java,JavaScript)�̃Z�~�R�����ݒ�(�ďo����)
"         �Z�~�R�����������ꂽ�Ƃ��Ɉꏏ�ɉ��s����悤�ɂ���B
" param:  -
" return: ; or ;+���s
"---------------------------------------------------------------------- */
function! GetSemicolonForC()
	";+���s or ;
	return AutoSemicolonEnterForC()
endfunction

"/* ----------------------------------------------------------------------
" brief:  C����n(C,C++,Java,JavaScript)�̃Z�~�R�����ݒ�
"         �Z�~�R�����������ꂽ�Ƃ��Ɉꏏ�ɉ��s����悤�ɂ���B
" param:  -
" return: ; or ;+���s
"---------------------------------------------------------------------- */
function! AutoSemicolonEnterForC()
	let line = strpart(getline('.'), 0, col('.') - 1)

	" if line =~ '^\t*for \=('
	if line =~ '^[\t| ]*for \=('
		"for�����L�q��
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
" brief:  {�����͂��ꂽ�Ƃ��ɉ��s+�����ʂ�⊮����
" param:  -
" return: {} or { + ���s + }
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
" brief:  ���ʓ��ŃX�y�[�X�������ꂽ�ꍇ�ɁA( ���R�R�ɃJ�[�\�� )��Ԃɂ���
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
" brief:  �����񒆂ɂ��錟�����[�h���}�b�`����������Ԃ�
" param:  �s, ����������
" return: �}�b�`��������
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
" brief:  �J���_�u���N�H�[�g�����͂��ꂽ�Ƃ��ɕ��_�u���N�H�[�g��}������
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
" brief:  �J���V���O���N�H�[�g�����͂��ꂽ�Ƃ��ɕ��V���O���N�H�[�g��}������
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
" brief:  �_�u���N�H�[�e�[�V�����̑��݃`�F�b�N
" param:  �s
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
" brief:  �V���O���N�H�[�g�̑��݃`�F�b�N
" param:  �s
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
" brief:  VBScript��End XXX�������I�ɕ⊮����
" param:  -
" return: ���s or End XXX
"---------------------------------------------------------------------- */
function! AutoEndForVBScript()
	let line = strpart(getline('.'), 0, col('.') - 1)

	if strlen(line) != strlen(getline('.'))
		return "\<CR>"
	endif

	"�|�b�v�A�b�v���j���[���\������Ă��邩?
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
" brief:  gcc�R���p�C���ݒ�
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
" brief:  bcc�R���p�C���ݒ�
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
" brief:  Java�R���p�C���ݒ�
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! MakeJava()
	:make %
	:cw
endfunction

"�f�o�b�O
function! DebugRuby()
	:make -Ks %
	:cw
endfunction

"/* ----------------------------------------------------------------------
" brief:  perl�V���^�b�N�X�G���[�ݒ�
" param:  -
" return: -
"---------------------------------------------------------------------- */
function! MakePerl()
	:make % -c
	:cw
endfunction

"/* ----------------------------------------------------------------------
" brief:  gcc�R���p�C���ݒ� (Objective-C)
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
" brief:  ��Ǔ_��.��,�ɕϊ�����(Tex)
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
		:%s/�B/�D/g
		:%s/�A/�C/g
	endif

endfunction

"/* ----------------------------------------------------------------------
" brief:  ��Ǔ_��.��,�ɕϊ�����(HTML)
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
		:%s/�B/. /g
		:%s/�A/, /g
	endif

endfunction
" }}}
" {{{ Alternate functions

" " /* ----------------------------------------------------------------------
" " brief:  C����n(C,C++,Java,JavaScript)�̃Z�~�R�����ݒ�(�ďo����)
		" " �Z�~�R�����������ꂽ�Ƃ��Ɉꏏ�ɉ��s����悤�ɂ���B
" " param:  -
" " return: ; or ;+���s
" " snippetsEmu.vim���g���Ȃ����̂Ƃ��ɗL���ɂȂ��Ă���GetSemicolonForC�ƍ����ւ��邱��
" " ---------------------------------------------------------------------- */
" function! GetSemicolonForC()
	" "�����I��(){}��t�^����
	" let result =  AutoEndForC()
	" if result == "NF"
		" ";+���s or ;
		" return AutoSemicolonEnterForC()

	" endif

	" return result

" endfunction

" "/* ----------------------------------------------------------------------
" " brief:  C����n(C,C++,Java,JavaScript)��if���� for���̓��͕⏕
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
" " brief:  switch-case������:��:+�����͂��ꂽ�Ƃ���+���s���s��
" " param:  -
" " return: : or :+���s+break;
" " snippetsEmu.vim���g���Ȃ����̂Ƃ��ɃR�����g�A�E�g���͂�������
" "---------------------------------------------------------------------- */
" function! GetColonForC()
	" let line = strpart(getline('.'), 0, col('.') - 1)

	" "switch����case or default���L�q����?
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
" " brief:  �v���[�X�z���_�Ԃ̈ړ���L���ɂ���
" " param:  -
" " Vim-LaTeX����v���[�z���_�Ԃ̈ړ��Ɋւ���R�[�h�𔲂��o���ăJ�X�^�}�C�Y�������
" " snippetsEmu.vim���g���Ȃ����̂Ƃ��ɃR�����g�A�E�g���͂�������
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
