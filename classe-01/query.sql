CREATE TABLE categorias (
    id serial UNIQUE,
    nome varchar(50)
);

CREATE TABLE clientes (
    cpf char(11) UNIQUE,
    nome varchar(150)
);

CREATE TABLE vendedores (
    cpf char(11) UNIQUE,
    nome varchar(150)
);

CREATE TABLE produtos (
    id serial UNIQUE,
    nome varchar(100),
    descricao text,
    preco int,
    quantidade_em_estoque int,
    categoria_id int references categorias(id)
);

CREATE TABLE pedidos (
    id serial UNIQUE,
    valor int,
    cliente_cpf char(11) references clientes(cpf),
    vendedor_cpf char(11) references vendedores(cpf)
);

CREATE TABLE itens_do_pedido (
    id serial UNIQUE,
    pedido_id int references pedidos(id),
    quantidade int,
    produto_id int references produtos(id)
);



-- (01) Alimentando as tabelas

    INSERT INTO categorias (nome) VALUES
    ('frutas'),
    ('verduras'),
    ('massas'),
    ('bebidas'),
    ('utilidades');


-- (02) Alimentando a tabela produtos;

    INSERT INTO produtos (nome, descricao, preco, quantidade_em_estoque, categoria_id) VALUES
    ('Mamão', 'Rico em vitamina A, potássio e vitamina C', 300, 123, 1),
    ('Maça','Fonte de potássio e fibras.', 90, 34, 1),
    ('Cebola', 'Rico em quercetina, antocianinas, vitaminas do complexo B, C.', 50, 76, 2),
    ('Abacate', 'NÃO CONTÉM GLÚTEN.', 150, 64, 1),
    ('Tomate', 'Rico em vitaminas A, B e C.', 125, 88, 2),
    ('Acelga', 'NÃO CONTÉM GLÚTEN.', 235, 13, 2),
    ('Macarrão parafuso', 'Sêmola de trigo enriquecida com ferro e ácido fólico, ovos e corantes naturais', 690, 5, 3),
    ('Massa para lasanha', 'Uma reunião de família precisa ter comida boa e muita alegria.', 875, 19, 3),
    ('Refrigerante coca cola lata', 'Sabor original', 350, 189, 4),
    ('Refrigerante Pepsi 2l', 'NÃO CONTÉM GLÚTEN. NÃO ALCOÓLICO.', 700, 12, 4),
    ('Cerveja Heineken 600ml', 'Heineken é uma cerveja lager Puro Malte, refrescante e de cor amarelo-dourado', 1200, 500, 4),
    ('Agua mineral sem gás', 'Smartwater é água adicionado de sais mineirais (cálcio, potássio e magnésio) livre de sódio e com pH neutro.', 130, 478, 4),
    ('Vassoura', 'Pigmento, matéria sintética e metal.', 2350, 30, 5),
    ('Saco para lixo', 'Reforçado para garantir mais segurança', 1340, 90, 5),
    ('Escova dental', 'Faça uma limpeza profunda com a tecnologia inovadora', 1000, 44, 5),
    ('Balde para lixo 50l', 'Possui tampa e fabricado com material reciclado', 2290, 55, 5),
    ('Manga', 'Rico em Vitamina A, potássio e vitamina C', 198, 176, 1),
    ('Uva', 'NÃO CONTÉM GLÚTEN.', 420, 90, 1);

-- (03)Alimentando a tabela

    INSERT INTO clientes (cpf, nome) VALUES
    (80371350042, 'José Augusto Silva'),
    (67642869061, 'Antonio Oliveira'),
    (63193310034, 'Ana Rodrigues'),
    (75670505018, 'Maria da Conceição');


-- (04) Alimentando a tabela vendedores

    INSERT INTO vendedores (cpf, nome) VALUES
    (82539841031, 'Rodrigo Sampaio'),
    (23262546003, 'Beatriz Souza Santos'),
    (28007155023, 'Carlos Eduardo');


-- (05) Fazendo pedidos

-- a) José Algusto comprou os seguintes itens com o vendedor Carlos Eduardo:

-- 1 Mamão, 1 Pepsi de 2l, 6 Heinekens de 600ml, 1 Escova dental e 5 Maçãs.

	INSERT INTO pedidos (valor, cliente_cpf, vendedor_cpf) VALUES
    (0, 80371350042, 28007155023);

    INSERT INTO itens_do_pedido (pedido_id, quantidade, produto_id) VALUES
    (1, 1, 1),
    (1, 1, 10),
    (1, 6, 11),
    (1, 1, 15),
    (1, 5, 2);

    UPDATE pedidos SET valor = (
    select sum(preco * quantidade) from itens_do_pedido
    join pedidos on itens_do_pedido.pedido_id = pedidos.id
    join produtos on itens_do_pedido.produto_id = produtos.id
    ) WHERE id = 1;

    UPDATE produtos 
    SET quantidade_em_estoque = (quantidade_em_estoque - itens_do_pedido.quantidade)
    FROM itens_do_pedido
    WHERE itens_do_pedido.produto_id = produtos.id
    AND itens_do_pedido.pedido_id = 1;


-- b) Ana Rodrigues comprou os seguintes itens com a vendedora Beatriz Souza Santos

