-- 1. Qual foi o faturamento total do hospital no período?
-- OBJETIVO: Entender a saúde financeira geral do hospital.

SELECT 
	SUM(CASE WHEN status_pagamento = 'Pago' THEN valor_pago ELSE 0 END) AS faturamento_recebido,
    DATE_FORMAT(data_consulta, '%Y - %m') AS ano_mes
FROM pagamentos p
JOIN consultas c ON p.id_consulta = c.id_consulta
GROUP BY ano_mes;

-- 2. Quais são os 5 médicos que mais geraram faturamento?
-- OBJETIVO: Identificar os médicos que mais contribuem financeiramente.

SELECT 
	m.nome_medico,
    e.nome_especialidade,
    SUM(CASE WHEN p.status_pagamento = 'Pago' THEN p.valor_pago ELSE 0 END) AS faturamento_recebido,
    ROUND(AVG(CASE WHEN c.status_consulta = 'Realizada' THEN c.valor_consulta ELSE NULL END ), 2) AS ticket_medio,
    COUNT(CASE WHEN c.status_consulta = 'Realizada' THEN 1 END) AS consultas_realizadas
FROM consultas c
JOIN medicos m ON c.id_medico = m.id_medico
JOIN especialidades e ON m.id_especialidade = e.id_especialidade
LEFT JOIN pagamentos p ON c.id_consulta = p.id_consulta
GROUP BY m.id_medico, m.nome_medico, e.nome_especialidade
ORDER BY faturamento_recebido DESC
LIMIT 5;

-- 3. Quais especialidades geram mais faturamento e mais consultas?
-- OBJETIVO: Descobrir quais áreas são mais rentáveis e demandadas.

SELECT 
	e.nome_especialidade,
    SUM(CASE WHEN c.status_consulta = 'Realizada' THEN c.valor_consulta ELSE 0 END) AS faturamento_realizado,
    COUNT(CASE WHEN c.status_consulta = 'Realizada' THEN 1 END) AS consultas_realizadas,
    ROUND(AVG(CASE WHEN c.status_consulta = 'Realizada' THEN c.valor_consulta ELSE NULL END),2) ticket_medio
FROM medicos m
JOIN especialidades e ON e.id_especialidade = m.id_especialidade
JOIN consultas c ON c.id_medico = m.id_medico
GROUP BY e.nome_especialidade, e.id_especialidade
ORDER BY faturamento_realizado DESC;

-- 4. Qual a taxa de cancelamento e não comparecimento de consultas?
-- OBJETIVO: Avaliar a eficiência operacional e satisfação dos pacientes.
SELECT
    ROUND(100.0 * COUNT(CASE WHEN status_consulta = 'Realizada' THEN 1 END) / COUNT(*), 2) AS porc_realizadas,
    COUNT(CASE WHEN status_consulta = 'Realizada' THEN 1 END) AS cons_realizadas,
    ROUND(100.0 * COUNT(CASE WHEN status_consulta = 'Cancelada' THEN 1 END) / COUNT(*), 2) AS porc_canceladas,
    COUNT(CASE WHEN status_consulta = 'Cancelada' THEN 1 END) AS cons_canceladas,
    ROUND(100.0 * COUNT(CASE WHEN status_consulta = 'Não Compareceu' THEN 1 END) / COUNT(*), 2) AS porc_nao_comparecimento,
	COUNT(CASE WHEN status_consulta = 'Não Compareceu' THEN 1 END) AS cons_nao_compareceu,
    ROUND(100.0 * COUNT(CASE WHEN status_consulta = 'Agendada' THEN 1 END) / COUNT(*), 2) AS porc_agendadas,
    COUNT(CASE WHEN status_consulta = 'Agendada' THEN 1 END) AS cons_agendada
FROM consultas;

-- 5. Quais são os 5 pacientes que mais frequentam o hospital?
-- OBJETIVO: Identificar pacientes recorrentes (fidelidade).

SELECT 
	p.nome_paciente,
    COUNT(CASE WHEN c.status_consulta != 'Cancelada' AND c.status_consulta != 'Não Compareceu' THEN 1 END) AS consultas_marcadas,
    COUNT(CASE WHEN c.status_consulta = 'Realizada' THEN 1 END) AS consultas_realizadas,
    SUM(CASE WHEN c.status_consulta = 'Realizada' THEN valor_consulta ELSE 0 END) AS total_gasto
