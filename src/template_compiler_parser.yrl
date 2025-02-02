%%%-------------------------------------------------------------------
%%% File:      erlydtl_parser.erl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @author    Evan Miller <emmiller@gmail.com>
%%% @copyright 2008 Roberto Saccon, Evan Miller
%%% @copyright 2009-2016 Marc Worrell
%%% @doc Template language grammar
%%% @changes Marc Worrell - added print/image/scomp, more args options etc.
%%% @end  
%%%
%%% The MIT License
%%%
%%% Copyright (c) 2007 Roberto Saccon, Evan Miller
%%% Copyright (c) 2009-2016 Marc Worrell
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.
%%%
%%% @since 2007-11-11 by Roberto Saccon, Evan Miller
%%%-------------------------------------------------------------------
%%%
%%%-------------------------------------------------------------------
%%% Adapted and expanded for Zotonic by Marc Worrell <marc@worrell.nl>
%%%-------------------------------------------------------------------

Nonterminals
    Template
    Elements
    BlockElements
    Literal

    ValueBraced
    OptWith

    ExtendsTag
    OverrulesTag
    InheritTag
    
    IncludeTag
    CatIncludeTag
    NowTag

    BlockBlock
    BlockBraced
    EndBlockBraced

    CommentBlock
    CommentBraced
    EndCommentBraced

    CycleTag
    CycleNames
    CycleNamesCompat

    FilterBlock
    FilterBraced
    EndFilterBraced
    Filters
    
    ScriptBlock
    ScriptBraced
    EndScriptBraced

    ForBlock
    ForBraced
    EmptyBraced
    EndForBraced
    ForExpression
    ForGroup

    IfBlock
    IfBraced
    ElsePart
    ElifList
    ElifBraced
    ElseBraced
    EndIfBraced

    IfEqualBlock
    IfEqualBraced
    IfEqualExpression
    EndIfEqualBraced  
    
    IfNotEqualBlock
    IfNotEqualBraced
    IfNotEqualExpression
    EndIfNotEqualBraced      

    AutoEscapeBlock
    AutoEscapeBraced
    EndAutoEscapeBraced

    WithBlock
    WithBraced
    EndWithBraced
    
    Value
    TermValue
    Variable
    Filter
    FilterArgs
    AutoId

    ModelCall
    OptModelArg
    
    LibTag
    LibUrlTag
    LibList
    
    LoadTag
    LoadNames
    
    CustomTag
    WithArgs
    Args
    SpacelessBlock

    CallTag
    CallWithTag

    CacheBlock
    CacheBraced
    EndCacheBraced
    OptCacheTime

    UrlTag
    PrintTag
    ImageTag
    ImageUrlTag
    ImageDataUrlTag
    MediaTag
    TransTag
    TransExtTag
    ValueList
    OptArrayList
    ArrayList

    MapFieldList
    MapFields
    MapField

    OptionalPrefix
    OptionalAll

    OptAsPart
    OptE
    E
    Uminus
    Unot.

Terminals
    all_keyword
    as_keyword
    atom_literal
    autoescape_keyword
    block_keyword
    cache_keyword
    call_keyword
    catinclude_keyword
    close_tag
    close_var
    comment_keyword
    colon
    colons
    comma
    cycle_keyword
    dot
    else_keyword
    elif_keyword
    empty_keyword
    endautoescape_keyword
    endblock_keyword
    endcache_keyword
    endcomment_keyword
    endfilter_keyword
    endfor_keyword
    endif_keyword
    endifequal_keyword
    endifnotequal_keyword
    endjavascript_keyword
    endspaceless_keyword
    endwith_keyword
    equal
    extends_keyword
    filter_keyword
    for_keyword
    identifier
    if_keyword
    ifequal_keyword
    ifnotequal_keyword
    image_keyword
    image_url_keyword
    image_data_url_keyword
    in_keyword
    include_keyword
    inherit_keyword
    lib_keyword
    lib_url_keyword
    load_keyword
    m_keyword
    media_keyword
    not_keyword
    now_keyword
    number_literal
    open_tag
    open_var
    optional_keyword
    overrules_keyword
    pipe
    print_keyword
    trans_keyword
    javascript_keyword
    spaceless_keyword
    string_literal
    text
    url_keyword
    with_keyword
    open_curly
    close_curly
    open_map
    open_bracket
    close_bracket
    open_trans
    trans_text
    close_trans
    trans_literal
    or_keyword
    xor_keyword
    and_keyword
    hash
    '==' '/=' '<' '>' '=<' '>='
    '++' '--'
    '+' '-'
    '*' '/' '%'
    '(' ')'.

