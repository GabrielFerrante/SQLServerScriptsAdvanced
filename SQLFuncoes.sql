declare @MinhaTabela TABLE (PeNro int Primary Key, Penome varchar(20))

Insert into @MinhaTabela
select distinct PeNro, PeNome
from Peca where PeNome like 'L%'

Select * from @MinhaTabela
--FUNÇÕES SCALAR VALUED
--EXEMPLO FUNCTION
create function Volume (@altura decimal, @largura decimal, @profund decimal)
returns decimal
as
begin
	return (@altura* @largura * @profund)

end
select dbo.Volume(12.2, 10.6, 10.0)


--EXERCÍCIO 2
alter function Delta (@a int, @b int, @c int)
returns int
as
begin
	return ((power (@b,2))- 4 *(@a * @c))
end

select dbo.Delta(1,-12,7)

CREATE FUNCTION

--FUNÇÕES INLINE TABLE VALUED
--EXEMPLO 1
create function fcFornecedoresCidade(@cidade varchar (20))
returns table
as
return(
		select f.FNome, f.FCateg
		from Fornecedor f
		where f.FCidade = @cidade
		)
Select * from fcFornecedoresCidade ('Campinas')

--EXEMPLO 2
create function fcPrecoPecas(@Preco float)
RETURNS table
as
return (
	Select p.PeNro, p.PeNome, p.PePreco, p.PeCor
	From Peca p
	Where P.PePreco > @Preco
)
Select DISTINCT PeNome, PePreco 
from fcPrecoPecas(20)
--LISTA 1 FUNÇÕES INLINE

--1.	Crie a função ValorPeça para retornar o preço de uma peça.
-- A função tem um parâmetro de entrada que é o número da peça. Inclua a chamada à função.
create function exer1L1Inline(@numPeca int)
returns table
as
return
(
	select p.PePreco PrecoPeça
	from Peca p
	where p.PeNro = @numPeca
		  
)
select * from exer1L1Inline(9)

--2.	Crie uma função que receba um código de peça e retorne o total nos pedidos de fornecimento,
-- agrupados pela peça. Inclua a chamada à função.

alter function exer2L1Inline (@numPeca int)
returns table
as
return
(
	select p.PeNome, COUNT(fp.PeNro) totalPedidosDaPeca
	from Peca p, Fornece_Para fp
	where p.PeNro = @numPeca and
		  p.PeNro = fp.PeNro 
    GROUP BY p.PeNome
)
select * from exer2L1Inline(1)

--3.	Desenvolva uma função que receba o código de um fornecedor e retorne o custo total dos
-- projetos em que peças são fornecidas por esse fornecedor. Inclua a chamada à função.

alter function exer3L1Inline(@numForc int)
returns table 
as
return
(

	select pj.PNome, SUM(pj.PCusto)CustoTotalProjetos
	from Fornecedor f, Fornece_Para fp, Projeto pj, Peca p
	where f.FNro = @numForc and
		  f.FNro = fp.FNro and
		  p.PeNro = fp.PeNro and
		  pj.PNro = fp.PNro 
	Group by pj.PNome

)
select * from Fornecedor
select * from Fornece_Para
select * from Projeto
select * from exer3L1Inline(2)



--LISTA 2 FUNÇÕES INLINE

--Exercício 1
--1.	Desenvolva uma função que receba 
--o número do projeto e retorne os nomes e a duração daqueles que fornecem 
--peças que tenham preços inferiores a R$ 20,00. Inclua a chamada à função.

create function exer1 (@numProj as int)
returns table
as
return(
	select pj.PNome, pj.PDuracao
	from Projeto pj, Fornece_Para fp, Peca p
	where pj.PNro = @numProj and
		  fp.PNro = pj.PNro and
		  fp.PeNro = p.PeNro and
		  p.PePreco < 20
)
select * from Fornece_Para;
select * from Peca where PePreco < 20;
SELECT * FROM exer1 (4)

--Exercício 2
--2.	Crie uma função que receba o código de uma peça e o código de um projeto,
-- retornando os nomes dos projetos e peças e as quantidades fornecidas desse par de parâmetros.
-- Inclua a chamada à função.

