entity("france", ["oui","oui","non", "non"]).
entity("russie", ["non","non","oui", "non"]).
entity("australie", ["non","oui","non","oui"]).
entity("belgique", ["oui","non","non","non"]).
entity("inde", ["non","non","non", "non"]).

list_questions(["europe","drapeau","demographie","ile"]).

question("europe","Est-ce un pays d'europe? (oui/non)").
question("drapeau","Son drapeau possède-t-il la couleur bleu? (oui/non)").
question("demographie","Est-ce un pays de plus de 100 millions d'habitants? (oui/non)").
question("ile","Est-ce une île? (oui/non)").
