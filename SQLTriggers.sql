-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
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
CREATE TRIGGER .Teste1 
   ON  .Peca 
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
    print 'Nova peça incluída'

END
GO
--TESTANDO TRIGGERS
--EXEMPLOS TRIGGERS
insert Peca values(15,'Porta',30,'verde')

Select * from Peca

create trigger DelPeca on Peca 
for delete
as
begin
	print 'Um registro foi excluído'
end

Delete from Peca where PeNro = 15
select * from Peca

alter trigger UpdPeca on Peca
for Update
as
begin
	print'Uma peça foi atualizada'
	select * from inserted
	print 'Acabou a execução do Trigger'
end

update Peca
set PePreco = PePreco + ((PePreco / 100 )*20)
where PeNro = 12

select * from Peca
select * from inserted

--Criando replicações de Linhas com TRIGGERS

Create trigger InsReplic on Peca
for insert 
as
begin
	insert into Peca2
	select * from Inserted

end
insert into Peca values (7,'Jurema',100,'Amarelo')
select * from Peca2

Create trigger DelReplic on Peca
for delete
as 
begin
	delete from Peca2
	where Peca2.PeNro in 
						(Select PeNro
						   From Deleted )
end

delete from Peca
where PeNro = 7

select * from Peca2
--Exemplo 1
Create trigger UpdReplic on Peca
for update
as
begin
	update Peca2
	set PePreco = (Select PePreco from Inserted)
	where Peca2.PeNro in (Select PeNro from inserted)
end

Select * from Peca
Select * from Peca2

insert Peca values (40,'RRR',30,'Verde')
insert Peca values (41,'SSS',40,'Amarelo')
insert Peca values (42,'TTT',50,'Vermelho')
insert Peca values (43,'UUU',60,'Azul')
Select * from Peca
Select * from Peca2

Update peca
set PePreco = 555
where PeNro = 40

Select * from Peca
Select * from Peca2

--Exibe todos os triggers
select * from sys.triggers
--Exemplo 2
--apos incluir um fornecedor, o atributo cidade que era null é modificado para Catanduva
alter trigger setCidade on fornecedor
after insert
as
begin
	update fornecedor set FCidade = 'Catanduva'
	where FNro = (select Fnro from inserted)
		  and FCidade = ''
end

insert into fornecedor values (38,'Roncal3','','A')
select * from fornecedor
--Exemplo 3
--Ao se inserir um fornecimento, verificar se a quantidade
--está acima do permitido (10)
create trigger inserirFornecimento on Fornece_Para
instead of insert
as
begin
	declare @FNro int
	declare @PeNro int
	declare @PNro int
	declare @qtd int
	set @FNro = (select FNro from inserted)
	set @PeNro = (select PeNro from inserted)
	set @PNro = (select PNro from inserted)
	set @qtd = (select	Quant from inserted)
	if (@qtd > 10)begin
		insert into Fornece_Para values (@PeNro, @FNro, @PNro, 10)
	
	end
	else begin
		insert into Fornece_Para values (@PeNro, @FNro, @PNro, @qtd)
	end
end

select * from Fornece_Para
insert into Fornece_Para values(1,4,3,5)

--Exemplo 4
--Ao inves de excluir fisicamente o registro
--o atributo FCidade será modificado para Monte Azul
create trigger set_Cidade2 on fornecedor
instead of delete

--Exemplo 6
create trigger set_insert on fornecedor
instead of insert
as
begin
	insert into fornecedor 
	select FNro, FNome, FCidade, null from inserted

end
select * from Fornecedor
insert into Fornecedor values (42,'Paraisopolis','Nozes','A')

--Exemplo 7
create table historico_precos(

	PeNro int,
	Peca_preco_antigo money,
	Peca_preco_novo money,
	Peca_data_atualizacao datetime,
	usuario_bd varchar(30),
	usuario_sistema varchar(30)
)
create trigger atualizarHistorico on Peca
after update
as if update(PePreco)
begin
	declare @PeNro int
	declare @preco_antigo money
	declare @preco_novo money
	select @PeNro = (select PeNro from deleted)
	select @preco_antigo = (select PePreco from deleted)
	select @preco_novo = (select PePreco from inserted)
	insert into historico_precos 
	values (@PeNro,@preco_antigo, @preco_novo,getdate(),user_name(),system_user)
end
select * from historico_precos
select * from Peca
update Peca set PePreco = 10 where PeNro = 7

--Exemplo 8
create trigger mostrarHistorico on Peca
after update as if update(PePreco)
begin
	select count(*)qtd from historico_precos

end
select * from historico_precos
select * from Peca
update Peca set PePreco = 10 where PeNro = 7


