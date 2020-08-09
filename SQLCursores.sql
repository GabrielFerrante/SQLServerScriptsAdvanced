--Exemplo 1
CREATE PROCEDURE atualiza_preco (@numForn as int)
as
begin
	--declarando cursor
	DECLARE CursorPreco
	CURSOR FOR
		select distinct PeNro 
		From fornece_para 
		WHERE FNro = @numForn
		
	--declarando variaveis auxiliares
	declare @numPecaAux as int
	
	--ABRIR CURSOR
	OPEN CursorPreco
	
	--atribuindo valores do select na varíável
	FETCH NEXT FROM CursorPreco
	INTO @numPecaAux
	
	--Iniciando o laco
	while @@FETCH_STATUS = 0 begin
		UPDATE Peca
		set PePreco = PePreco*1.1
		where PeNro = @numPecaAux
		--proxima Linha do cursor
		FETCH NEXT FROM CursorPreco
		into @numPecaAux
	
	end
	--fechando e desalocando cursor
	CLOSE CursorPreco
	DEALLOCATE CursorPreco
end

select * from Fornece_Para
select * from Peca
EXEC atualiza_preco 1


--LISTA 1 CURSORES

--Exercicio 1
--Faça uma Stored Procedure com um cursor que receba todos 
--os projetos que têm custo superior a R$ 20.000,00 no cursor e 
--selecione todos os nomes e categorias de fornecedores que
-- fornecem para estes projetos.

alter procedure exer1CURSOR
as
begin
	DECLARE cursoExer1
	CURSOR FOR
		select pj.PNro
		from Projeto pj
		where pj.PCusto > 20000;
	
	OPEN cursoExer1
	
	declare @aux as int
	
	FETCH NEXT FROM cursoExer1
	INTO @aux
	while @@FETCH_STATUS = 0 begin
		select f.FNome, f.FCateg
		from fornecedor f, Fornece_Para fp, Projeto pj
		where fp.FNro = f.FNro and
			  fp.PNro = pj.PNro and
			  @aux = pj.PNro
		
		
		FETCH NEXT FROM cursoExer1
		INTO @aux
		
	end;
	CLOSE cursoExer1
	DEALLOCATE cursoExer1
end
select * from Fornece_Para
select * from Fornecedor
select * from Projeto
EXEC exer1CURSOR

--Exercício 2
--Faça uma Stored Procedure com um cursor que receba o código do fornecedor, 
--selecionando todos os projetos nos quais este fornecedor possui fornecimento 
--e aumente em 15% o custo de tais projetos.

create procedure exer2CURSOR (@numForc as int)
as
begin
	DECLARE cursoExer2
	CURSOR FOR 
		select pj.PNro
		from fornecedor f, fornece_para fp, projeto pj
		where fp.FNro = @numForc and
			  fp.PNro = pj.PNro
	
	OPEN cursoExer2
	
	declare @aux as int
	
	FETCH NEXT FROM cursoExer2
	INTO @aux
	
	while @@FETCH_STATUS = 0 begin
		
		update Projeto 
		set PCusto = ((PCusto / 100)*15) + PCusto
		where PNro = @aux
		
		FETCH NEXT FROM cursoExer2
		INTO @aux
	end
	CLOSE cursoExer2
	DEALLOCATE cursoExer2
end

select * from Fornece_Para
select * from Fornecedor
select * from Projeto
EXEC exer2CURSOR 1

--Exercício 3
--Crie um Trigger com cursor que ao invés de excluir os fornecedores 
--que não são das categorias ‘A’, ‘B’ e ‘C’, atualize suas categorias para ‘C’. 

create trigger exer3CURSOR on fornecedor
instead of delete
as
begin
	--declarando o cursor
	declare cursorExer3
	--para
	CURSOR FOR
		select FNro
		from deleted
		where FCateg not in ('A','B','C');

	--Ativando o cursor
	OPEN cursorExer3

	--variavel auxiliar para o loop
	declare @aux as int

	--Iniciando a variavel na primeira posição do cursor
	FETCH NEXT FROM cursorExer3
	INTO @aux

	while @@FETCH_STATUS = 0 begin
		
		update fornecedor
		set FCateg = 'C'
		where FNro = @aux

		FETCH NEXT FROM cursorExer3
		INTO @aux
	end
	CLOSE cursorExer3
	deallocate cursorExer3 


end

select * from Fornecedor
insert into Fornecedor values (7,'Rumbar','Jaú','')
delete from fornecedor where FNro = 7

