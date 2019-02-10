	#Sistema Multiprocessore, senza preemption.
	
	
	
	# Insiemi
	## Parametri
	param t;
	param p;
	set T := 1..t;
	set P := 1..p;
	param te{i in T, n in P}, >=0 ; #tempo di esecuzione del processo i sul processore j
	param d{i in T} >=0 ;	#tempo di consegna previsto del processo. 
	param maxD := max{i in T}(d[i]); 	#limite superiore esplicito 
		
	var x{i in T, n in P}, >=0; #istante in cui far partire l'operazione i su il processore j.
	var rit, >=0;	#quantita da minimizzare (ritardo massimo fra tutti i processi)
	var delta{l in T, m in T, n in P}, binary ; #utilizzo per dare l'ordine alle operazioni
	
								##########			OBBIETTIVO		###########

	
	
	#Devo minimizzare il tempo di ritardo massimo dalla fine di un processo e il tempo di consegna prevista per esso.
		
	minimize minimoRitardo:	rit;

								##########			VINCOLI			###########
	
	#Ritardo massimo su tutti i processi sull'ultimo processore.
	s.t. ritardo_processo {i in T}:
		x[i,p]+te[i,p]-d[i] <= rit;
	
	#Supponiamo che l e m siano due attività di durata rispettivamente pari a te,l e te,m.
	#Supponiamo anche che inizino in un determinato intervallo che ha come estremo superiore maxD.
	#vinc1 ci dice che l puo iniziare solo quando finisce m.
	#vinc2 ci dice che m puo iniziare solo quando finisce l.
	#Impongo che le operazioni non possono essere interrotte.
	
	s.t. vinc1 {l in T,m in T, n in P: l<m}:
		x[l,n] >= x[m,n] + te[m,n]*(1-delta[l,m,n])-maxD*delta[l,m,n];
	s.t. vinc2 {l in T,m in T, n in P: l<m}:
		x[m,n] >= x[l,n] + te[l,n]*delta[l,m,n]-maxD*(1-delta[l,m,n]);

	###Vincolo che impone che la sequenzialita delle operazioni sui processori da 1->2->..->p
	
	s.t. sequenzialita_processori {l in T, n in (P diff {p})}:
		x[l,n]+te[l,n]<= x[l,n+1];
		
		
		