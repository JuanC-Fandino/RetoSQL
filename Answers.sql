--2615
select distinct city
from customers;

--2622
select name
from customers
         join legal_person lp on customers.id = lp.id_customers;

--2611
select movies.id, name
from movies
         join genres g on g.id = movies.id_genres
where description = 'Action';

--2623
select products.name, categories.name
from products
         join categories on categories.id = products.id_categories
where amount > 100
  and (categories.id = 1
    or categories.id = 2
    or categories.id = 3
    or categories.id = 6
    or categories.id = 9
    )
order by categories.id asc

--2988
select name,
       count(*) as matches, count(v) as victories, count(de) as defeats, count(dr) as draws, sum(s) as score
from ((select team_1                                                   as team,
              CASE WHEN team_1_goals > matches.team_2_goals THEN 1 END as v,
              CASE WHEN team_1_goals < matches.team_2_goals THEN 1 END as de,
              CASE WHEN team_1_goals = matches.team_2_goals THEN 1 END as dr,
              CASE
                  WHEN team_1_goals > matches.team_2_goals THEN 3
                  WHEN team_1_goals = matches.team_2_goals THEN 1
                  WHEN team_1_goals < matches.team_2_goals THEN 0
                  END                                                  as s
       from matches)
      union all
      (select team_2 as team,
              CASE WHEN team_2_goals > matches.team_1_goals THEN 1 END,
              CASE WHEN team_2_goals < matches.team_1_goals THEN 1 END,
              CASE WHEN team_2_goals = matches.team_1_goals THEN 1 END,
              CASE
                  WHEN team_2_goals > matches.team_1_goals THEN 3
                  WHEN team_2_goals = matches.team_1_goals THEN 1
                  WHEN team_2_goals < matches.team_1_goals THEN 0
                  END
       from matches)
     ) allTeams
         join teams on allTeams.team = teams.id
group by name
order by score desc;

--2602
select name
from customers
where state = 'RS'

--2616
select customers.id, name
from customers
         left join locations l on customers.id = l.id_customers
where id_customers is null

--2742
select lr.name, trunc(omega * 1.618::numeric, 3) as "The N Factor"
from dimensions
         join life_registry lr on dimensions.id = lr.dimensions_id
where lr.name like 'Richard%' and (dimensions.name = 'C875' or dimensions.name = 'C774')
order by omega asc

--3001
select name, (CASE type
            WHEN 'A' THEN 20.0
            WHEN 'B' THEN  70.0
            WHEN 'C' THEN 530.5
           END) as Price from products order by type asc, id desc

--2991
select nDepartamento, count(*), round(avg(salarioTotal), 2), max(salarioTotal), min(salarioTotal)
from (select nEmpleado, sum(salarioNeto - descuentos) as salarioTotal, nDepartamento
      from ((select empregado.nome as nEmpleado,d2.nome as nDepartamento,sum(coalesce(v.valor, 0)) as salarioNeto,0 as descuentos
             from empregado
                      inner join divisao d on empregado.lotacao_div = d.cod_divisao
                      inner join departamento d2 on d.cod_dep = d2.cod_dep
                      left JOIN emp_venc ev on empregado.matr = ev.matr
                      left JOIN vencimento v on ev.cod_venc = v.cod_venc
             group by empregado.nome, d2.nome)
            union all
            (select empregado.nome as nEmpleado, d2.nome as nDepartamento, 0, sum(coalesce(d3.valor, 0))
             from empregado
                      inner join divisao d on empregado.lotacao_div = d.cod_divisao
                      inner join departamento d2 on d.cod_dep = d2.cod_dep
                      left join emp_desc ed on empregado.matr = ed.matr
                      left join desconto d3 on ed.cod_desc = d3.cod_desc
             group by empregado.nome, d2.nome)) as fusion1
      group by nEmpleado, nDepartamento) as fusion2 group by nDepartamento order by avg(salarioTotal) desc;