Rootsymbol
    Template.

%% Operator precedences for the E non terminal
Left 100 or_keyword.
Left 105 xor_keyword.
Left 110 and_keyword.
Nonassoc 300 '==' '/=' '<' '>' '=<' '>='.
Left 350 '++' '--'.
Left 400 '+' '-'.
Left 500 '*' '/' '%'.
Unary 600 Uminus Unot.

%% Expected shift/reduce conflicts
Expect 5.

Template -> ExtendsTag BlockElements : {extends, '$1', '$2'}.
Template -> OverrulesTag BlockElements : {overrules, '$2'}.
Template -> Elements : {base, '$1'}.

BlockElements -> '$empty' : [].
BlockElements -> BlockElements BlockBlock : '$1' ++ ['$2'].
BlockElements -> BlockElements text : '$1'.
BlockElements -> BlockElements CommentBlock : '$1'.

Elements -> '$empty' : [].
Elements -> Elements text : '$1' ++ ['$2'].
Elements -> Elements ValueBraced : '$1' ++ ['$2'].
% Block elements containing other elements
Elements -> Elements BlockBlock : '$1' ++ ['$2'].
Elements -> Elements FilterBlock : '$1' ++ ['$2'].
Elements -> Elements ForBlock : '$1' ++ ['$2'].
Elements -> Elements IfBlock : '$1' ++ ['$2'].
Elements -> Elements IfEqualBlock : '$1' ++ ['$2'].
Elements -> Elements IfNotEqualBlock : '$1' ++ ['$2'].
Elements -> Elements SpacelessBlock : '$1' ++ ['$2'].
Elements -> Elements AutoEscapeBlock : '$1' ++ ['$2'].
Elements -> Elements WithBlock : '$1' ++ ['$2'].
Elements -> Elements CacheBlock : '$1' ++ ['$2'].
Elements -> Elements ScriptBlock : '$1' ++ ['$2'].
Elements -> Elements CommentBlock : '$1'.
% Tags
Elements -> Elements TransTag : '$1' ++ ['$2'].
Elements -> Elements TransExtTag : '$1' ++ ['$2'].
Elements -> Elements InheritTag : '$1' ++ ['$2'].
Elements -> Elements IncludeTag : '$1' ++ ['$2'].
Elements -> Elements CatIncludeTag : '$1' ++ ['$2'].
Elements -> Elements NowTag : '$1' ++ ['$2'].
Elements -> Elements LibTag : '$1' ++ ['$2'].
Elements -> Elements LibUrlTag : '$1' ++ ['$2'].
Elements -> Elements LoadTag : '$1' ++ ['$2'].
Elements -> Elements CycleTag : '$1' ++ ['$2'].
Elements -> Elements CustomTag : '$1' ++ ['$2'].
Elements -> Elements CallTag : '$1' ++ ['$2'].
Elements -> Elements CallWithTag : '$1' ++ ['$2'].
Elements -> Elements UrlTag : '$1' ++ ['$2'].
Elements -> Elements PrintTag : '$1' ++ ['$2'].
Elements -> Elements ImageTag : '$1' ++ ['$2'].
Elements -> Elements ImageUrlTag : '$1' ++ ['$2'].
Elements -> Elements ImageDataUrlTag : '$1' ++ ['$2'].
Elements -> Elements MediaTag : '$1' ++ ['$2'].


ValueBraced -> open_var E OptWith close_var : {value, '$1', '$2', '$3'}.

OptWith -> '$empty' : [].
OptWith -> with_keyword Args : '$2'.

ExtendsTag -> open_tag extends_keyword string_literal close_tag : '$3'.
OverrulesTag -> open_tag overrules_keyword close_tag : overrules.
InheritTag -> open_tag inherit_keyword close_tag : {inherit, '$1'}.

