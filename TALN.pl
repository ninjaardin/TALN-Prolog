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

propri�t�(marbre, r�agit_acide).
propri�t�(calcaire, r�agit_acide).

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



% Commandes g�n�rales

lancer :- lire(_, Question),
          poser_question(Question, R�ponse),
          write(R�ponse).

poser_question( Question, R�ponse ) :- repondre(Question, Sens), evaluer(Sens, R�ponse).
poser_question( _, 'Question invalide.').

repondre(Question, Sens) :- analyse(_, Sens, Question, []).

evaluer(Sens, R�ponse):- call(Sens, R�ponse).



% Pr�dicats �valu�s

toutes_pierres_pour_type(Type, R�ponse) :- findall(Pierre, type(Pierre, Type), R�ponse).

est_type(Pierre, Type, R�ponse) :- call(type(Pierre, Type)), !, R�ponse = oui.
est_type(_, _, R�ponse) :- R�ponse = non.

toutes_pierres_reagit_acide_pour_type(Type, R�ponse) :- findall(Pierre, pierre_pour_type_et_propri�t�(Pierre, Type, r�agit_acide), R�ponse).
pierre_pour_type_et_propri�t�(Pierre, Type, Propri�t�) :- type(Pierre, Type), propri�t�(Pierre, Propri�t�).

toutes_propri�t�s_communes(Pierre1, Pierre2, R�ponse) :- findall(Propri�t�, propri�t�_communnes(Pierre1, Pierre2, Propri�t�), Propri�t�_communes), ajouterTypeCommun(Pierre1, Pierre2, Propri�t�_communes, R�ponse).
propri�t�_communnes(Pierre1, Pierre2, Propri�t�) :- propri�t�(Pierre1, Propri�t�), propri�t�(Pierre2, Propri�t�).
ajouterTypeCommun(Pierre1, Pierre2, Propri�t�_communes, [Type_commun|Propri�t�_communes]) :- type(Pierre1, Type_commun), type(Pierre2, Type_commun).
ajouterTypeCommun(_, _, Propri�t�_communes, Propri�t�_communes).





% Lecture des entr�es de l'utilisateur

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

% EX: Est-ce que le marbre est ign�?
analyse(groupePhrase(INT, GN, GV), S�mantique)-->
        int(INT),
        gn(GN, Agent),
        gv(GV, S�mantique, Agent).

% EX: Quelles sont les pierres s�dimentaires?
analyse(groupePhrase(INT, GV, GA), S�mantique)-->
        int(INT),
        gv(GV, S�mantique, Propri�t�),
        ga(GA, Propri�t�).

% EX: Le schiste est-il m�tamorphique?
analyse(groupePhrase(GN, V_INT, GA), S�mantique)-->
        gn(GN, Agent),
        v_int(V_INT, S�mantique, Agent, Propri�t�),
        ga(GA, Propri�t�).
        
% EX: Quelles pierres s�dimentaires r�agissent � l'acide?
analyse(groupePhrase(INT, GN, GA, GV), S�mantique)-->
        int(INT),
        gn(GN, Agent),
        ga(GA, Type),
        gv(GV, S�mantique, Agent, Type).

% EX: Qu'ont en commun le schiste et le gneiss?
analyse(groupePhrase(V_INT, GA, GN1, CONJ, GN2), S�mantique)-->
        v_int(V_INT, S�mantique, Sujet1, Sujet2, Lien),
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
        
        

gv(groupeVerbal(V,Adj), S�mantique, Sujet)-->
        v(V, S�mantique, Sujet, Propri�t�),
        adj(Adj, Propri�t�).

gv(groupeVerbal(V,GN), S�mantique, Propri�t�)-->
        v(V, S�mantique, Sujet, Propri�t�),
        gn(GN, Sujet).

gv(groupeVerbal(V,COMP), S�mantique, Sujet, Type)-->
        v(V, S�mantique, Sujet, Type, Propri�t�),
        comp(COMP, Propri�t�).



