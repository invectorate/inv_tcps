%% Copyright (c) 2010 Invectorate LLC. All rights reserved.
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

-module(inv_tcps_acceptor_sup).

-behaviour(supervisor).

%% API
-export([start_link/4]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link(Listener, Callback, AcceptFun, CloseFun) ->
    supervisor:start_link(?MODULE, [Listener, Callback, AcceptFun, CloseFun]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([Listener, Callback, AcceptFun, CloseFun]) ->
    AcceptorSpec = {inv_tcps_acceptor, {inv_tcps_acceptor, start_link, [Listener, Callback, AcceptFun, CloseFun]},
                    temporary, 5000, worker, [inv_tcps_acceptor]},
    {ok, {{simple_one_for_one, 5, 10}, [AcceptorSpec]}}.