TransTag -> open_trans trans_text close_trans : '$2'.
TransTag -> open_trans text close_trans : '$2'.

TransExtTag -> open_tag trans_keyword trans_literal WithArgs close_tag : {trans_ext, '$3', '$4'}.

IncludeTag -> open_tag OptionalPrefix include_keyword E OptWith WithArgs close_tag : {include, '$1', '$2', '$4', '$6'}.
CatIncludeTag -> open_tag OptionalAll catinclude_keyword E E WithArgs close_tag : {catinclude, '$1', '$2', '$4', '$5', '$6'}.
NowTag -> open_tag now_keyword string_literal close_tag : {date, now, '$2', '$3'}.

OptionalPrefix -> optional_keyword : optional.
OptionalPrefix -> OptionalAll : '$1'.
OptionalAll -> all_keyword : all.
OptionalAll -> '$empty' : normal.

LibTag -> open_tag lib_keyword LibList Args close_tag : {lib, '$2', '$3', '$4'}.
LibUrlTag -> open_tag lib_url_keyword LibList Args close_tag : {lib_url, '$2', '$3', '$4'}.
LibList -> string_literal : ['$1'].
LibList -> LibList string_literal : '$1' ++ ['$2'].

LoadTag -> open_tag load_keyword LoadNames close_tag : {load, '$3'}.
LoadNames -> identifier : ['$1'].
LoadNames -> LoadNames identifier : '$1' ++ ['$2'].

BlockBlock -> BlockBraced Elements EndBlockBraced : {block, '$1', '$2'}.
BlockBraced -> open_tag block_keyword identifier close_tag : '$3'.
EndBlockBraced -> open_tag endblock_keyword close_tag.

CommentBlock -> CommentBraced Elements EndCommentBraced.
CommentBraced -> open_tag comment_keyword close_tag.
EndCommentBraced -> open_tag endcomment_keyword close_tag.

CycleTag -> open_tag cycle_keyword CycleNamesCompat close_tag : {cycle_compat, '$2', '$3'}.
CycleTag -> open_tag cycle_keyword CycleNames close_tag : {cycle, '$2', '$3'}.

CycleNames -> Value : ['$1'].
CycleNames -> CycleNames Value : '$1' ++ ['$2'].

CycleNamesCompat -> identifier comma : ['$1'].
CycleNamesCompat -> CycleNamesCompat identifier comma : '$1' ++ ['$2'].
CycleNamesCompat -> CycleNamesCompat identifier : '$1' ++ ['$2'].

FilterBlock -> FilterBraced Elements EndFilterBraced : {filter, '$1', '$2'}.
FilterBraced -> open_tag filter_keyword Filters close_tag : {'$1', '$3'}.
EndFilterBraced -> open_tag endfilter_keyword close_tag.

ScriptBlock -> ScriptBraced Elements EndScriptBraced : {javascript, '$1', '$2'}.
ScriptBraced -> open_tag javascript_keyword close_tag : '$2'.
EndScriptBraced -> open_tag endjavascript_keyword close_tag.

Filters -> Filter : ['$1'].
Filters -> Filters pipe Filter : '$1' ++ ['$3'].

ForBlock -> ForBraced Elements EndForBraced : {for, '$1', '$2', []}.
ForBlock -> ForBraced Elements EmptyBraced Elements EndForBraced : {for, '$1', '$2', '$4'}.
EmptyBraced -> open_tag empty_keyword close_tag.
ForBraced -> open_tag for_keyword ForExpression close_tag : '$3'.
EndForBraced -> open_tag endfor_keyword close_tag.
ForExpression -> ForGroup in_keyword E : {'in', '$2', '$1', '$3'}.
ForGroup -> identifier : ['$1'].
ForGroup -> ForGroup comma identifier : '$1' ++ ['$3'].

IfBlock -> IfBraced Elements ElsePart : {'if', '$1', '$2', '$3'}.

ElsePart -> EndIfBraced : [].
ElsePart -> ElseBraced Elements EndIfBraced : '$2'.
ElsePart -> ElifList : '$1'.

ElifList -> ElifBraced Elements ElsePart : {'if', '$1', '$2', '$3'}.

