-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriel
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE SPExemplo1 
	-- Add the parameters for the stored procedure here
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    Select PeNome, PeCor 
    from Peca
	
END
GO

--Exemplo 1
CREATE Procedure SP_PROJETO as 
Select p.PNome, p.PCusto
from Projeto p

--exemplo 2
Create procedure SPFornecedoresBusca as
begin
select * 
from Fornecedor
end

-- Exemplo 3 Com parametros
Create procedure SPFornecedoresCParametros (@NumForn int) as
begin 
	select * from Fornecedor f where f.FNro = @NumForn
end

-- Executando exemplo 3
EXEC SPFornecedoresCParametros 3


--Exemplo 4
create procedure SPFornecedoresLIKE (@FornNome as varchar(20)) as
begin
	select * from Fornecedor f where f.FNome like @FornNome + '%'
end
--Executando exemplo 4
EXEC SPFornecedoresLIKE P

--Exemplo 5
create procedure SPFornecedoresLIKE2 (@FornNome as varchar(20)) as
begin
	select * from Fornecedor f where f.FNome like '_' + @FornNome + '%'
end

--Executando exemplo 5
EXEC SPFornecedoresLIKE2 i

--Exemplo 6
Create procedure SPFornecINSERIR (
	@forn_num as int,
	@forn_nome as varchar(20),
	@forn_cidade as varchar(30),
	@forn_categ as varchar(1)) as
begin
	INSERT INTO Fornecedor (FNro, FNome, FCidade, FCateg)
	VALUES (@forn_num,@forn_nome,@forn_cidade,@forn_categ)
end
--Executando exemplo 6
select * from Fornecedor;
EXEC SPFornecINSERIR 6, AlphaSpirit, Avaré, G

--Exemplo 7
create procedure SPForncUPDATE(
	@forn_num as int, @forn_nome as varchar(20) 
								)as
begin 
	UPDATE Fornecedor
	SET FNome = @forn_nome
	WHERE FNro = @forn_num
end

--Executando exemplo 7
select * from Fornecedor;
EXEC SPForncUPDATE 6, "JR"

--Exemplo 8

create procedure SPPecaUPDATE( @pc_num as int, @pc_nome as varchar(20), @pc_preco float)as
begin
	UPDATE Peca
	SET PeNome = @pc_nome,
		PePreco = @pc_preco
	WHERE PeNro = @pc_num
end

select * from Peca
EXEC SPPecaUPDATE 22, Outro, 60

--Exemplo 9
create procedure SPForncDELETE ( @forn_num as int ) as
begin 
	DELETE FROM Fornecedor 
	WHERE FNro = @forn_num
end

--Executando exemplo 9
select * from Fornecedor
EXEC SPForncDELETE 6


-- EXEMPLO 10
create procedure SPPecasFornecidas( @numPeca as int)as
begin
	select  p.PeNome, P.PeNro numeroPeca, fp.Quant, fp.PNro NumeroProjeto
	from Peca p, Fornece_Para fp
	where	p.PeNro = @numPeca
			and p.PeNro = fp.PeNro
end
--EXECUTANDO EXEMPLO 10
EXEC SPPecasFornecidas 4

--EXEMPLO 11

alter procedure SPFornecimentosBuscar as
begin
	select DISTINCT p.PeNome, f.FNome, fp.Quant
	from Peca p, Fornece_Para fp, Fornecedor f
	where	f.FNro = fp.FNro and
			p.PeNro = fp.PeNro
end
--EXECUTANDO EXEMPLO 11
select * from Fornece_Para
EXEC SPFornecimentosBuscar 

--EXEMPLO 12
create procedure SPPecasFornecedores(@numPeca as int)as
begin
	select p.PeNome, f.FNome, fp.Quant
	from Fornecedor f, Fornece_Para fp, Peca p
	where p.PeNro = @numPeca and
			p.PeNro = fp.PeNro and
			fp.FNro = f.FNro
end

--EXECUTANDO EXEMPLO 12
EXEC SPPecasFornecedores 4

--EXEMPLO 13
alter procedure SPQuantFornecida(@qtd as int)as
begin 
	select p.PeNome, f.FNome, fp.Quant
	from Peca p, Fornecedor f, Fornece_Para fp
	where fp.Quant >= @qtd and
		  p.PeNro = fp.PeNro and
		  fp.FNro = f.FNro

end

--EXECUTANDO EXEMPLO 13

EXEC SPQuantFornecida 3

--EXEMPLO 14

create procedure SPFornecimentosPECAquant( @numeroPeca as int, @qtd as int ) as
begin
	select  p.PeNome, f.FNome, fp.Quant
	from Peca p, Fornecedor f, Fornece_Para fp
	where p.PeNro = @numeroPeca and
		p.PeNro = fp.PeNro and
		fp.Quant >= @qtd and
		fp.FNro = f.FNro

end

