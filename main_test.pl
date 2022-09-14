:- consult(main).

entity("france", ["oui","oui","non", "non"]).
entity("russie", ["non","oui","oui", "non"]).
entity("australie", ["non","oui","non","oui"]).
entity("belgique", ["oui","non","non","non"]).
entity("inde", ["non","non","non", "non"]).

list_questions(["europe","drapeau","demographie","ile"]).

question("europe","Est-ce un pays d'europe? (oui/non)").
question("drapeau","Son drapeau possède-t-il la couleur bleu? (oui/non)").
question("demographie","Est-ce un pays de plus de 100 millions d'habitants? (oui/non)").
question("ile","Est-ce une île? (oui/non)").

:- begin_tests(main).


test(match_answers_empty)  :- match_answers([],[]).

test(match_answers_equal)  :- match_answers(["oui", "non"],["oui", "non"]).

test(match_answers_different_sizes)  :- match_answers(["oui", "non"],["oui", "non", "oui"]).

test(match_answers_fail, [fail])  :- match_answers(["oui", "non"],["non", "non", "oui"]).

test(save_new_entity)  :- save_new_entity("japon", ["non","non","oui","oui"]), entity("japon",_).

test(check_length_answers) :- findall(N,(entity(N,List),match_answers(["oui","oui","non", "non"],List)),EntitiesFound),length(EntitiesFound,1).

test(match_answers_fail)  :- assertz(entity("japon", ["non","non","oui","oui"])),clean_data, entity("japon",_).

:- end_tests(main).

:- run_tests.