IfBraced -> open_tag if_keyword E OptAsPart close_tag : {'as', '$2', '$3', '$4'}.
ElifBraced -> open_tag elif_keyword E OptAsPart close_tag : {'as', '$2', '$3', '$4'}.
ElseBraced -> open_tag else_keyword close_tag.
EndIfBraced -> open_tag endif_keyword close_tag.

OptAsPart -> '$empty' : undefined.
OptAsPart -> as_keyword identifier : '$2'.

IfEqualBlock -> IfEqualBraced Elements ElseBraced Elements EndIfEqualBraced : {'ifequal', '$1', '$2', '$4'}.
IfEqualBlock -> IfEqualBraced Elements EndIfEqualBraced : {'ifequal', '$1', '$2', []}.
IfEqualBraced -> open_tag ifequal_keyword IfEqualExpression E close_tag : {'$1', '$3', '$4'}.
IfEqualExpression -> E : '$1'.
EndIfEqualBraced -> open_tag endifequal_keyword close_tag.

IfNotEqualBlock -> IfNotEqualBraced Elements ElseBraced Elements EndIfNotEqualBraced : {'ifnotequal', '$1', '$2', '$4'}.
IfNotEqualBlock -> IfNotEqualBraced Elements EndIfNotEqualBraced : {'ifnotequal', '$1', '$2', []}.
IfNotEqualBraced -> open_tag ifnotequal_keyword IfNotEqualExpression E close_tag : {'$1', '$3', '$4'}.
IfNotEqualExpression -> E : '$1'.
EndIfNotEqualBraced -> open_tag endifnotequal_keyword close_tag.

SpacelessBlock -> open_tag spaceless_keyword close_tag Elements open_tag endspaceless_keyword close_tag : {spaceless, '$1', '$4'}.

AutoEscapeBlock -> AutoEscapeBraced Elements EndAutoEscapeBraced : {autoescape, '$1', '$2'}.
AutoEscapeBraced -> open_tag autoescape_keyword identifier close_tag : '$3'.
EndAutoEscapeBraced -> open_tag endautoescape_keyword close_tag.

WithBlock -> WithBraced Elements EndWithBraced : {with, '$1', '$2'}.
WithBraced -> open_tag with_keyword ValueList as_keyword ForGroup close_tag : {'$2', '$3', '$5'}.
EndWithBraced -> open_tag endwith_keyword close_tag.

CacheBlock -> CacheBraced Elements EndCacheBraced : {cache, '$1', '$2'}.
CacheBraced -> open_tag cache_keyword OptCacheTime Args close_tag : {'$2', '$3', '$4'}.
EndCacheBraced -> open_tag endcache_keyword close_tag.

OptCacheTime -> '$empty' : undefined.
OptCacheTime -> number_literal : '$1'.

Filter -> identifier FilterArgs: {filter, '$1', '$2'}.
FilterArgs -> '$empty' : [].
FilterArgs -> FilterArgs colon TermValue : '$1' ++ ['$3'].

Literal -> string_literal : '$1'.
Literal -> trans_literal  : '$1'.
Literal -> number_literal : '$1'.
Literal -> atom_literal : '$1'.

CustomTag -> open_tag identifier Args close_tag : {custom_tag, '$2', '$3'}.

CallTag -> open_tag call_keyword identifier Args close_tag : {call, '$3', '$4'}.
CallWithTag -> open_tag call_keyword identifier with_keyword E close_tag : {call_with, '$3', '$5'}.

ImageTag -> open_tag image_keyword E Args close_tag : {image, '$2', '$3', '$4' }.
ImageUrlTag -> open_tag image_url_keyword E Args close_tag : {image_url, '$2', '$3', '$4' }.
ImageDataUrlTag -> open_tag image_data_url_keyword E Args close_tag : {image_data_url, '$2', '$3', '$4' }.
MediaTag -> open_tag media_keyword E Args close_tag : {media, '$2', '$3', '$4' }.

UrlTag -> open_tag url_keyword E Args close_tag : {url, '$2', '$3', '$4'}.

PrintTag -> open_tag print_keyword E close_tag : {print, '$2', '$3'}.

