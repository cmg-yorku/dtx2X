
:- discontiguous initially/2.
:- dir(indigolog_plain, F), consult(F).


%
% Exogenous action handling.
%
% Actions are lined up in a queue accessed through actionList/1. If queue is empty, input from user is requested.
%
:- dynamic actionList/1.
:- assert(actionList([])).
exog_occurs_list(A) :- actionList([]), !, write('Queue empty. '), ask_exog_occurs(A).
exog_occurs_list(A) :- actionList([A|H]), retract(actionList(_)),assert(actionList(H)).

% CONFIGURATION

% Exceptions
% Actions that imply the transmission of messages
% In this single-file simulation context we maintain the actionList queue.
% In real multi-file multi-agent settings the message "constraintsGatheredByPoll_Request_Send(PA,SA,M)" (with bound parameters, must be dispatched).
execute(constraintsGatheredByPoll_Request_Send(PA,SA,M), SR) :- 
	!,
	ask_execute(constraintsGatheredByPoll_Request_Send(PA,SA,M), SR),
	actionList(T),
	retract(actionList(_)),
	append(T, [constraintsGatheredByPoll_Request_Receive(PA,SA,M)], List),
	append([],List,NewList),
	assert(actionList(NewList)),
	format('   Queuing exogenous action: constraintsGatheredByPoll_Request_Receive(~w,~w,~w)~n', [PA, SA, M]),
	format('   Exogenous action queue now is: ~w~n', [NewList]).

% Rule
execute(A, SR) :- ask_execute(A, SR).
%exog_occurs(A) :- ask_exog_occurs(A).
exog_occurs(A) :- exog_occurs_list(A).


%
% AGENT AND ENTITY DEFINITION 
%
prim_fluent(schedulingAgent(_)).
prim_fluent(pollingToolAgent(_)).
prim_fluent(communicationAgent(_)).
prim_fluent(meeting(_)).

initially(schedulingAgent(schedAgent),true).
initially(pollingToolAgent(pollAgent),true).
initially(communicationAgent(comsAgent),true).
initially(meeting(budgetMeeting),true).

% MAIN CALL
run :- indigolog(main).
% Send a call to the scheduling agent and starte the polling agent.
proc(main, conc(constraintsGathered(schedAgent,budgetMeeting),paMain)).


% SCHEDULING AGENT
% Both by email and by polling - does not make domain sense but added here for the demonstration
proc(constraintsGathered(SA,M), [constraintsGatheredByEmail(SA,M),constraintsGatheredByPoll(SA,M)]
).

% Perform a simple call
proc(constraintsGatheredByEmail(SA,M),
	pi(ca,[?(and([communicationAgent(ca),meeting(M),schedulingAgent(SA)])),constraintsGatheredByEmail(ca,SA,M)])
).

% Perform the message dispatch action for a server
proc(constraintsGatheredByPoll(SA,M),
	pi(pa,[?(pollingToolAgent(pa)),constraintsGatheredByPoll_Request_Send(pa,SA,M)])
).

% Message dispatch action. Execute adds it to the queue of messages to be sent.

prim_action(constraintsGatheredByPoll_Request_Send(_,_,_)).
poss(constraintsGatheredByPoll_Request_Send(_,_,_),true).
initially(constraintsGatheredByPoll_Request_Send_Sat(_,_,_),false).
causes_val(constraintsGatheredByPoll_Request_Send(PA,SA,M), 
           constraintsGatheredByPoll_Request_Send_Sat(PA,SA,M), true, true).
prim_fluent(constraintsGatheredByPoll_Request_Send_Sat(_,_,_)).


% COMMUNICATION AGENT
% Normal procedure call. In iStar-DT-X activation style was marked as 'called'
proc(constraintsGatheredByEmail(CA,SA,M), gatherConstraintsByEmail(CA,SA,M)).

prim_action(gatherConstraintsByEmail(_,_,_)).
poss(gatherConstraintsByEmail(_,_,_),true).
initially(gatherConstraintsByEmail_Sat(_,_,_),false).

causes_val(gatherConstraintsByEmail(CA,SA,M), gatherConstraintsByEmail_Sat(CA,SA,M), true, true).
prim_fluent(gatherConstraintsByEmail_Sat(_,_,_)).



% POLLING AGENT
% Message based trigger. In iStar-DT-X activation style was marked as 'triggered'
% Agent needs a server if there is at least one triggered goal. The goal is added without parameters. Parameters will come from the exogenous event.
proc(paMain,iconc(constraintsGatheredByPollingTool)).

% The exogenous action that triggers the goal, by turning the [action_name]_Sat fluent true.
exog_action(constraintsGatheredByPoll_Request_Receive(_,_,_)).
causes_val(constraintsGatheredByPoll_Request_Receive(PA,SA,M), 
		   constraintsGatheredByPoll_Request_Receive_Sat(PA,SA,M), 
		   true, true).
prim_fluent(constraintsGatheredByPoll_Request_Receive_Sat(_,_,_)).

% Action for marking consumption of exogenous action by turning the [action_name]_Consumed fluent true. 
prim_action(constraintsGatheredByPoll_Request_Receive_Consume(_,_,_)).
poss(constraintsGatheredByPoll_Request_Receive_Consume(_,_,_),true).
causes_val(constraintsGatheredByPoll_Request_Receive_Consume(PA,SA,M), 
		   constraintsGatheredByPoll_Request_Receive_Consumed(PA,SA,M), 
		   true, true).
prim_fluent(constraintsGatheredByPoll_Request_Receive_Consumed(_,_,_)).


% Goal translation.
% Will be pursued if there is a received message (the _Sat fluent) that has not been consumed (the _Consumed fluent)
proc(constraintsGatheredByPollingTool, 
 	   [
		pi(pa,pi(sa,pi(m,[?(and([pollingToolAgent(pa),
								 schedulingAgent(sa),
								 meeting(m),
								 constraintsGatheredByPoll_Request_Receive_Sat(pa,sa,m), % has been received
								 neg(constraintsGatheredByPoll_Request_Receive_Consumed(pa,sa,m)) % not consumed yet
								])),
						   constraintsGatheredByPoll_Request_Receive_Consume(pa,sa,m), % consume first!
						   gatherConstraintsByPool(pa,sa,m)
						  ])))
		]
).

prim_action(gatherConstraintsByPool(_,_,_)).
poss(gatherConstraintsByPool(_,_,_),true).