ga(groupeAdjectival(ADJ), Adjectif)-->
        adj(ADJ, Adjectif).

ga(groupeAdjectival(PR�P, ADJ), Adjectif)-->
        pr�p(PR�P),
        adj(ADJ, Adjectif).



comp(compl�ment(PR�P, GN), Propri�t�)-->
        pr�p(PR�P),
        gn(GN, Propri�t�).



% Quelles sont les pierres s�dimentaires?
v(verbe(est), toutes_pierres_pour_type(Propri�t�), Sujet, Propri�t�)-->[est], {Sujet = pierre, est_type(Propri�t�)}.  %++++ � revoir l'appel, c'est bizarre comment �a marche.
v(verbe(sont), toutes_pierres_pour_type(Propri�t�), Sujet, Propri�t�)-->[sont], {Sujet = pierre, est_type(Propri�t�)}.

% Est-ce que le marbre est ign�?
v(verbe(est), est_type(Sujet, Propri�t�), Sujet, Propri�t�)-->[est], {est_pierre(Sujet), est_type(Propri�t�)}.
v(verbe(sont), est_type(Sujet, Propri�t�), Sujet, Propri�t�)-->[sont], {est_pierre(Sujet), est_type(Propri�t�)}.

% Le schiste est-il m�tamorphique?
v_int(verbe_interrogatif('est-il'), est_type(Sujet, Propri�t�), Sujet, Propri�t�)-->['est-il'], {est_pierre(Sujet), est_type(Propri�t�)}.
v_int(verbe_interrogatif('est-elle'), est_type(Sujet, Propri�t�), Sujet, Propri�t�)-->['est-elle'], {est_pierre(Sujet), est_type(Propri�t�)}.
v_int(verbe_interrogatif('sont-ils'), est_type(Sujet, Propri�t�), Sujet, Propri�t�)-->['sont-ils'], {est_pierre(Sujet), est_type(Propri�t�)}.
v_int(verbe_interrogatif('sont-elles'), est_type(Sujet, Propri�t�), Sujet, Propri�t�)-->['sont-elles'], {est_pierre(Sujet), est_type(Propri�t�)}.

% Quelles pierres s�dimentaires r�agissent � l'acide?
v(verbe(r�agit), toutes_pierres_reagit_acide_pour_type(Type), Sujet, Type, Propri�t�)-->['r�agit'], {Sujet = pierre, est_type(Type), Propri�t� = acide}.
v(verbe(r�agissent), toutes_pierres_reagit_acide_pour_type(Type), Sujet, Type, Propri�t�)-->['r�agissent'], {Sujet = pierre, est_type(Type), Propri�t� = acide}.

% Qu'ont en commun le schiste et le gneiss?
v_int(verbe_interrogatif('qu''ont'), toutes_propri�t�s_communes(Sujet1, Sujet2), Sujet1, Sujet2, Lien)-->['qu''ont'], {est_pierre(Sujet1), est_pierre(Sujet2), Lien = commun}.



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

n(nom(acide), acide)-->[acide].
n(nom('l''acide'), acide)-->['l''acide'].


adj(adjectif(m�tamorphique), m�tamorphique)-->[m�tamorphique].
adj(adjectif(m�tamorphiques), m�tamorphique)-->[m�tamorphiques].
adj(adjectif(s�dimentaire), s�dimentaire)-->[s�dimentaire].
adj(adjectif(s�dimentaires), s�dimentaire)-->[s�dimentaires].
adj(adjectif(ign�),ign�e)-->[ign�].
adj(adjectif(ign�e),ign�e)-->[ign�e].
adj(adjectif(ign�es), ign�e)-->[ign�es].

adj(adjectif(commun), commun)-->[commun].

pr�p(pr�position(�))-->[�].
pr�p(pr�position(en))-->[en].


conj(conjonction(et))-->[et].