--EXECUTANDO EXEMPLO 14
EXEC SPFornecimentosPECAquant 4, 3

--EXEMPLO 15

create procedure SPFornecimentoBUSCAR( @corPeca as varchar(20), @qtd as int )as
begin
	select p.PeNome, p.PeCor, fp.Quant
	from Peca p, Fornece_Para fp
	where p.PeCor = @corPeca and
		fp.Quant >= @qtd and
		p.PeNro = fp.PeNro
end

EXEC SPFornecimentoBUSCAR 'amarelo', 3

--EXEMPLO 16

create procedure SPPecasTotais as
begin
	select p.PeNome, p.PePreco, SUM(fp.Quant) quantidade, SUM (p.PePreco * fp.Quant) total
	from Peca p, Fornece_Para fp
	where  p.PeNro = fp.PeNro
			GROUP BY p.PeNome, p.PePreco
end

--EXECUTANDO EXEMPLO 16
EXEC SPPecasTotais

--EXEMPLO 17

alter procedure SPFornecimentosTotaisPeca(@numPeca as int)as
begin
	select p.PeNome, f.FNome, SUM(p.PePreco * fp.Quant) total
	from Peca p, Fornece_Para fp, Fornecedor f
	where p.PeNro = @numPeca and
		  p.PeNro = fp.PeNro and
		  f.FNro = fp.FNro
	group by p.PeNome, f.FNome

end

--EXECUTANDO EXEMPLO 17
select * from Peca;
select * from Fornece_Para;
EXEC SPFornecimentosTotaisPeca 2


--EXEMPLO 18

alter procedure SPMaxFornecimento as
begin
	select p.PeNro,p.PeNome, MAX(fp.Quant) máximo
	from Peca p, Fornece_Para fp
	where p.PeNro = fp.PeNro
	group by fp.PeNro, p.PeNome, p.PeNro
	having MAX(fp.Quant)> 1
end

--EXECUTANDO EXEMPLO 18

EXEC SPMaxFornecimento

--EXEMPLO 19
create procedure SPwhile
as
begin
	declare @i int --declarando variável
	set @i = 1
	while (@i <10)
	begin
		print @i
		set @i = @i + 1
	end
end

-- executando exemplo 19
exec SPwhile

--EXEMPLO 20

alter PROCEDURE SPEx4
as
begin
	DECLARE @n as int SET @n = 50
	DECLARE @soma as int SET @soma = 0
	WHILE @n <= 100
	begin
		if(@n % 2)=0
		begin
			PRINT CAST(@n as varchar) + '+' + CAST(@soma AS VARCHAR)+'=' + CAST(@soma as varchar)
			SET @soma = @soma + @n
		end
		SET @n = @n + 1
	end	
	--PRINT @soma
	
	
end

--EXECUTANDO EXEMPLO 21

exec SPEx4




--Exercício 1

--1.	Crie uma Stored Procedure de nome sp_ex1_proj que receba 
--como parâmetro o código do projeto e mostre o nome e a duração do mesmo.

create procedure sp_ex1_proj (@numProj as int)
as
begin
	select pj.PNome NomeProjeto, pj.PDuracao DuracaoProjeto
	from Projeto pj
	where pj.PNro = @numProj;
end
select * from Projeto
EXEC sp_ex1_proj 2

--Exercício 2

--2.	Crie uma Stored Procedure de nome sp_ex2_forn que receba um texto como parâmetro, 
--indicando um trecho do nome do fornecedor, e mostre o nome e a categoria do fornecedor.

alter procedure sp_ex2_forn (@txt as varchar(20))
as
begin
	select f.FNome NomeFornecedor, f.FCateg CategoriaFornecedor
	from Fornecedor f
	where f.FNome LIKE '%'+@txt+'%'
end

select * from Fornecedor
EXEC sp_ex2_forn 'pla'

--Exercício 3

--3.	Crie uma Stored Procedure de nome sp_ex3_peça 
--que inclua na tabela peça somente 3 campos: número, nome e preço. Inclua uma peça.
CREATE procedure sp_ex3_peça (@numPeca as int, 
							@nomePeca as varchar(20), 
							@precoPeca as float)
as
begin
	INSERT INTO Peca (PeNro, PeNome, PePreco)
	VALUES (@numPeca, @nomePeca, @precoPeca)
end

select * from Peca
EXEC sp_ex3_peça 34, 'Eros', 20

--Exercício 4
--4.	Crie uma Stored Procedure de nome sp_ex4_peça que altere a peça incluída em pelo menos 2 campos.

alter procedure sp_ex4_peca (@numPeca as int,@nomePeca as varchar(20), @precoPeca as float )
as
begin
	UPDATE Peca SET PeNome = @nomePeca, PePreco = @precoPeca WHERE PeNro = @numPeca
end

select * from Peca
EXEC sp_ex4_peca 9,'Chapuletona',53.0
go

