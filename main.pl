:- dynamic entity/2.
:- consult("data.pl").



% pronator: main function to call for playing Akinator game
pronator :-
	list_questions(Question),
	length(Question,QuestionLength),
	send_question([], 0, QuestionLength).



% send_question(-UserChoices,+Step,+QuestionLength): Game step
% if 0 answer is found
send_question(UserChoices,QuestionLength,QuestionLength) :-
    findall(N,(entity(N,List),match_answers(UserChoices,List)),EntitiesFound),
    length(EntitiesFound,0),
    write("Sincèrement, je ne vois pas de quoi il s'agit. Pouvez-vous me dire ce que c'est?"),nl,
    read_line_to_string(user_input,UserAnswer),
    save_new_entity(UserAnswer,UserChoices),nl.

% if 1 answer is found
send_question(UserChoices,QuestionLength,QuestionLength) :-
    findall(N,(entity(N,List),match_answers(UserChoices,List)),EntitiesFound),
    length(EntitiesFound,1),
    write("j'ai trouvé votre réponse"),
    nth0(0, EntitiesFound, Entity),nl,
    write(Entity),nl,
    write("Est-ce correct? (oui/non)"),
    read_line_to_string(user_input,UserAnswer),nl,
    ((UserAnswer == "oui") -> say_victory; save_new_entity(UserChoices)).
    
% if more than 1 answer is found
send_question(UserChoices,QuestionLength,QuestionLength) :-
    findall(N,(entity(N,List),match_answers(UserChoices,List)),EntitiesFound),
    length(EntitiesFound,EntitiesLength),
    EntitiesLength>1,
    write("J'ai plusieurs hypothèses. J'en donne une au hasard"),nl,
    random(0,QuestionLength,RandomNumber),
    nth0(RandomNumber, EntitiesFound, Entity),
    write(Entity),nl,
    write("Est-ce correct? (oui/non)"),nl,
    read_line_to_string(user_input,UserAnswer),nl,
    ((UserAnswer == "oui") -> say_victory; check_new_entity(UserChoices)).
    
% Step where we ask a question to the user
send_question(UserChoices,Step,QuestionLength) :-
    list_questions(QuestionList),
    nth0(Step, QuestionList, QuestionTheme),
    question(QuestionTheme, QuestionText),
    write(QuestionText),nl,
    read_line_to_string(user_input,Answer),nl,
    append(UserChoices, [Answer], UserChoices2),
    Step2 is Step+1,
    send_question(UserChoices2,Step2,QuestionLength).


% say_victory: Text sent to user when AI guessed correctly   
say_victory :-
    write("Super, j'avais raison!"),nl.

% say_new_entity(+UserChoices): Text sent to user when AI guessed poorly   	
say_new_entity(UserChoices) :-
    write("Ah bon? Mince! Du coup, quelle était la bonne réponse"),nl,
    read_line_to_string(user_input,UserAnswer),nl,
    save_new_entity(UserAnswer, UserChoices).

% save_new_entity(+UserAnswer,+UserChoices): AI add new entity for next game   	
save_new_entity(UserAnswer, UserChoices) :-
    assertz(entity(UserAnswer, UserChoices)),
    write("Je vois. Je m'en rappelerai"),nl.

% check_new_entity(+UserChoices): AI add new entity for next game only if this entity doesn't exist yet  	
check_new_entity(UserChoices) :-
    write("Ah bon? Mince! Du coup, quelle était la bonne réponse"),nl,
    read_line_to_string(user_input,UserAnswer),nl,
    ((entity(UserAnswer,_)) -> write("Dommage, je pensais aussi à cela"),nl;assertz(entity(UserAnswer, UserChoices)),write("Je vois. Je m'en rappelerai"),nl).
	
% match_answers(+List1, +List2): Rule used for making sure that elements in List1 exists in List2 in the same order
match_answers([],_).

match_answers([H|T],[H|T2]):-
	match_answers(T,T2).
   
% clean_data: Wipe dynamic entity from SWI Prolog     
clean_data :- retractall(entity(_)),fail.
clean_data.
