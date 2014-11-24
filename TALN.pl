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
est_pierre(gr�s).
est_pierre(conglom�rat).
est_pierre(tuf).
est_pierre(calcaire).



propri�t�(marbre, poss�de_cristaux).
propri�t�(granite, poss�de_cristaux).
propri�t�(gabbro, poss�de_cristaux).
propri�t�(schiste, poss�de_cristaux).
propri�t�(gneiss, poss�de_cristaux).

propri�t�(marbre, cristaux_�parpill�s).
propri�t�(granit, cristaux_�parpill�s).
propri�t�(gabbro, cristaux_�parpill�s).

propri�t�(schiste, cristaux_en_couches).
propri�t�(gneiss, cristaux_en_couches).

propri�t�(marbre, cristaux_clairs).
propri�t�(granit, cristaux_clairs).

propri�t�(marbre, r�agit_�_l_acide).
propri�t�(calcaire, r�agit_�_l_acide).

propri�t�(gabbro, cristaux_fonc�s).

propri�t�(schiste, couches_de_cristaux_identiques).

propri�t�(gneisse, couches_de_cristaux_diff�rentes).



propri�t�(gr�s, poss�de_particules).
propri�t�(conglom�rat, poss�de_particules).

propri�t�(gr�s, particules_petites).

propri�t�(conglom�rat, particules_grandes).


propri�t�(tuf, poss�de_des_trous).
propri�t�(scorie, poss�de_des_trous).
propri�t�(pierre_ponce, poss�de_des_trous).

propri�t�(tuf, trous_clairs).

propri�t�(scorie, trous_fonc�s).
propri�t�(pierre_ponce, trous_fonc�s).


propri�t�(ardoise, poss�de_des_couches).
propri�t�(schiste_argileux, poss�de_des_couches).

propri�t�(ardoise, surface_luisante).

propri�t�(schiste_argileux, surface_mate).


propri�t�(obsidienne, surface_vitreuse).

propri�t�(rhyolite, surface_claire).
propri�t�(balsate, surface_fonc�e).




pierre_pour_type(Type, Pierre) :- type(Pierre, Type).

est_type(m�tamorphique).
est_type(s�dimentaire).
est_type(ign�e).

type(marbre, m�tamorphique).
type(schiste, m�tamorphique).
type(gneiss, m�tamorphique).
type(ardoise, m�tamorphique).
type(schiste-argileux, m�tamorphique).

type(gabbro, ign�e).
type(granit, ign�e).
type(scorie, ign�e).
type(pierre-ponce, ign�e).
type(obsidienne, ign�e).
type(rhyolite, ign�e).
type(basalte, ign�e).

type(gr�s, s�dimentaire).
type(conglom�rat, s�dimentaire).
type(tuf, s�dimentaire).
type(calcaire, s�dimentaire).


%Commandes g�n�rales

lancer :- lire(_, Question),
          poser_question(Question, R�ponse),
          write(R�ponse).

poser_question( Question, R�ponse ) :- repondre(Question, Sens), evaluer(Sens, R�ponse).

repondre(Question, Sens) :- analyse(_, Sens, Question, []).

evaluer(Sens, R�ponse):- call(Sens, R�ponse). %++++ � revoir, c'est un peu bizarre comment �a fonctionne.



%Lecture des entr�es de l'utilisateur

% Le pr�dicat lire/2 lit une cha�ne de caract�res Chaine entre apostrophes
% et termin�e par un point.
% Resultat correspond � la liste des mots contenus dans la phrase.
% Les signes de ponctuation ne sont pas g�r�s.

lire(Chaine,Resultat):- write('Entrer la phrase '),read(Chaine),
                        name(Chaine, Temp), chaine_liste(Temp, Resultat),!.


% Pr�dicat de transformation de cha�ne en liste

chaine_liste([],[]).
chaine_liste(Liste,[Mot|Reste]):- separer(Liste,32,A,B), name(Mot,A),
chaine_liste(B,Reste).


% S�pare une liste par rapport � un �l�ment

separer([],_,[],[]):-!.
separer([X|R],X,[],R):-!.
separer([A|R],X,[A|Av],Ap):- X\==A, !, separer(R,X,Av,Ap).





%Interpr�tation

% ?-analyse(Arbre_synt, Semantique, [quelles, pierres, sont, s�dimentaires], []).

analyse(groupePhrase(INT,GN,GV), S�mantique)-->
        int(INT, Type_R�ponse),
        gn(GN, Agent),
        gv(GV, S�mantique, Agent).


int(interrogation(ADJ_INT), Type_R�ponse)-->
        adj_int(ADJ_INT, Type_R�ponse).
        
int(interrogation(INT_DIR, ADJ_INT), Type_R�ponse)-->
        int_dir(INT_DIR, Type_R�ponse),
        adj_int(ADJ_INT).


adj_int(adjectif_interrogatif(quelle), liste)-->[quelle].
adj_int(adjectif_interrogatif(quelles), liste)-->[quelles].
adj_int(adjectif_interrogatif(que))-->[que].
adj_int(adjectif_interrogatif('qu''un'))-->['qu''un'].
adj_int(adjectif_interrogatif('qu''une'))-->['qu''une'].


int_dir(interrogation_directe('est-ce'), oui_non)-->['est-ce'].


gn(groupeNominal(N), Agent)-->
        n(N, Agent).

gn(groupeNominal(Art,N), Agent)-->
        art(Art),n(N, Agent).

gv(groupeVerbal(V,Adj), S�mantique, Sujet)-->
        v(V, S�mantique, Sujet, Propri�t�),
        adj(Adj, Propri�t�).

%gv(groupeVerbal(V,GN))-->v(V),gn(GN).


% Quelles pierres sont ign�es?
v(verbe(est), pierre_pour_type(Propri�t�), Sujet, Propri�t�)-->[est], {Sujet = pierre, est_type(Propri�t�)}.  %++++ � revoir l'appel, c'est bizarre comment �a marche.
v(verbe(sont), est_type(Propri�t�), pierre_pour_type(Propri�t�), _, Propri�t�)-->[sont], {Sujet = pierre, est_type(Propri�t�)}.

% Est-ce que le marbre est ign�?
v(verbe(est), type(Sujet, Propri�t�), Sujet, Propri�t�)-->[est], {est_pierre(Sujet), est_type(Propri�t�)}.
v(verbe(sont), type(Sujet, Propri�t�), Sujet, Propri�t�)-->[sont], {est_pierre(Sujet), est_type(Propri�t�)}.


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
n(nom(gr�s), gr�s)-->[gr�s].
n(nom(conglom�rat), conglom�rat)-->[conglom�rat].
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


adj(adjectif(m�tamorphique), m�tamorphique)-->[m�tamorphique].
adj(adjectif(m�tamorphiques), m�tamorphique)-->[m�tamorphiques].
adj(adjectif(s�dimentaire), s�dimentaire)-->[s�dimentaire].
adj(adjectif(s�dimentaires), s�dimentaire)-->[s�dimentaires].
adj(adjectif(ign�),ign�e)-->[ign�].
adj(adjectif(ign�e),ign�e)-->[ign�e].
adj(adjectif(ign�es), ign�e)-->[ign�es].




