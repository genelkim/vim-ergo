" Vim Syntax File
"
" Language:    ergo
" Maintainers: Aleksandar Dimitrov <aleks.dimitrov@googlemail.com>
" Created:     Jul 31st, 2008
" Changed:     Fri Aug  1 2008
" Remark:      This file mostly follows
"              http://www.sics.se/sicstus/docs/3.7.1/html/sicstus_45.html
"              but also features some SWI-specific enhancements.
"              The BNF cannot be followed strictly, but I tried to do my best.
"
" TODO:        - Difference Lists
"              - Constraint logic programming

if version < 600
   syn clear
elseif exists("b:current_syntax")
  finish
endif

syntax case match

syntax keyword prologISOBuiltIn   var nonvar integer float number atom string
      \ atomic compound unify_with_occurs_check fail false true repeat call once
      \ catch throw abolish retract asserta assertz current_predicate clause open
      \ close stream_property set_stream_position set_input set_output current_ouput
      \ nl put_byte put_char put_code flush_output get_byte get_code get_char
      \ peek_byte peek_code peek_char at_end_of_stream write_term write_canonical
      \ write writeq read read_term functor arg copy_term atom_codes atom_chars
      \ char_code number_chars number_codes atom_length sub_atom op current_op
      \ char_conversion current_char_conversion is mod rem div round float
      \ float_fractional_part float_integer_part truncate floor ceiling sqrt sin cos
      \ atan log findall bagof setof sub_atom

syntax keyword prologSWIBuiltIn   rational callable ground cyclic_term subsumes subsumes_chk
      \ unifiable use_module compare apply not ignore call_with_depth_limit call_cleanup
      \ print_message print_message_lines message_hook on_signal current_signal block exit
      \ term_hash redefine_system_predicate retractall assert recorda recordz recorded
      \ erase flag compile_predicates index current_atom
      \ current_blob current_functor current_flag current_key dwim_predicate nth_clause
      \ predicate_property open_null_stream current_stream is_stream stream_position_data
      \ seek set_stream see tell append seeing telling seen set_prolog_IO told
      \ wait_for_input byte_count character_count line_count line_position read_clause
      \ put tab ttyflush get0 get skip get_single_char copy_stream_data print portray
      \ read_history prompt setarg nb_setarg nb_linkarg duplicate_term numbervars
      \ term_variables atom_number name term_to_atom atom_to_term atom_concat
      \ concat_atom atom_prefix normalize_space collation_key char_type string_to_list
      \ code_type downcase_atom upcase_atom collation_key locale_sort string_to_atom
      \ string_length string_concat sub_string between succ plus rdiv max min random
      \ integer rationalize ceil xor tan asin acos pi e cputime eval msb lsb popcount
      \ powm arithmetic_function current_arithmetic_function is_list memberchk length
      \ sort msort keysort predsort merge merge_set maplist forall writeln writef
      \ swritef format format_predicate current_format_predicate tty_get_capability
      \ tty_goto tty_put set_tty tty_size shell win_exec win_shell win_folder
      \ win_registry_get_value getenv setenv unsetenv setlocale unix date time
      \ get_time stamp_date_time date_time_stamp date_time_value format_time
      \ parse_time window_title win_window_pos win_has_menu win_insert_menu
      \ win_insert_menu_item access_file exists_file file_directory_name file_base_name
      \ same_file exists_directory delete_file rename_file size_file time_file
      \ absolute_file_name is_absolute_file_name file_name_extension expand_file_name
      \ prolog_to_os_filename read_link tmp_file make_directory working_directory chdir
      \ garbage_collect garbage_collect_atoms trim_stacks stack_parameter dwim_match
      \ wildcard_match sleep qcompile portray_clause acyclic_term clause_property
      \ setup_and_call_cleanup message_to_string phrase hash with_output_to fileerrors
      \ read_pending_input prompt1 same_term sub_string merge_set

syntax cluster prologBuiltIn      contains=prologSWIBuiltIn,prologISOBuiltIn

syntax match   ergoArithmetic   /\*\*\?\|+\|\/\/\?\|\/\\\|<<\|>>\|\\\/\?\|\^/
      \ contained containedin=ergoBody

"syntax match   ergoRelations    /=\.\.\|!\|=:=\|=\?<\|=@=\|=\\=\|>=\?\|@=\?<\|@>=\?\|\\+\|\\\?=\?=\|\\\?=@=\|=/
"      \ contained containedin=ergoBody

"syntax match   ergoRelations    /\\\|=\|:-\|?-\|:\|<\|>\|\/\|-/
syntax match   ergoRelations    /\\\|=\|:-\|?-\|:\|@\|<\|>\|\/\|-/
      \ contained containedin=ergoBody
syntax match   ergoLogicalKeywords /\\naf\|\\neg\|\\+\|\\and\|\\or\|\\isa\|\\is\|\\memberof\|\\sub\|\\subclassof\|\\hastype\|\\hasvalue\|\\contains/
      \ contained containedin=ergoBody
syntax match   ergoSpecConnective /->\|+>>\|->->\|-->>\|=>/
      \ contained containedin=ergoSpecBody
syntax match   ergoStmtEnd     /\zs\.\ze\s*\(\(%\|\/\/\).*\)\?$/
      \ contained containedin=ergoBody

