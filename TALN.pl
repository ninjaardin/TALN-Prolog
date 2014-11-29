% Auteur:
% Date: 2014-11-22


% Base de connaissances

est_pierre(marbre).
est_pierre(schiste).
est_pierre(gneiss).
est_pierre(ardoise).
est_pierre(schiste-argileux).
est_pierre(gabbro).
est_pierre(granit).
est_pierre(scorie).
est_pierre(pierre-ponce).
est_pierre(obsidienne).
est_pierre(rhyolite).
est_pierre(basalte).
est_pierre(grès).
est_pierre(conglomérat).
est_pierre(tuf).
est_pierre(calcaire).



est_type(métamorphique).
est_type(sédimentaire).
est_type(ignée).

type(marbre, métamorphique).
type(schiste, métamorphique).
type(gneiss, métamorphique).
type(ardoise, métamorphique).
type(schiste-argileux, métamorphique).

type(gabbro, ignée).
type(granit, ignée).
type(scorie, ignée).
type(pierre-ponce, ignée).
type(obsidienne, ignée).
type(rhyolite, ignée).
type(basalte, ignée).

type(grès, sédimentaire).
type(conglomérat, sédimentaire).
type(tuf, sédimentaire).
type(calcaire, sédimentaire).




propriété(marbre, possède_cristaux).
propriété(granite, possède_cristaux).
propriété(gabbro, possède_cristaux).
propriété(schiste, possède_cristaux).
propriété(gneiss, possède_cristaux).

propriété(marbre, cristaux_éparpillés).
propriété(granit, cristaux_éparpillés).
propriété(gabbro, cristaux_éparpillés).

propriété(schiste, cristaux_en_couches).
propriété(gneiss, cristaux_en_couches).

propriété(marbre, cristaux_clairs).
propriété(granit, cristaux_clairs).

propriété(marbre, réagit_acide).
propriété(calcaire, réagit_acide).

propriété(gabbro, cristaux_foncés).

propriété(schiste, couches_de_cristaux_identiques).

propriété(gneisse, couches_de_cristaux_différentes).



propriété(grès, possède_particules).
propriété(conglomérat, possède_particules).

propriété(grès, particules_petites).

propriété(conglomérat, particules_grandes).


propriété(tuf, possède_des_trous).
propriété(scorie, possède_des_trous).
propriété(pierre_ponce, possède_des_trous).

propriété(tuf, trous_clairs).

propriété(scorie, trous_foncés).
propriété(pierre_ponce, trous_foncés).


propriété(ardoise, possède_des_couches).
propriété(schiste_argileux, possède_des_couches).

propriété(ardoise, surface_luisante).

propriété(schiste_argileux, surface_mate).


propriété(obsidienne, surface_vitreuse).

propriété(rhyolite, surface_claire).
propriété(balsate, surface_foncée).



% Commandes générales

lancer :- lire(_, Question),
          poser_question(Question, Réponse),
          write(Réponse).

poser_question( Question, Réponse ) :- repondre(Question, Sens), evaluer(Sens, Réponse).
poser_question( _, 'Question invalide.').

repondre(Question, Sens) :- analyse(_, Sens, Question, []).

evaluer(Sens, Réponse):- call(Sens, Réponse).



% Prédicats évalués

toutes_pierres_pour_type(Type, Réponse) :- findall(Pierre, type(Pierre, Type), Réponse).

est_type(Pierre, Type, Réponse) :- call(type(Pierre, Type)), !, Réponse = oui.
est_type(_, _, Réponse) :- Réponse = non.

toutes_pierres_reagit_acide_pour_type(Type, Réponse) :- findall(Pierre, pierre_pour_type_et_propriété(Pierre, Type, réagit_acide), Réponse).
pierre_pour_type_et_propriété(Pierre, Type, Propriété) :- type(Pierre, Type), propriété(Pierre, Propriété).

toutes_propriétés_communes(Pierre1, Pierre2, Réponse) :- findall(Propriété, propriété_communnes(Pierre1, Pierre2, Propriété), Propriété_communes), ajouterTypeCommun(Pierre1, Pierre2, Propriété_communes, Réponse).
propriété_communnes(Pierre1, Pierre2, Propriété) :- propriété(Pierre1, Propriété), propriété(Pierre2, Propriété).
ajouterTypeCommun(Pierre1, Pierre2, Propriété_communes, [Type_commun|Propriété_communes]) :- type(Pierre1, Type_commun), type(Pierre2, Type_commun).
ajouterTypeCommun(_, _, Propriété_communes, Propriété_communes).





