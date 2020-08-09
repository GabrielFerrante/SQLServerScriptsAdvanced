-- Comando insert (DML): inclui dados nas tabelas


Use Fabrica
insert into Projeto (Pnro, PNome, PDuracao,PCusto) 
	values (1, 'Detroit', '5', 43000)
insert into Projeto values (2, 'Pegasus', '3', 37000)
insert into Projeto values (3, 'Alfa', '2', 26700)
insert into Projeto values (4, 'Sea', '3', 21200)
insert into Projeto values (5, 'Paraíso', '1', 17000)
select * from Projeto;

UPDATE Projeto set PCusto = 26700 where PNro = 3; 

Use Fabrica
insert into Fornecedor values(1, 'Plastec', 'Campinas', 'B')
insert into Fornecedor values(2, 'C&M', 'São Paulo', 'D')
insert into Fornecedor values(3, 'Kirurgic', 'Campinas','A')
insert into Fornecedor values(4, 'Piloto’s', 'Piracicaba', 'A')
insert into Fornecedor values(5, 'Equipament', 'São Carlos', 'C')
Select * from Fornecedor;

Use Fabrica
insert into Peca values(1, 'Cinto', 22, 'Azul')
insert into Peca values(2, 'Volante', 18, 'Vermelho')
insert into Peca values(3, 'Lanterna', 14, 'Preto')
insert into Peca values(4, 'Limpador', 09, 'Amarelo')
insert into Peca values(5, 'Painel', 43, 'Vermelho')
insert into Peca values(6, 'Parabrisa', 56,null)
Select * from peca


Use Fabrica
insert into Fornece_Para values(1,5,4,5)
insert into Fornece_Para values(2,2,2,1)
insert into Fornece_Para values(3,3,4,2)
insert into Fornece_Para values(4,4,5,3)
insert into Fornece_Para values(5,1,1,1)
insert into Fornece_Para values(2,2,3,1)
insert into Fornece_Para values(4,3,5,2)
select * from Fornece_Para;

/*CHAMANDO A VIEW*/
select * from PecasNome;
select * from VisaoFornecedor;
select * from VisaoQuantPecas;
select * from VisFornecPecas;
select * from VisaoFornecedoresPecas;
select * from VisaoMediaQuantPecas;

select * from Exer1;
select * from Exer2;
select * from Exer3;
select * from Exer4;
select * from Exer5;
select * from Exer6;
select * from Exer7;
select * from Exer8;
select * from Exer9;
select * from Exer10;
select * from Exer11;


/*VISUALIZAÇÃO DE UM JOIN*/
select *
from Fornecedor f inner join Fornece_Para fp on fp.FNro = fp.FNro
	 inner join Peca p on fp.PeNro = p.PeNro;






-- Atualiza todos os preços da tabela Peça2 em 10%
UPDATE	Peca2
SET	PePreco = PePreco + PePreco * 0.1



-- Remove a peça PE6
DELETE FROM	 Peca2
WHERE PeNro = 6
Select * from peca2

--Exclua da tabela Fornecedores2 o fornecedor de número 4
