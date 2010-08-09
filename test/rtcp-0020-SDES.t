#!/usr/bin/escript
%% -*- erlang -*-

% Test SDES codec.

-include_lib("rtplib/include/rtcp.hrl").

main(_) ->
	etap:plan(3),

	etap:fun_is(fun(A) when is_binary(A) -> true; (_) -> false end, rtcp:encode_sdes(1024, [{1,"hello 1"}, {2, "hello 2"}, {0, test}]), "Simple encoding of SDES RTCP data stream"),
	Data = rtcp:encode_sdes(1024, [{1,"hello 1"}, {2, "hello 2"}, {0, test}]),

	etap:fun_is(fun ({ok, [#sdes{list=SdesItemsList}]}) when is_list(SdesItemsList) -> true; (_) -> false end, rtcp:decode(Data), "Simple decoding SDES RTCP data stream and returning a list with only member - record"),
	{ok, [Rtcp]} = rtcp:decode(Data),

	etap:is(Data, rtcp:encode(Rtcp), "Check that we can reproduce original data stream from record"),

	etap:end_tests().