% Lecture des entrées de l'utilisateur

% Le prédicat lire/2 lit une chaîne de caractères Chaine entre apostrophes
% et terminée par un point.
% Resultat correspond à la liste des mots contenus dans la phrase.
% Les signes de ponctuation ne sont pas gérés.

lire(Chaine,Resultat):- write('Entrer la phrase '),read(Chaine),
                        name(Chaine, Temp), chaine_liste(Temp, Resultat),!.


% Prédicat de transformation de chaîne en liste

chaine_liste([],[]).
chaine_liste(Liste,[Mot|Reste]):- separer(Liste,32,A,B), name(Mot,A),
chaine_liste(B,Reste).


% Sépare une liste par rapport à un élément

separer([],_,[],[]):-!.
separer([X|R],X,[],R):-!.
separer([A|R],X,[A|Av],Ap):- X\==A, !, separer(R,X,Av,Ap).





%Interprétation

% EX: Est-ce que le marbre est igné?
analyse(groupePhrase(INT, GN, GV), Sémantique)-->
        int(INT),
        gn(GN, Agent),
        gv(GV, Sémantique, Agent).

% EX: Quelles sont les pierres sédimentaires?
analyse(groupePhrase(INT, GV, GA), Sémantique)-->
        int(INT),
        gv(GV, Sémantique, Propriété),
        ga(GA, Propriété).

% EX: Le schiste est-il métamorphique?
analyse(groupePhrase(GN, V_INT, GA), Sémantique)-->
        gn(GN, Agent),
        v_int(V_INT, Sémantique, Agent, Propriété),
        ga(GA, Propriété).
        
% EX: Quelles pierres sédimentaires réagissent à l'acide?
analyse(groupePhrase(INT, GN, GA, GV), Sémantique)-->
        int(INT),
        gn(GN, Agent),
        ga(GA, Type),
        gv(GV, Sémantique, Agent, Type).

% EX: Qu'ont en commun le schiste et le gneiss?
analyse(groupePhrase(V_INT, GA, GN1, CONJ, GN2), Sémantique)-->
        v_int(V_INT, Sémantique, Sujet1, Sujet2, Lien),
        ga(GA, Lien),
        gn(GN1, Sujet1),
        conj(CONJ),
        gn(GN2, Sujet2).



int(interrogation(ADJ_INT))-->
        adj_int(ADJ_INT).
        
int(interrogation(INT_DIR, ADJ_INT))-->
        int_dir(INT_DIR),
        adj_int(ADJ_INT).



adj_int(adjectif_interrogatif(quelle))-->[quelle].
adj_int(adjectif_interrogatif(quelles))-->[quelles].
adj_int(adjectif_interrogatif(que))-->[que].
adj_int(adjectif_interrogatif('qu''un'))-->['qu''un'].
adj_int(adjectif_interrogatif('qu''une'))-->['qu''une'].



int_dir(interrogation_directe('est-ce'))-->['est-ce'].



gn(groupeNominal(N), Agent)-->
        n(N, Agent).

gn(groupeNominal(Art,N), Agent)-->
        art(Art),n(N, Agent).
        
        

gv(groupeVerbal(V,Adj), Sémantique, Sujet)-->
        v(V, Sémantique, Sujet, Propriété),
        adj(Adj, Propriété).

gv(groupeVerbal(V,GN), Sémantique, Propriété)-->
        v(V, Sémantique, Sujet, Propriété),
        gn(GN, Sujet).

gv(groupeVerbal(V,COMP), Sémantique, Sujet, Type)-->
        v(V, Sémantique, Sujet, Type, Propriété),
        comp(COMP, Propriété).



ga(groupeAdjectival(ADJ), Adjectif)-->
        adj(ADJ, Adjectif).

ga(groupeAdjectival(PRÉP, ADJ), Adjectif)-->
        prép(PRÉP),
        adj(ADJ, Adjectif).



comp(complément(PRÉP, GN), Propriété)-->
        prép(PRÉP),
        gn(GN, Propriété).



