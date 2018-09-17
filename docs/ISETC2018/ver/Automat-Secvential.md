Diagrama de tranzitii:

![Diagrama de tranzitii](/media/image1.emf)

Tabelul de adevar numarator:


Ld	| PT	| Action
----|-------|---------------
0	| x		| load
1	| 0		| maintain
1	| 1		| count
----------------------------
Operatii combinate
----------------------------
Ld	| PT	| Action
----|-------|---------------
var-m	| 0	| load+maintain
1	|var-c	|count+maintain
var-c	|1	| load+count
0	|x	| load+load(depends on the variable)


