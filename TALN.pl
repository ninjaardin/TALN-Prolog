% Auteur:
% Date: 2014-11-22


% Base de connaissances

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

type(marbre, m�tamorphique).
type(schiste, m�tamorphique).
type(gneiss, m�tamorphique).
type(ardoise, m�tamorphique).
type(schiste_argileux, m�tamorphique).

type(gabbro, ign�e).
type(granit, ign�e).
type(scorie, ign�e).
type(pierre_ponce, ign�e).
type(obsidienne, ign�e).
type(rhyolite, ign�e).
type(basalte, ign�e).

type(gr�s, s�dimentaire).
type(conglom�rat, s�dimentaire).
type(tuf, s�dimentaire).
type(calcaire, s�dimentaire).


%Commandes g�n�rales

lancer( Question, R�ponse ) :- repondre(Question, Sens), evaluer(Sens, R�ponse).

repondre(Question, Sens) :- analyse(_, Sens, Question, []).

evaluer(Sens, R�ponse):- call(Sens, R�ponse). % � revoir, c'est un peu bizarre comment �a fonctionne.


%Interpr�tation

% ?-analyse(Arbre_synt, Semantique, [quelles, pierres, sont, s�dimentaires], []).

analyse(groupePhrase(GN,GV), S�mantique)-->
        gn(GN, Agent),
        gv(GV, S�mantique, Agent).

gn(groupeNominal(Adj_int,N), Agent)-->
        adj_int(Adj_int),
        n(N, Agent).

%gn(groupeNominal(Art,N))-->art(Art),n(N).

gv(groupeVerbal(V,Adj), S�mantique, Sujet)-->
        v(V, S�mantique, Sujet, Propri�t�),
        adj(Adj, Propri�t�).

%gv(groupeVerbal(V,GN))-->v(V),gn(GN).

adj_int(adjectif_interrogatir(quelle))-->[quelle].
adj_int(adjectif_interrogatir(quelles))-->[quelles].

v(verbe(est), pierre_pour_type(Propri�t�), _, Propri�t�)-->[est].  %++++ � revoir l'appel, c'est bizarre comment �a marche.
v(verbe(sont), pierre_pour_type(Propri�t�), _, Propri�t�)-->[sont].

n(nom(pierre), pierre)-->[pierre].
n(nom(pierres), pierre)-->[pierres].

adj(adjectif(m�tamorphique), m�tamorphique)-->[m�tamorphique].
adj(adjectif(m�tamorphiques), m�tamorphique)-->[m�tamorphiques].
adj(adjectif(s�dimentaire), s�dimentaire)-->[s�dimentaire].
adj(adjectif(s�dimentaires), s�dimentaire)-->[s�dimentaires].
adj(adjectif(ign�e),ign�e)-->[ign�e].
adj(adjectif(ign�es), ign�e)-->[ign�es].

%art(article(un))-->[un].

%n(nom(felin))-->[felin].
%n(nom(carnivore))-->[carnivore].