% Quelles sont les pierres sédimentaires?
v(verbe(est), toutes_pierres_pour_type(Propriété), Sujet, Propriété)-->[est], {Sujet = pierre, est_type(Propriété)}.  %++++ à revoir l'appel, c'est bizarre comment ça marche.
v(verbe(sont), toutes_pierres_pour_type(Propriété), Sujet, Propriété)-->[sont], {Sujet = pierre, est_type(Propriété)}.

% Est-ce que le marbre est igné?
v(verbe(est), est_type(Sujet, Propriété), Sujet, Propriété)-->[est], {est_pierre(Sujet), est_type(Propriété)}.
v(verbe(sont), est_type(Sujet, Propriété), Sujet, Propriété)-->[sont], {est_pierre(Sujet), est_type(Propriété)}.

% Le schiste est-il métamorphique?
v_int(verbe_interrogatif('est-il'), est_type(Sujet, Propriété), Sujet, Propriété)-->['est-il'], {est_pierre(Sujet), est_type(Propriété)}.
v_int(verbe_interrogatif('est-elle'), est_type(Sujet, Propriété), Sujet, Propriété)-->['est-elle'], {est_pierre(Sujet), est_type(Propriété)}.
v_int(verbe_interrogatif('sont-ils'), est_type(Sujet, Propriété), Sujet, Propriété)-->['sont-ils'], {est_pierre(Sujet), est_type(Propriété)}.
v_int(verbe_interrogatif('sont-elles'), est_type(Sujet, Propriété), Sujet, Propriété)-->['sont-elles'], {est_pierre(Sujet), est_type(Propriété)}.

% Quelles pierres sédimentaires réagissent à l'acide?
v(verbe(réagit), toutes_pierres_reagit_acide_pour_type(Type), Sujet, Type, Propriété)-->['réagit'], {Sujet = pierre, est_type(Type), Propriété = acide}.
v(verbe(réagissent), toutes_pierres_reagit_acide_pour_type(Type), Sujet, Type, Propriété)-->['réagissent'], {Sujet = pierre, est_type(Type), Propriété = acide}.

% Qu'ont en commun le schiste et le gneiss?
v_int(verbe_interrogatif('qu''ont'), toutes_propriétés_communes(Sujet1, Sujet2), Sujet1, Sujet2, Lien)-->['qu''ont'], {est_pierre(Sujet1), est_pierre(Sujet2), Lien = commun}.



art(article(le))-->[le].
art(article(la))-->[la].
art(article(la))-->[les].


n(nom(pierre), pierre)-->[pierre].
n(nom(pierres), pierre)-->[pierres].

n(nom(marbre), marbre)-->[marbre].
n(nom(schiste), schiste)-->[schiste].
n(nom(gneiss), gneiss)-->[gneiss].
n(nom(ardoise), ardoise)-->[ardoise].
n(nom('l''ardoise'), ardoise)-->['l''ardoise'].
n(nom(schiste-argileux), schiste-argileux)-->[schiste-argileux].
n(nom(grès), grès)-->[grès].
n(nom(conglomérat), conglomérat)-->[conglomérat].
n(nom(tuf), tuf)-->[tuf].
n(nom(calcaire), calcaire)-->[calcaire].
n(nom(gabbro), gabbro)-->[gabbro].
n(nom(granit), granit)-->[granit].
n(nom(scorie), scorie)-->[scorie].
n(nom(pierre-ponce), pierre-ponce)-->[pierre-ponce].
n(nom(obsidienne), obsidienne)-->[obsidienne].
n(nom('l''obsidienne'), obsidienne)-->['l''obsidienne'].
n(nom(rhyolite), rhyolite)-->[rhyolite].
n(nom(basalte), basalte)-->[basalte].

n(nom(acide), acide)-->[acide].
n(nom('l''acide'), acide)-->['l''acide'].


adj(adjectif(métamorphique), métamorphique)-->[métamorphique].
adj(adjectif(métamorphiques), métamorphique)-->[métamorphiques].
adj(adjectif(sédimentaire), sédimentaire)-->[sédimentaire].
adj(adjectif(sédimentaires), sédimentaire)-->[sédimentaires].
adj(adjectif(igné),ignée)-->[igné].
adj(adjectif(ignée),ignée)-->[ignée].
adj(adjectif(ignées), ignée)-->[ignées].

adj(adjectif(commun), commun)-->[commun].

prép(préposition(à))-->[à].
prép(préposition(en))-->[en].


conj(conjonction(et))-->[et].