--Exemplo 9
create table fornecedor_atualizado(

	FNro int NOT NULL primary key ,
FNome varchar(30) not null, 
FCidade varchar(25) not null,
FCateg varchar(1) not null 

)
create table fornecedor_antigo(

FNro int NOT NULL primary key ,
FNome varchar(30) not null, 
FCidade varchar(25) not null,
FCateg varchar(1) not null 


)
create trigger fornecedorAtualizar on fornecedor
after update
as
begin
	insert into fornecedor_antigo select * from deleted
	insert into fornecedor_atualizado select * from inserted

end
select * from fornecedor
select * from fornecedor_atualizado
select * from fornecedor_antigo
update fornecedor set FCateg='E' where FNro = 40;
--LISTA TRIGGER

--Exercicio 1
--Após incluir uma peça com atributo cor 'Amarelo',
-- modifique tal cor para 'Azul'.
create trigger exer1TG on Peca
after insert
as
begin
	update Peca
	set PeCor = ('Azul')
	where PeCor = (Select PeCor from inserted
			 where PeCor = 'Amarelo' )
		  and PeNro = (Select PeNro from inserted)	
	print 'EXECUTOU EXER 1 LISTA'
end

create trigger exer1TG on Peca
after insert
as
begin
	update Peca
	set PeCor = 'Azul'
	where PeNro = (Select PeNro from inserted
			 where PeCor = 'Amarelo' )
		  	
	print 'EXECUTOU EXER 1 LISTA'
end

insert into Peca Values(9,'MLK2',723,'Vermelho')
delete from Peca where PeNro = 45;
Select * from Peca

--Exercício 2
--Ao invés de deletar uma peça, crie um trigger para modificar o 
--atributo PePreco para 50.
create trigger exer2TG on Peca
INSTEAD OF delete
as
begin
	update Peca
	set PePreco = (50)
	where PeNro = (select PeNro
					from Deleted )
		  
	print 'EXECUTOU EXER 2 LISTA'
end

insert into Peca Values(45,'MLK1',723,'Amarelo')
delete from Peca where PeNro = 45;
Select * from Peca

--Exercício 3
--Crie um trigger para, ao invés de atualizar o nome de uma peça com
-- um valor qualquer, atualize o campo Pecor para 'Amarelo'.
create trigger exer3TG on Peca
INSTEAD OF update
as
begin
	update Peca
	set PeCor = ('Amarelo')
	where PeNro = (select PeNro
					from inserted
					)	
	print 'EXECUTOU EXER 3 LISTA'

end
insert into Peca Values(46,'MLK2',723,'Vermelho')
update Peca set PeNome = ('Melequin') where PeNro = 46;
Select * from Peca

--Exercício 4
-- Faça um trigger para uma inserção na tabela peça que ao 
--invés de inserir um valor para Pecor, troque-o para 'Roxo'.
create trigger exer4TG on Peca
for insert
as
begin
	update Peca
	set PeCor = ('Roxo')
	where PeNro = (select PeNro
					from inserted
					)	
	print 'EXECUTOU EXER 4 LISTA'

end

insert into Peca Values(47,'MLK3',58246,'Vermelho')
Select * from Peca

--Exercício 5
--Faça um trigger com variáveis para, ao invés de inserir uma peça
-- com os valores que o usuário informou, não deixe o preço da peça
-- ser inferior a 5.

create trigger exer5TG on Peca
instead of insert
as
begin
	declare @Numero int
	declare @Nome varchar(15)
	declare @Preco float
	declare @Cor varchar(15)
	set @Numero = (select PeNro from inserted)
	set @Nome = (select PeNome from inserted)
	set @Preco = (select PePreco from inserted)
	set @Cor = (select PeCor from inserted)
	if (@Preco < 5)begin
		insert into Peca values (@Numero,@Nome,5,@Cor);
	end
	else begin
		insert into Peca values (@Numero,@Nome,@Preco,@Cor);
	end
	print 'EXECUTOU EXER 5'


end

select * from Peca
insert into Peca Values(50,'chora',2,'Laranja')

-- Crie um Trigger que ao invés de excluir os fornecedores que não
-- são das categorias ‘A’, ‘B’ e ‘C’, atualize suas categorias para 
--‘C’.

alter trigger exer6TG on Fornecedor
instead of delete
as
begin
	update Fornecedor
	set FCateg = ('C')
	where FNro =(select FNro from deleted)
				and FCateg not in ('A','B','C')
		  
		  print 'EXECUTOU EXER 6 LISTA'
end

select * from Fornecedor
delete from Fornecedor where FNro = 2;