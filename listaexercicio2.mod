param p;

# Conjunto dos índices associados aos pontos terminais 'a'
set P := { 1..p };

# Conjunto dos índices associados aos pontos de Steiner
set S := { p+1..2*p-2 };

# Conjunto de todos os índices
set V := P union S;

# Conjunto das arestas ligando um ponto terminal (índice em P) a um ponto de Steiner (índice em S)
set E1 := { (i, j) in {P, S} : i < j };

# Conjunto das arestas ligando um ponto de Steiner (índice em S) a outro ponto de Steiner (índice em S)
set E2 := { (i, j) in {S, S} : i < j };

# Conjunto de todas as arestas
set E := E1 union E2;

# Coordenadas dos pontos terminais 'a'
param a_x {P};
param a_y {P};

# Coordenadas dos pontos steiner 'x'
var x_x {S};
var x_y {S};

# Definida para cada aresta (i,j) pertencente a E. Se estiver na AMS será = 1, caso não será = 0
var y {V, V} binary;

# Conjunto das arestas ligando um ponto terminal (índice em P) a um outro ponto terminal (índice em P)
set E3 := { (i, j) in {P, P} : i < j };

# Cota superior para cada aresta da AMS, que permite a obtenção da formulação convexa
param M :=
	max { (i, j) in E3 }
		sqrt ( (a_x[i]-a_x[j])^2 + (a_y[i]-a_y[j])^2 );

# d representa a distância euclidiana entre os pontos de índices i e j do conjunto V		
var d {i in V, j in V} =
	sqrt (
		if (i in P) and (j in P) then
			( (a_x[i]-a_x[j])^2 + (a_y[i]-a_y[j])^2 )
		else if (i in P) and (j in S) then
			( (a_x[i]-x_x[j])^2 + (a_y[i]-x_y[j])^2 )
		else if (i in S) and (j in P) then
			( (x_x[i]-a_x[j])^2 + (x_y[i]-a_y[j])^2 )
		else
			( (x_x[i]-x_x[j])^2 + (x_y[i]-x_y[j])^2 )	);

s.t. restricao_1 { (i, j) in E1 }: d[i, j] >= ( d[i, j] - M * (1 - y[i, j]) );
s.t. restricao_2 { (i, j) in E2 }: d[i, j] >= ( d[i, j] - M * (1 - y[i, j]) );
s.t. restricao_3 { (i, j) in E }: d[i, j] >= 0;
s.t. restricao_4 { (i, j) in E }: d[i, j] <= M;

# Determina que o grau de cada ponto de Steiner deve ser igual a 3
s.t. restricao_5 { j in S }: ( sum { i in P } y[i, j] + sum { k in { k in S : k < j } } y[k, j] + sum { k in { k in S : k > j } } y[j, k] ) = 3;

# Determina que o grau de cada ponto terminal é igual a 1
s.t. restricao_6 { i in P }: ( sum { j in S } y[i, j] ) = 1;
s.t. restricao_7 { j in (S diff {p+1}) }: ( sum { i in { i in S : i < j } } y[i, j] ) = 1;

# Modelagem com a minimização das distâncias entre pontos (terminal-steiner) e (steiner-steiner);
minimize objetivo:
	(sum { (i, j) in E1 } d[i, j] * y[i,j]) + (sum { (i, j) in E2 } d[i, j] * y[i,j]);

data;

param p := 6;

param: a_x a_y :=
	1  0.0 1.0
	2  2.0 0.0
	3  5.0 0.0
	4  7.0 1.0
	5  5.0 2.0
	6  2.0 2.0;