--Exercício 5
--5.	Crie uma Stored Procedure de nome sp_ex5_peça 
--que exclua a peça anterior, que foi incluída e alterada no exercício anterior.

create procedure sp_ex5_peça (@numPeca as int)
as
begin
	DELETE FROM Peca 
	WHERE PeNro = @numPeca
end
select * from Peca
EXEC sp_ex5_peça 9

--Exercício 6
--6.	Crie uma StoredProcedure que receba o nº do projeto e liste os nomes dos mesmos
-- e os nomes de peças, bem como as quantidades fornecidas, renomeando as colunas.

alter procedure sp_exer6 (@numProj as int)
as
begin
	select pr.PNome Nome, p.PeNome NomePeca, fp.Quant QuantidadePeças
	from Projeto pr, Peca p, Fornece_Para fp
	where pr.PNro = @numProj and
		  pr.PNro = fp.PNro and
		  fp.PeNro = p.PeNro
end

select * from Peca
select * from Fornece_Para 
select * from Projeto
EXEC sp_exer6 1

--Exercício 7
--7.	Enviar o código do projeto para a stored procedure 
--e listar o nome do projeto e do fornecedor referente a este código do projeto

alter procedure sp_exer7 (@numProjeto as int)
as
begin
	select pr.PNome NomeProjeto, f.FNome Fornecedor
	from Projeto pr, Fornecedor f, Fornece_Para fp
	where pr.PNro = @numProjeto and
		  fp.PNro = pr.PNro and
		  fp.FNro = f.FNro
end

select * from Fornecedor
select * from Projeto
select * from Fornece_Para 
EXEC sp_exer7 4

--Exercício 8
--8.	Criar uma Stored Procedure que receba a quantidade de peças fornecidas e 
--verifique quais quantidades estão abaixo desse valor, mostrando o nome do projeto,
-- da peça e do fornecedor.

create procedure sp_exer8 (@qtdPeca as int)
as
begin
	select p.PeNome NomePeca, pr.PNome NomeProjeto, f.FNome Fornecedor
	from Peca p, Fornecedor f, Projeto pr, Fornece_Para fp
	where fp.Quant < @qtdPeca and
		  fp.PeNro = p.PeNro and
		  fp.FNro = f.FNro and
		  fp.PNro = pr.PNro
		  
end
select * from Fornece_Para
select * from Peca
Exec sp_exer8 2

--LISTA 2

--EXERCICIO 1
--Crie uma Stored Procedure que receba uma quantidade de peças e mostre os nomes de projetos,
-- peças e fornecedores que possuam quantidades iguais ou inferiores à quantidade passada.
alter procedure L2exer1 (@qtd as int)
as
begin
	select p.PeNome Peca, f.FNome Fornecedor, pj.PNome Projeto
	from Peca p, Fornecedor f, Projeto pj, Fornece_Para fp
	where fp.Quant <= @qtd and
		  f.FNro = fp.FNro and
		  p.PeNro = fp.PeNro and
		  pj.PNro = fp.PNro
end
select * from Fornece_Para
EXEC L2exer1 1

--EXERCICIO 2
--Crie uma Stored Procedure que receba o código do projeto e uma determinada 
--quantidade de peças e mostre o nome do projeto e fornecedores que possuam quantidades 
--iguais ou superiores à quantidade passada
create procedure L2exer2 (@codProj as int, @qtdPeca as int)
as
begin
	select pj.PNome Projeto, f.FNome Fornecedor
	from Projeto pj, Fornecedor f, Fornece_Para fp
	where fp.Quant >= @qtdPeca AND
		  fp.FNro = f.FNro and
		  pj.PNro = @codProj and
		  fp.PNro = pj.PNro 
		  
end
select * from Fornece_Para
select * from Projeto
select * from Fornecedor
Exec L2exer2 2, 10

--EXERCÍCIO 3
--Faça uma Stored Procedure que receba o código do projeto e mostre o nome do projeto, 
--peças e fornecedores com o valor total das peças (quantidade * preço).

alter procedure L2exer3 (@codProj as int)
as
begin
	select pj.PNome Projeto, p.PeNome Peca, f.FNome Fornecedor, SUM(fp.Quant * p.PePreco) valorTotal
	from Projeto pj, Fornecedor f, Fornece_Para fp, Peca p
	where @codProj = pj.PNro and
		  pj.PNro = fp.PNro and
		  f.FNro = fp.FNro and
		  p.PeNro = fp.PeNro
	group by pj.PNome, p.PeNome , f.FNome 
end

EXEC L2exer3 4

--EXERCICIO 4
--Faça uma Stored Procedure que some os números pares de 50 a 100.
alter procedure L2exer4 
as
begin
	DECLARE @num as int SET @num = 50
	DECLARE @cont as int SET @cont = 0
	while @num <=100 begin
		
		if ((@num % 2) = 0)begin
			print @cont
			SET @cont += @num
		end
		SET @num += 1
	end
end

EXEC L2exer4