--Exercício 4
--Faça uma Stored Procedure que armazene em um cursor todos os códigos de fornecedores 
--que são da categoria A ou B. Atualize todos os custos dos projetos que tem 
--fornecimentos de tais fornecedores em 10%.

alter procedure exer4CURSOR
as
begin
	declare cursorExer4
	

	CURSOR FOR 
		select FNro
		from fornecedor
		where FCateg in ('A','B')

	OPEN cursorExer4
	
	declare @aux as int

	FETCH NEXT FROM cursorExer4
	INTO @aux

	

	while @@FETCH_STATUS = 0 begin
		update Projeto
		set PCusto = PCusto + ((PCusto/100)*10)
		where PNro in (select pj.PNro
					  from Fornece_Para fp, Fornecedor f, Projeto pj
					  where fp.FNro = @aux and
							 fp.PNro = pj.PNro)
			  

		FETCH NEXT FROM cursorExer4
		INTO @aux
	end
	CLOSE cursorExer4
	deallocate cursorExer4
	

end

select * from Fornece_Para
select * from Fornecedor
select * from Projeto
insert into Fornecedor values(6,'Forn','ctd','E')
insert into projeto values (6,'Teste','2',100)
insert into Fornece_Para values (5,6,6,2)

EXEC exer4CURSOR

--Exercício 5
--Crie um cursor para a tabela “Fornecedor”. 
--Leia desse cursor o nome do fornecedor, bem como a categoria 
--do mesmo. Para os fornecedores das Categorias “A” e “B”, imprima 
--os nomes do fornecedor juntamente com o texto “Excelentes 
--Fornecedores”. Caso contrário, imprima os nomes do fornecedor 
--juntamente com o texto “Fornecedores Meia Boca”.
	
	declare cursorExer5
	
	CURSOR FOR 
		select FNome, FCateg
		from fornecedor
		

	OPEN cursorExer5
	
	declare @Nome as varchar(20)
	declare @Categora as varchar(20)

	FETCH NEXT FROM cursorExer5
	INTO @Nome, @Categora

	while @@FETCH_STATUS = 0 begin
		
		if (@Categora = 'A' or @Categora = 'B') begin
			print {fn CONCAT(@Nome,' Execelentes Fornecedores')}
		
		end
		else begin
			print {fn CONCAT(@Nome,' Fornecedores meia boca')}
		end
		
		FETCH NEXT FROM cursorExer5
		INTO @Nome, @Categora
	end
	CLOSE cursorExer5
	deallocate cursorExer5
	
	select * from Fornecedor
	
	--PRINT {fn CONCAT('Durcao: ', CAST(@Duracao AS VARCHAR))}
	 
	--Exercício 6
	--Utilizando cursores, realize uma consulta que 
	--retorne todos os Projetos e seus respectivos custos 
	--e durações.
	
	declare cursorExer6
	CURSOR FOR
		select PNome, PCusto, PDuracao
		from Projeto
	
	OPEN cursorExer6
	
	declare @nome as varchar(20)
	declare @custo as money
	declare @duracao as varchar(20)
	
	FETCH NEXT FROM cursorExer6
	INTO @nome, @custo, @duracao
	
	WHILE @@FETCH_STATUS = 0 begin
		print {fn CONCAT('Nome: ', @nome )}
		print {fn CONCAT('Custo: ', cast(@custo as varchar (20)))}
		print {fn CONCAT('Duração: ', @duracao)}
		FETCH NEXT FROM cursorExer6
		INTO @nome, @custo, @duracao
	end
	CLOSE cursorExer6
	deallocate cursorExer6
	
	select * from Projeto
	
	--Exercício 7
	--7 - Utilizando cursores, realize uma consulta que retorne o nome de todas
	--as peças que são fornecidas para um fornecedor, sendo que o fornecedor 
	--é selecionado através da passagem de um parâmetro. 
alter procedure Exer7Cursor (@NumForm as int)
	as
	begin
		declare cursorExer7
		CURSOR for
			select PeNome
 			from Fornece_Para fp, Fornecedor f, Peca p
			where fp.FNro = @NumForm and
				  f.FNro = @NumForm and
				  fp.PeNro = p.PeNro
		
		declare @nome varchar(20)
		OPEN cursorExer7

		fetch next from cursorExer7
		into @nome

		while @@FETCH_STATUS = 0 begin
			print @nome

			fetch next from cursorExer7
			into @nome
		end
		CLOSE cursorExer7
		DEALLOCATE cursorExer7

	end
	select * from Fornece_Para
	select * from peca
	EXEC Exer7Cursor 1