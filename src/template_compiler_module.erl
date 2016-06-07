%% @author Marc Worrell <marc@worrell.nl>
%% @copyright 2016 Marc Worrell
%% @doc Build the template module from the parts.

%% Copyright 2016 Marc Worrell
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%% 
%%     http://www.apache.org/licenses/LICENSE-2.0
%% 
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(template_compiler_module).
-author('Marc Worrell <marc@worrell.nl>').

-export([
    compile/7
    ]).

-include_lib("syntax_tools/include/merl.hrl").
-include("template_compiler.hrl").
-include("template_compiler_internal.hrl").

compile(Module, Filename, IsAutoid, Runtime, Extends, BlockAsts, undefined) ->
    compile(Module, Filename, IsAutoid, Runtime, Extends, BlockAsts, erl_syntax:abstract(<<>>));
compile(Module, Filename, IsAutoid, Runtime, Extends, BlockAsts, TemplateAst) ->
    Mtime = filelib:last_modified(Filename),
    Now = os:timestamp(),
    BlockNames = [ BN || {BN,_Tree,_Ws} <- BlockAsts ],
    lists:flatten(
        ?Q(["-module('@Module@').",
            "-export([",
                "render/3,",
                "render_block/4,",
                "timestamp/0,",
                "blocks/0,",
                "module/0,",
                "extends/0,",
                "filename/0,",
                "mtime/0,",
                "is_autoid/0,"
                "runtime/0",
            "]).",
            "render(Vars, Blocks, Context) -> _@TemplateAst.",
            "timestamp() -> _@Now@.",
            "blocks() -> _@BlockNames@.",
            "module() -> _@Module@.",
            "extends() -> _@Extends@.",
            "filename() -> _@Filename@.",
            "mtime() -> _@Mtime@.",
            "is_autoid() -> _@IsAutoid@.",
            "runtime() -> _@Runtime@.",
            "'@_functions'() -> _."
            ],
            [
                {functions, blocksfun(BlockAsts)}
            ])).

blocksfun(Blocks) ->
    Clauses = [
        ?Q("(_@BlockName@, Vars, Blocks, Context) -> _@BlockAst")
        || {BlockName, BlockAst, _BlockWs} <- Blocks
    ] ++ [
        ?Q("(_BlockName, _Vars, _Blocks, _Context) -> <<>>")
    ],
    erl_syntax:function(erl_syntax:atom(render_block), Clauses).