alter function exer2(@numPeca as int, @numProj as int)
returns table
as
return(
	Select pj.PNome, p.PeNome, SUM(fp.Quant) quantidade
	from Projeto pj, Fornece_Para fp, Peca p
	where pj.PNro = @numProj and
		  fp.PNro = pj.PNro and
		  p.PeNro = @numPeca and
		  fp.PeNro = p.PeNro
	GROUP BY pj.PNome, p.PeNome
)

SELECT * FROM exer2 (1,4)

--Exercício 3
--3.	 Elabore uma função que receba o código de um fornecedor e retorne o nome 
--daqueles fornecedores e sua categoria cujas peças fornecidas tenham preços superiores
-- a R$ 20,00 e participam de projetos com períodos de até 4 meses. Inclua a chamada à função.

create function exer3 (@numFonc as int)
returns table
as
return(
	select f.FNome, f.FCateg
	from Fornecedor f, Peca p, Fornece_Para fp, Projeto pj
	where f.FNro = @numFonc and
		  fp.FNro = f.FNro and
		  fp.PeNro = p.PeNro and
		  fp.PNro = pj.PNro and
		  p.PePreco > 20 and pj.PDuracao <= 4
)
select * from Projeto;
select * from fornecedor;
select * from Fornece_Para;
select * from Peca;
select * from exer3(5)

--FUNÇOES MULTI-STATEMENT TABLE VALUED

--EXEMPLO 1

CREATE FUNCTION fc_QtdPecasFornecidas (@qtdPeca int)
returns @QuantidadePecasFornecidas TABLE
(
	nomePeca varchar (15),
	corPeca varchar (15),
	quantidade int
)
as 
begin
	INSERT @QuantidadePecasFornecidas
	SELECT p.PeNome, p.PeCor, fp.Quant
	FROM Peca p, Fornece_para fp
	WHERE p.PeNro = fp.PeNro and
		 fp.Quant > @qtdPeca
	RETURN
end

SELECT * FROM fc_QtdPecasFornecidas(2)

--LISTA 1 MULTI-STATEMENT TABLE VALUE

--1.	Crie uma função que retorne os nomes das peças, fornecedores e projetos com peças de 
--preço maior que $ 20 e que são fornecidas por empresas de São Paulo e utilizadas por projeto 
--com duração maior que 2 meses. Inclua a chamada à função.

alter function exer1Mult ()
RETURNS @tableExer1 TABLE
(
	NomePeca varchar(20),
	NomeFornecedor varchar (20),
	NomeProjeto varchar (20)

)
as
begin
	INSERT @tableExer1
	select p.PeNome, f.FNome, pj.PNome
	from Peca p, Fornece_Para fp, Projeto pj, Fornecedor f
	where (p.PeNro = fp.PeNro) and
		  (pj.PNro = fp.PNro) and
		  (f.FNro = fp.FNro)and
		  (p.PePreco > 20) and
		  (f.FCidade = 'São Paulo') and
		  (pj.PDuracao > '2')

	RETURN
end
select * from Projeto
select * from Fornecedor
select * from Peca
select * from Fornece_Para
select * from exer1Mult()

--2.	 Obtenha o nome dos projetos e de seus fornecedores que possuem algum fornecimento 
--de fornecedor da cidade de Campinas. Inclua a chamada à função.

alter function exer2Mult()
RETURNS @tableExer2 TABLE
(
	NomeProjeto varchar(15),
	NomeFornecedor varchar(15)

)
as
begin
	insert @tableExer2
	select pj.PNome, f.FNome
	from Fornecedor f, Fornece_Para fp, Projeto pj
	where pj.PNro = fp.PNro and
		  f.FNro = fp.FNro and
		  f.FCidade = 'Campinas'
	
	return

end

SELECT * FROM exer2Mult()

--3.	Desenvolva uma função que retorne o nome dos projetos e das peças não
-- fornecidas por fornecedores de categoria B. Inclua a chamada à função.

