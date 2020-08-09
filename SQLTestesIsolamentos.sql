--Teste 1
BEGIN TRAN longUpdate
update tbl
set val = -1

WAITFOR DELAY '00:00:10'

ROLLBACK TRAN longUpdate


--Teste 2
BEGIN TRAN shortUpdate

UPDATE tbl
set val = -1

COMMIT TRAN shortUpdate



--TESTE 3
BEGIN TRAN shortUpdate

UPDATE tbl
set val = 1

COMMIT TRAN shortUpdate

--TESTE 4
BEGIN TRAN shortInsert

insert into tbl
values (2)

COMMIT TRAN shortInsert

--TESTE 5
BEGIN TRAN shortUpdate

UPDATE tbl
set val = 4
where id = 1

COMMIT TRAN shortUpdate


BEGIN TRAN exer1_2
	SELECT * FROM Fornecedor
	where FCateg in ('C') and FCidade Like 'Campinas'

COMMIT TRAN exer1_2