%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(all).      
 
-export([start/0]).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("../control/include/control_config.hrl").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
   
    ok=setup(),
    ok=test0(),
    ok=test1(),
    
    io:format("Test OK !!! ~p~n",[?MODULE]),
    timer:sleep(5000),
    init:stop(),
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test0()->    
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    MyMathResources=rd:fetch_resources(mymath),
    [{mymath,'10_a@c200'}]=MyMathResources,
     
    AdderResources=lists:sort(rd:fetch_resources(adder)),
    [{adder,'7_a@c201'},{adder,'9_a@c200'}]=AdderResources,
    DiviResources=lists:sort(rd:fetch_resources(divi)),
    [{divi,'6_a@c201'},{divi,'8_a@c200'}]=DiviResources,
    
    loop(MyMathResources,AdderResources,AdderResources),
    
    
    ok.


loop(MyMathResources,AdderResources,AdderResources)->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    [{MyMathModule,MyMathNode}]=MyMathResources,
    42=rpc:call(MyMathNode,MyMathModule,add,[20,22],5000),
    
    timer:sleep(5000),
    loop(MyMathResources,AdderResources,AdderResources).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test1()->    
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    42=dist_test:add(20,22),
    42.0=dist_test:divi(420,10),
    
    
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    Alive=[N||N<-?ConnectNodes,
              pong=:=net_adm:ping(N)],
    ConnectResult=[{N1,N2,rpc:call(N1,net_adm,ping,[N2],5000)}||N1<-Alive,
                                                                N2<-Alive,
                                                                N1<N2],
    io:format("ConnectResult ~p~n",[{ConnectResult,?MODULE,?LINE}]),
    %%
    ok=application:start(log),
    ok=application:start(rd),
    ok=application:start(dist_test),

    ok.