create function exer3Mult()
RETURNS @tableExer3 TABLE
(
	NomeProjeto varchar(20),
	NomePeca varchar(20)

)
as
begin

	insert @tableExer3
	select pj.PNome , p.PeNome
	from Peca p, Projeto pj, Fornece_Para fp, Fornecedor f
	where p.PeNro = fp.PeNro and
		  pj.PNro = fp.PNro and
		  f.FNro = fp.FNRO AND
		  f.FCateg not like 'b'
	
	return
end
select * from Projeto
select * from Fornecedor
select * from Peca
select * from Fornece_Para
select * from exer3Mult()

--LISTA REVISÃO
--Crie uma variável do tipo Table com os campos número, nome e duração dos projetos. 
--Armazene na variável Table todos os projetos com custo superior a R$ 20 000,00. 
--Em seguida mostre aqueles com duração maior ou igual a 2 meses.

declare @TableExer1Rev TABLE 
(PNro int primary key, PNome varchar(20), PDuracao varchar(20)) 
insert into @TableExer1Rev
select pj.PNro, pj.PNome, pj.PDuracao
from Projeto pj
where pj.PCusto > 20000

select *  
from @TableExer1Rev
where PDuracao > 2

--Crie uma função para calcular o "delta" de uma equação do 2º grau (as entradas são A, B e C).
-- delta = b² - 4 ac

create function exer2Rev (@A as int, @B as int, @C as int)
returns int	
as
begin
	return (@B * @B)- (4 * @A * @C)

end

select dbo.exer2Rev(1,-12,7)


--Crie uma função scalar que retorne o preço de uma peça reajustado de acordo com uma porcentagem 
--e um preço passados para a função. Na chamada à função você deve usar o Select/From/Where para buscar 
--o preço de uma peça qualquer na tabela Peça

alter function exer3Rev (@porc as int, @preco as decimal)
returns decimal 
as 
begin
	return (@preco + ((@preco / 100) * @porc ))
end

select dbo.exer3Rev(10,(select p.PePreco
					 from Peca p
					 where p.PeNro = 11))
					 
--Crie uma função do tipo Inline Table Valued que receba o número da peça e retorne quais os nomes 
--e a duração dos projetos com custo maior que R$30.000,00 e que fornecem essa peça.

alter function exer4Rev(@numPeca int)
returns table
as
return(
	
	select pj.PNro,pj.PNome, pj.PDuracao
	from Peca p, Projeto pj, Fornece_Para fp
	where p.PeNro = fp.PeNro and
		  pj.PNro = fp.PNro and
		  pj.PCusto > 30000 and
		  p.PeNro = @numPeca
		  

)
select * from Fornece_Para;
select * from Projeto;
select * from exer4rev(2)

--Crie uma função do tipo Inline Table Valued que receba a categoria do fornecedor e retorne 
--quais os nomes e a duração dos projetos que tais fornecedores participam.

create function exer5Rev (@cFor varchar(20))
returns table
as
return (
	select pj.PNome, pj.PDuracao
	from Fornecedor f, Fornece_Para fp, Projeto pj
	where f.FNro = fp.FNro and
		  fp.PNro = pj.PNro and
		  f.FCateg = @cFor
)
select * from Fornecedor;

select * from Fornece_Para;
select * from Projeto;
select * from exer5Rev('B')

--- Crie uma função do tipo Multi-Statement Table Valued que receba a quantidade de peças fornecidas e
-- o código da peça e retorne os nomes dos projetos e fornecedores que fornecem tal peça em quantidade
-- inferior ao parâmetro fornecido.

create function exer6Rev(@qtdPecaFor int, @numPeca int)
returns @tableExer6Rev table  
(
	Projeto varchar(20),
	Fornecedor varchar(20)

)
as
begin
	insert @tableExer6Rev
	select pj.PNome, f.FNome
	from Fornecedor f, Projeto pj, Fornece_Para fp, Peca p
	where p.PeNro = @numPeca and
		  fp.Quant < @NumPeca and
		  p.PeNro = fp.PeNro and
		  f.FNro = fp.FNro and
		  pj.PNro = fp.PNro 
		  
	return
end

select * from exer6Rev(2,2)