WithArgs -> with_keyword Args identifier : '$2' ++ [{'$3', true}].
WithArgs -> with_keyword Args identifier equal E : '$2' ++ [{'$3', '$5'}].
WithArgs -> Args : '$1'.

Args -> '$empty' : [].
Args -> Args identifier : '$1' ++ [{'$2', true}].
Args -> Args identifier equal E : '$1' ++ [{'$2', '$4'}].

Value -> Value pipe Filter : {apply_filter, '$1', '$3'}.
Value -> TermValue : '$1'.

MapFields -> '$empty' : [].
MapFields -> MapFieldList : '$1'.
MapFieldList -> MapField : [ '$1' ].
MapFieldList -> MapFieldList comma MapField : ['$3' | '$1'].
MapFieldList -> MapFieldList MapField : ['$2' | '$1'].
MapField -> identifier colon E : {'$1', '$3'}.
MapField -> string_literal colon E : {'$1', '$3'}.


TermValue -> '(' E ')' : '$2'.
TermValue -> Variable : {find_value, '$1'}.
TermValue -> Literal : '$1'.
TermValue -> ModelCall : '$1'.
TermValue -> hash AutoId : {auto_id, '$2'}.
TermValue -> open_map MapFields close_curly : {map_value, '$2'}.
TermValue -> open_curly identifier Args close_curly : {tuple_value, '$2', '$3'}.
TermValue -> open_bracket OptArrayList close_bracket : {value_list, '$2'}.

AutoId -> identifier dot identifier : {'$1', '$3'}.
AutoId -> identifier : '$1'.

ModelCall -> m_keyword dot Variable OptModelArg : {model, '$3', '$4'}.
OptModelArg -> '$empty' : none.
OptModelArg -> colons TermValue : '$2'.

Variable -> identifier : ['$1'].
Variable -> Variable open_bracket E close_bracket : '$1' ++ [{expr, '$3'}].
Variable -> Variable dot identifier : '$1' ++ ['$3'].

ValueList -> E : ['$1'].
ValueList -> ValueList comma E : '$1' ++ ['$3'].

OptArrayList -> '$empty' : [].
OptArrayList -> E : ['$1'].
OptArrayList -> E comma ArrayList : ['$1'|'$3'].
OptArrayList -> comma ArrayList : [undefined|'$2'].

ArrayList -> OptE : ['$1'].
ArrayList -> ArrayList comma OptE : '$1' ++ ['$3'].

OptE -> '$empty': undefined.
OptE -> E : '$1'.


%%% Expressions

E -> E or_keyword E  : {expr, {'or', '$2'}, '$1', '$3'}.
E -> E xor_keyword E  : {expr, {'xor', '$2'}, '$1', '$3'}.
E -> E and_keyword E  : {expr, {'and', '$2'}, '$1', '$3'}.
E -> E '==' E  : {expr, {'eq', '$2'}, '$1', '$3'}.
E -> E '/=' E  : {expr, {'ne', '$2'}, '$1', '$3'}.
E -> E '<' E  : {expr, {'lt', '$2'}, '$1', '$3'}.
E -> E '>' E  : {expr, {'gt', '$2'}, '$1', '$3'}.
E -> E '=<' E  : {expr, {'le', '$2'}, '$1', '$3'}.
E -> E '>=' E  : {expr, {'ge', '$2'}, '$1', '$3'}.
E -> E '++' E  : {expr, {'concat', '$2'}, '$1', '$3'}.
E -> E '--' E  : {expr, {'subtract', '$2'}, '$1', '$3'}.
E -> E '+' E  : {expr, {'add', '$2'}, '$1', '$3'}.
E -> E '-' E  : {expr, {'sub', '$2'}, '$1', '$3'}.
E -> E '*' E  : {expr, {'multiply', '$2'}, '$1', '$3'}.
E -> E '/' E  : {expr, {'divide', '$2'}, '$1', '$3'}.
E -> E '%' E  : {expr, {'modulo', '$2'}, '$1', '$3'}.
E -> Uminus : '$1'.
E -> Unot : '$1'.
E -> Value : '$1'.

Uminus -> '-' E : {expr, {'negate', '$1'}, '$2'}.
Unot -> not_keyword E : {expr, {'not', '$1'}, '$2'}.