-- 10 Mangas, 3 Uvas, 5 Mamões, 10 tomates e 2 Acelgas.

	INSERT INTO pedidos (valor, cliente_cpf, vendedor_cpf) VALUES
    (0, 63193310034, 23262546003);

    INSERT INTO itens_do_pedido (pedido_id, quantidade, produto_id) VALUES
    (2, 10, 17),
    (2, 3, 18),
    (2, 5, 1),
    (2, 10, 5),
    (2, 2, 6);

    UPDATE pedidos SET valor = (
    select sum(preco * quantidade) from itens_do_pedido
    join pedidos on itens_do_pedido.pedido_id = pedidos.id
    join produtos on itens_do_pedido.produto_id = produtos.id
    ) WHERE id = 2;

    UPDATE produtos 
    SET quantidade_em_estoque = (quantidade_em_estoque - itens_do_pedido.quantidade)
    FROM itens_do_pedido
    WHERE itens_do_pedido.produto_id = produtos.id
    AND itens_do_pedido.pedido_id = 2;

-- c) Maria da Conceição comprou os seguintes itens com a vendedora Beatriz Souza Santos

-- 1 Vassoura, 6 Águas sem gás e 5 Mangas.

	INSERT INTO pedidos (valor, cliente_cpf, vendedor_cpf) VALUES
    (0, 75670505018, 23262546003);

    INSERT INTO itens_do_pedido (pedido_id, quantidade, produto_id) VALUES
    (3, 1, 13),
    (3, 6, 12),
    (3, 5, 17);

    UPDATE pedidos SET valor = (
    select sum(preco * quantidade) from itens_do_pedido
    join pedidos on itens_do_pedido.pedido_id = pedidos.id
    join produtos on itens_do_pedido.produto_id = produtos.id
    ) WHERE id = 3;

    UPDATE produtos 
    SET quantidade_em_estoque = (quantidade_em_estoque - itens_do_pedido.quantidade)
    FROM itens_do_pedido
    WHERE itens_do_pedido.produto_id = produtos.id
    AND itens_do_pedido.pedido_id = 3;

-- d) Maria da Conceição comprou os seguintes itens com o vendedor Rodrigo Sampaio

-- 1 Balde para lixo, 6 Uvas, 1 Macarrão parafuso, 3 Mamões, 20 tomates e 2 Acelgas.

	INSERT INTO pedidos (valor, cliente_cpf, vendedor_cpf) VALUES
    (0, 75670505018, 82539841031);

    INSERT INTO itens_do_pedido (pedido_id, quantidade, produto_id) VALUES
    (4, 1, 16),
    (4, 6, 18),
    (4, 1, 7),
    (4, 3, 1),
    (4, 20, 5),
    (4, 2, 6);

    UPDATE pedidos SET valor = (
    select sum(preco * quantidade) from itens_do_pedido
    join pedidos on itens_do_pedido.pedido_id = pedidos.id
    join produtos on itens_do_pedido.produto_id = produtos.id
    ) WHERE id = 4;

    UPDATE produtos 
    SET quantidade_em_estoque = (quantidade_em_estoque - itens_do_pedido.quantidade)
    FROM itens_do_pedido
    WHERE itens_do_pedido.produto_id = produtos.id
    AND itens_do_pedido.pedido_id = 4;


-- e) Antonio Oliveira comprou os seguintes itens com o vendedor Rodrigo Sampaio

-- 8 Uvas, 1 Massa para lasanha, 3 Mangas, 8 tomates e 2 Heinekens 600ml.

	INSERT INTO pedidos (valor, cliente_cpf, vendedor_cpf) VALUES
    (0, 67642869061, 82539841031);

    INSERT INTO itens_do_pedido (pedido_id, quantidade, produto_id) VALUES
    (5, 8, 18),
    (5, 1, 8),
    (5, 3, 17),
    (5, 8, 5),
    (5, 2, 11);

    UPDATE pedidos SET valor = (
    select sum(preco * quantidade) from itens_do_pedido
    join pedidos on itens_do_pedido.pedido_id = pedidos.id
    join produtos on itens_do_pedido.produto_id = produtos.id
    ) WHERE id = 5;

    UPDATE produtos 
    SET quantidade_em_estoque = (quantidade_em_estoque - itens_do_pedido.quantidade)
    FROM itens_do_pedido
    WHERE itens_do_pedido.produto_id = produtos.id
    AND itens_do_pedido.pedido_id = 5;


-- (06) Novas queries de consulta

-- a) Faça uma listagem de todos os produtos cadastrados com o nome da sua respectiva categoria.
    SELECT * FROM produtos 
    LEFT JOIN categorias ON produtos.categoria_id = categorias.id
    ORDER BY produtos.id;

-- b) Faça uma listagem de todos os pedidos com o nome do vendedor e o nome do cliente relacionado a venda.
    SELECT id, valor, cliente_cpf, clientes.nome AS nome_cliente, vendedor_cpf, vendedores.nome AS nome_vendedor FROM pedidos 
    LEFT JOIN clientes ON pedidos.cliente_cpf = clientes.cpf 
    LEFT JOIN vendedores ON pedidos.vendedor_cpf = vendedores.cpf;

-- c) Faça uma listagem de todas as categorias e a soma do estoque disponível de todos os produtos de cada categoria.
    SELECT categorias.nome as categoria,SUM(produtos.quantidade_em_estoque) as estoque_disponivel
    FROM produtos
    JOIN categorias ON categorias.id = produtos.categoria_id
    GROUP BY categorias.nome
    ORDER BY estoque_reservado DESC;

-- d) Faça uma listagem de todos os produtos e a quantidade vendida de cada produto.
    SELECT produtos.nome as produto, sum(itens_do_pedido.quantidade) as quantidade_vendida
    FROM produtos
    JOIN itens_do_pedido ON itens_do_pedido.produto_id = produtos.id
    GROUP BY produtos.nome
    ORDER BY quantidade_vendida DESC;