syntax region  ergoCComment     fold start=/\/\*/ end=/\*\// contains=ergoTODO,@Spell
syntax match   ergoComment       /\/\/.*/ contains=ergoTODO,@Spell
syntax region  ergoCommentFold  fold start=/^\zs\s*%/ skip=/^\s*%/ end=/^\ze\s*\([^%]\|$\)/ contains=ergoComment
syntax match   prologComment      /%.*/ contains=ergoTODO,@Spell
syntax region  prologCommentFold fold start=/^\zs\s*%/ skip=/^\s*%/ end=/^\ze\s*\([^%]\|$\)/ contains=prologComment
syntax keyword ergoTODO         FIXME TODO fixme todo Fixme FixMe Todo ToDo XXX xxx contained
syntax cluster ergoComments     contains=ergoCComment,ergoComment,ergoCommentFold,prologComment,prologCommentFold

syntax match   ergoNumber       /\<\d\+\>/ contained
syntax match   ergoNumber       /\<\d\+\.\d\+\>/ contained
syntax match   ergoAtom         /\<\l\w*\>\ze\([^(]\|$\)/ contained
"syntax match   ergoVariable     /?[^\W-]?\w+/ contained
syntax match   ergoAnonymousVariable     /?\(_[a-zA-Z-0-9]*\)\?\ze\($\|[^-]\)/ contained
syntax match   ergoVariable     /?[a-zA-Z_0-9]\+/ contained contains=ergoAnonymousVariable

syntax match   ergoTag          /@\(@\|!\)\?{[a-zA-Z0-9_]*}/

syntax region  ergoBody         fold start=/\(:-\|?-\|\)/ end=/\./
      \ contains=@ergoAll,ergoPredicateWithArity
syntax region  ergoDCGBody      fold start=/-->/ end=/\./
      \ contains=@ergoAll,ergoDCGSpecials
syntax region  ergoSpecBody     fold start=/\[/ end=/\]/
      \ contains=@ergoAll

syntax match   ergoHead         /\<\l\w*\>/ nextgroup=ergoBody,ergoDCGBody skipwhite
syntax region  ergoHeadWithArgs start=/\<\l\w*\>(/ end=/)/ nextgroup=ergoBody,ergoDCGBody contains=@ergoAll

"syntax match  ergoOpStatement   /indexed\|discontiguous\|dynamic\|module_transparent\|multifile\|volatile\|initialization/
"      \ containedin=ergoBody contained

syntax region  ergoDCGSpecials  start=/{/ end=/}/ contained contains=@ergoAll

"syntax region  ergoTuple        fold start=/\W\zs(/ end=/)/ contained containedin=ergoPredicate,ergoBody contains=@ergoAll
syntax region  ergoPredicate    start=/\<\l\w*\>\ze(/ end=/)/ contains=@ergoAll
syntax match   ergoPredicateWithArity /\<\l\w*\>\/\d\+/ contains=@ergoBuiltIn,ergoArity
syntax match   ergoArity        contained /\/\d\+/
syntax cluster ergoPredicates   contains=ergoPredicate,ergoPredicateWithArity

"syntax region  ergoList         start=/\[/ end=/\]/ contains=ergoListDelimiters,@ergoAll,ergoPredicateWithArity contained
"syntax match   ergoListDelimiters /[,|]/ contained

"syntax cluster ergoAll          contains=ergoList,ergoPredicate,ergoTuple,@ergoTerms,@ergoComments,ergoQuoted,@ergoBuiltIn,ergoRelations,ergoArithmetic,ergoDiffList
"syntax cluster ergoTerms        contains=ergoVariable,ergoAtom,ergoList,
      \ergoNumber,ergoErrorTerm,ergoAnonymousVariable
syntax cluster ergoAll          contains=ergoPredicate,@ergoTerms,@ergoComments,ergoQuoted,@ergoBuiltIn,ergoRelations,ergoArithmetic,ergoDiffList,ergoSpecConnective,ergoLogicalKeywords,ergoTag
syntax cluster ergoTerms        contains=ergoVariable,ergoAtom,
      \ergoNumber,ergoErrorTerm,ergoAnonymousVariable

syntax match   ergoQuotedFormat /\~\(\d*[acd\~DeEgfGiknNpqrR@st\|+wW]\|`.t\)/ contained
syntax region  ergoQuoted       start=/'/ end=/'/ skip=+\\'+ contains=ergoQuotedFormat,@Spell

"syntax match   ergoErrorVariable /\<\(_\|\u\)\w*\>/
"syntax region  ergoErrorTerm    start=/\<\(_\|\u\)\w*\>(/ end=/)/

"""" Highlights

highlight link ergoErrorVariable Error
highlight link ergoErrorTerm     Error

"highlight link ergoOpStatement  Preproc
highlight link ergoComment      Comment
highlight link ergoCComment     Comment
highlight link prologComment    Comment
highlight link ergoTODO         TODO

highlight link ergoAtom         Normal
highlight link ergoVariable     Identifier
highlight link ergoAnonymousVariable Identifier
highlight link ergoNumber       Number

"highlight link prologISOBuiltIn   Keyword
"highlight link prologSWIBuiltIn   Keyword

highlight link ergoLogicalKeywords  Keyword
highlight link ergoRelations        Statement
highlight link ergoSpecConnective   Statement
highlight link ergoStmtEnd          Keyword

highlight link ergoTag          Special

highlight link ergoQuotedFormat Special
highlight link ergoQuoted       String

highlight link ergoPredicate    Normal
highlight link ergoPredicateWithArity Normal
highlight link ergoHead         Normal
highlight link ergoHeadWithArgs Normal

"highlight link ergoBody         Statement
"highlight link ergoDCGBody      Statement

"highlight link ergoList         Type
"highlight link ergoListDelimiters Type
"highlight link ergoTuple        Type
highlight link ergoArity        Type
highlight link ergoDCGSpecials  Type
highlight link ergoDiffList     Type

syn sync minlines=20 maxlines=50

let b:current_syntax = "ergo"
