/*CRIANDO UMA VIEW*/
Create View PecasNome AS 
select PeNome 
From Peca;

Create View VisaoFornecedor as
select f.FNome, f.FCateg, f.FCidade
from Fornecedor f
where f.FCidade = 'Campinas' and f.FCateg in ('A','B');

Create view VisaoQuantPecas as 
Select p.PeNome, fp.Quant 
from peca p
inner join Fornece_Para fp on p.PeNro = fp.PeNro
Where fp.Quant > 2;

Create view VisFornecPecas as
select  f.Fnome nomeFornecedor, p.PeNome NomePeças
from Fornecedor f inner join Fornece_Para fp on fp.FNro = fp.FNro
	 inner join Peca p on fp.PeNro = p.PeNro;
	 

Create view VisaoFornecedoresPecas as
select p.PeNome NomePeca
from Peca P
WHERE P.PeNro IN (
		select distinct fp.PeNro
		from Fornece_Para fp
		where fp.FNro <> ALL(
			select f.FNro
			from Fornecedor f
			where f.FCateg = 'A'))
	 
create view VisaoMediaQuantPecas as
select p.PeNome NomePecas, AVG(fp.Quant)MédiaPeças
from Peca p
inner join Fornece_Para fp ON p.PeNro = fp.PeNro
GROUP BY p.PeNome, p.PeNro
HAVING AVG(fp.Quant)>1


/*Exercício 1*/

create view Exer1 as

select p.PNome NomeProjeto, p.PDuracao duracao, p.PCusto custo
from Projeto p
where p.PDuracao > 2 and p.PCusto > 30000;

create view Exer2 as
select DISTINCT p.PNome Nome, p.PCusto Custo 
from Projeto p
inner join Fornece_Para fp on p.PNro = fp.PNro where p.PCusto < 30000
	and fp.Quant = 1
	
create view Exer3 as
select p.PNome Nome, pe.PeNome
from projeto p
inner join Fornece_Para fp on fp.PNro = p.PNro
	inner join Peca pe on fp.PeNro = pe.PeNro and pe.PeCor = 'Vermelho'
	 
select * from Peca;
select * from Projeto;
select * from Fornece_Para;


create view Exer4 as
select DISTINCT pe.PeNro Código ,pe.PeNome Nome
from Peca pe
inner join Fornece_Para fp on fp.PeNro = pe.PeNro;

create view Exer5 as
select DISTINCT f.FNome Nome, pe.PeNome
from Fornecedor f
inner join Fornece_Para fp on fp.FNro = f.FNro
	inner join Peca pe on fp.PeNro = pe.PeNro;
	
create view Exer6 as
select * 
from Fornecedor as f 
where f.FCidade = 'Campinas';

create view Exer7 as
select p.PNome Nome
from Projeto p
where (p.PDuracao >=3 and p.PDuracao <=5) and p.PCusto <30000;

create view Exer8 as
select f.FCidade
from Fornecedor f
where f.FCateg = 'A' or f.FCateg = 'B';

create view Exer9 as
select DISTINCT p.PNome, pe.PeNome
from Peca pe
inner join Fornece_Para fp on fp.PeNro = pe.PeNro
inner join Projeto p on fp.PNro = p.PNro;

create view Exer10 as
select  pe.PeNome, fp.Quant, p.PNome
from Fornece_Para fp
inner join Projeto p on fp.PNro = p.PNro
inner join Peca pe on fp.PeNro = pe.PeNro;

select * from Peca;


create view Exer11 as
select  distinct X.PeNro
from Peca x, Peca y
where (x.PeCor = y.PeCor)
AND (X.PeNro <> y.PeNro);