FROM pacientes p
JOIN consultas c ON p.id_paciente = c.id_paciente
GROUP BY p.id_paciente, p.nome_paciente
ORDER BY consultas_realizadas DESC
LIMIT 5;


-- 6. Qual é o ticket médio por consulta e por especialidade?
-- OBJETIVO: Entender o valor médio gerado por atendimento.

SELECT 
	e.nome_especialidade,
    SUM(CASE WHEN status_consulta = 'Realizada' THEN 1 END) AS consultas_realizadas,
    SUM(CASE WHEN status_consulta = 'Realizada' THEN valor_consulta ELSE 0 END) AS faturamento,
    ROUND(AVG(CASE WHEN status_consulta = 'Realizada'THEN valor_consulta ELSE NULL END ),2) AS ticket_medio 
FROM medicos m 
JOIN especialidades e ON e.id_especialidade = m.id_especialidade
JOIN consultas c ON m.id_medico = c.id_medico
GROUP BY e.nome_especialidade, e.id_especialidade
ORDER BY ticket_medio DESC, faturamento DESC;

-- 7. Qual forma de pagamento é mais utilizada e qual gera mais receita?
-- OBJETIVO: Analisar o comportamento financeiro dos pacientes.

SELECT
	p.forma_pagamento,
    COUNT(*) quantidade,
    SUM(p.valor_pago) faturamento,
    ROUND(AVG(p.valor_pago),2) ticket_medio
FROM pagamentos p
JOIN consultas c ON p.id_consulta = c.id_consulta
WHERE status_pagamento = 'Pago'
GROUP BY p.forma_pagamento
ORDER BY quantidade DESC ,faturamento DESC;
    
-- 8. Qual foi a evolução de faturamento mês a mês?
-- OBJETIVO: Analisar tendência de crescimento ou queda.

SELECT
	DATE_FORMAT(data_consulta, '%Y - %m') ano_mes,
	SUM(CASE WHEN status_consulta = 'Realizada' THEN valor_consulta ELSE 0 END) faturamento,
    ROUND(AVG(CASE WHEN status_consulta = 'Realizada' THEN valor_consulta ELSE NULL END),2) ticket_medio
FROM consultas
GROUP BY ano_mes
ORDER BY ano_mes;

-- 9. Quais médicos possuem mais pacientes únicos atendidos?
-- OBJETIVO: Medir o alcance e diversificação de cada médico.
    
SELECT
	m.nome_medico,
    e.nome_especialidade,
    COUNT(DISTINCT(c.id_paciente)) AS quant_paciente
FROM medicos m
JOIN consultas c ON m.id_medico = c.id_medico
JOIN especialidades e ON m.id_especialidade = e.id_especialidade
WHERE status_consulta = 'Realizada'
GROUP BY m.nome_medico, e.nome_especialidade, m.id_medico
ORDER BY quant_paciente DESC;
    

-- 10. Quais consultas estão com pagamento pendente ou em atraso?
-- OBJETIVO: Controlar inadimplência e fluxo de caixa.

SELECT 
	e.nome_especialidade,
    SUM(CASE WHEN pag.status_pagamento = 'Pendente' THEN 1 ELSE 0 END) pag_pendente,
	SUM(CASE WHEN pag.status_pagamento = 'Pendente' THEN pag.valor_pago ELSE 0 END) valor_pendente,
    SUM(CASE WHEN pag.status_pagamento = 'Reembolsado' THEN 1 ELSE 0 END) pag_reembolso,
    SUM(CASE WHEN pag.status_pagamento = 'Reembolsado' THEN pag.valor_pago ELSE 0 END) valor_reembolso,
    p.nome_paciente,
    p.telefone
FROM consultas c
JOIN pagamentos pag ON pag.id_consulta = c.id_consulta
JOIN pacientes p ON p.id_paciente = c.id_paciente
JOIN medicos m ON m.id_medico = c.id_medico
JOIN especialidades e ON m.id_especialidade = e.id_especialidade
GROUP BY e.nome_especialidade, p.nome_paciente,p.telefone
ORDER BY pag_pendente DESC, pag_reembolso DESC;

	















