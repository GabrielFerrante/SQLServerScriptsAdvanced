--Teste1
/*SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
BEGIN TRAN
select val from tbl

COMMIT TRAN
--Teste2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRAN
select val from tbl

COMMIT TRAN
--Teste3
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRAN repeatRead

Select * from tbl
waitfor delay '00:00:10'
select * from tbl

COMMIT TRAN repeatRead

--Teste4
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRAN repeatRead

Select * from tbl
waitfor delay '00:00:10'
select * from tbl

COMMIT TRAN repeatRead

--Teste5
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRAN repeatRead

Select * from tbl
waitfor delay '00:00:10'
select * from tbl

COMMIT TRAN repeatRead
*/

--teste6
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
begin tran pessimisticTran
SELECT * from tbl

waitfor delay '00:00:10'

update tbl
set val = 3
where id = 1

COMMIT TRAN pessimisticTran
SELECT * from tbl


--LISTA ISOLAMENTOS
--EXER 1
--Fa�a duas transa��es separadas. A primeira com o n�vel de isolamento Serializable
-- e que fa�a uma leitura (SELECT) nos dados da tabela Fornecedores, d� uma parada de 5 segundos,
-- atualize o campo FNome para �Lava-Jato� dos Fornecedores de Categoria �A� ou �B� e fa�a outra 
--leitura nos dados da tabela Fornecedores. A segunda deve conter um SELECT lendo todos 
--os dados da tabela Pe�a, cujas cores s�o �Amarelo� e tenham pre�o superior a 10.

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN exer1
	SELECT * FROM Fornecedor
	waitfor delay '00:00:05'
	UPDATE Fornecedor
	set FNome = ('Lava Jato')
	where FCateg in ('A','B')
	SELECT * FROM Fornecedor

COMMIT TRAN exer1

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN exer1_2
	SELECT * FROM Fornecedor
	where FCateg in ('C') and FCidade Like 'Campinas'

COMMIT TRAN exer1_2
