--EXEMPLO 1
/*
SELECT 'Antes de BEGIN TRAN', @@TRANCOUNT
	--VALOR IGUAL A 0
BEGIN TRANSACTION
	select 'PRIMEIRA TRANSACTION', @@TRANCOUNT
	--VALOR IGUAL A 1
	BEGIN TRANSACTION ANINHADA
		select 'SEGUNDA TRANSACTION', @@TRANCOUNT
		--valor igual a 2
		COMMIT TRANSACTION ANINHADA
	select 'PRIMEIRA TRANSACTION', @@TRANCOUNT
	--VALOR IGUAL A 1
	ROLLBACK TRANSACTION
SELECT 'DEPOIS DA TRAN', @@TRANCOUNT




--EXEMPLO 2

SELECT 'Antes de BEGIN TRAN', @@TRANCOUNT
	--VALOR IGUAL A 0
BEGIN TRANSACTION um
	select 'PRIMEIRA TRANSACTION', @@TRANCOUNT
	--VALOR IGUAL A 1
	BEGIN TRANSACTION ANINHADA
		select 'SEGUNDA TRANSACTION', @@TRANCOUNT
	ROLLBACK TRANSACTION 
SELECT 'DEPOIS DA TRAN', @@TRANCOUNT

if (@@TRANCOUNT = 0)BEGIN

	COMMIT TRANSACTION um
	SELECT 'DEPOIS DO COMMIT TRAB',@@TRANCOUNT
END




--EXEMPLO SAVE POINTS
select * from Projeto
select * from Fornecedor
begin tran main
	select 'Depois do BEGIN TRAN', @@TRANCOUNT
	update Fornecedor set FCateg = 'X' where FNro=41
	SAVE TRAN PONTO1
	select 'Depois do PONTO 1', @@TRANCOUNT
		BEGIN TRAN ANINHADA
			select 'Depois do BEGIN TRAN ANINHADA', @@TRANCOUNT
			update Projeto set PDuracao = '4' where PNro = 5
			SAVE TRAN PONTO2
			select 'Depois do PONTO2', @@TRANCOUNT
		ROLLBACK TRAN PONTO1
		select 'Depois do ROLLBACK PONTO1', @@TRANCOUNT
		
if (@@TRANCOUNT = 0 )begin
	ROLLBACK TRAN
	select 'Depois de CANCELAR TUDO', @@TRANCOUNT
	
end*/
--Exemplo 3
create procedure Adiciona_Peca_E_Fornecimento 
(	@PecaNum int, 
	@PecaNome varchar,
	@PecaPreco money,
	@PecaCor Varchar(15),
	@FornNum int,
	@ProjNum int,
	@QTD int	
)
as
begin TRAN
	INSERT INTO Peca 
	VALUES (@PecaNum,@PecaNome, @PecaPreco, @PecaCor)
	
	IF (@@ERROR <> 0)begin
		print 'UM ERRO INESPERADO OCORREU'
		ROLLBACK TRAN
		RETURN 1
	end	
	
	INSERT INTO Fornece_Para
	values (@PecaNum, @FornNum, @ProjNum, @QTD)
	
	IF (@@ERROR <>0)begin
		PRINT 'Um erro inesperado ocorreu'
		ROLLBACK TRAN
		RETURN 1
	end
COMMIT TRAN

return 0
--Exemplo 4
create procedure Adiciona_Peca_E_Fornecimento2 
(	@PecaNum int, 
	@PecaNome varchar,
	@PecaPreco money,
	@PecaCor Varchar(15),
	@FornNum int,
	@ProjNum int,
	@QTD int	
)
as
begin TRAN
	INSERT INTO Peca 
	VALUES (@PecaNum,@PecaNome, @PecaPreco, @PecaCor)
	
	IF (@@ERROR <> 0)GOTO ERR_HANDLER
	
	
	INSERT INTO Fornece_Para
	values (@PecaNum, @FornNum, @ProjNum, @QTD)
	
	IF (@@ERROR <>0) GOTO ERR_HANDLER
		
	
COMMIT TRAN

return 0
ERR_HANDLER:
	PRINT 'Um erro inesperado ocorreu'
	ROLLBACK TRAN
	RETURN 1




--Exemplo 5
DECLARE @intErrorCode int
BEGIN TRAN 
	UPDATE Fornecedor
	SET FCateg = 'A'
	WHERE FNro = 10
	
	SELECT @intErrorCode = @@ERROR
	IF (@intErrorCode <> 0) GOTO PROBLEM
	
	UPDATE Projeto
	set PDuracao = '7', PCusto = 60000
	WHERE PNro = 20
	
	SELECT @intErrorCode = @@ERROR
	IF (@intErrorCode <> 0) GOTO PROBLEM

COMMIT TRAN
PROBLEM:
	PRINT 'ERROUUUUU'
	ROLLBACK TRAN 
	PRINT @@ERROR
	
select * from Projeto
select * from Fornecedor

--LISTA TRANSACTIONS

--Exer1
--Faça duas transações não aninhadas para atualização 
--de custo em 10% na tabela projeto e inserção de um registro
-- na tabela de fornecedores.
DECLARE @auxErro int
BEGIN TRAN 
	UPDATE projeto
	set PCusto += ((PCusto/100)*10)
	SELECT @auxErro = @@ERROR
	if (@auxErro <> 0)begin
		print 'ERRROU'
		rollback tran
	end 
	print 'TRAN1 COMMIT'
COMMIT TRAN 

DECLARE @auxErro as int
BEGIN TRAN tran2
	insert into Fornecedor
	values (42,'QuarentaEDois','Avaré','X')
	SELECT @auxErro = @@ERROR
	if (@auxErro <> 0)begin
		print 'ERRROU'
		rollback tran
	end 
	print 'TRAN2 COMMIT'
COMMIT TRAN tran2

--Exer2
--Faça as mesmas só que aninhadas
Declare @auxErro int
BEGIN TRAN
	
	begin tran t1
		insert into Fornecedor
		values (42,'QuarentaEDois','Avaré','X')
		SELECT @auxErro = @@ERROR
		if (@auxErro <> 0)begin
			print 'ERRROU TRAN2'
			rollback tran 
		end 
		print 'TRAN2 COMMIT'
	commit tran t1
	
	UPDATE projeto
	set PCusto += ((PCusto/100)*10)
	SELECT @auxErro = @@ERROR
	if (@auxErro <> 0)begin
		print 'ERRROU TRAN1'
		rollback tran
	end
	print 'TRAN1 COMMIT'
COMMIT TRAN

delete from Fornecedor where FNro = 42
	
	


begin tran
	select PNome from projeto
	save tran p1
	begin tran t1
		select FNome from Fornecedor
		if (@@ERROR <> 0 )begin
			Rollback tran p1
		end
	commit tran t1
	select PeNome from Peca
	Rollback tran p1
	select @@TRANCOUNT

COMMIT tran
	
--CONTROLE DE CONCORRÊNCIAS
create database ControlConcoBD2;

create table tbl
(
	id int IDENTITY(1,1) PRIMARY KEY,
	val int NOT NULL
)
GO
INSERT INTO tbl values (1)
select * from tbl

