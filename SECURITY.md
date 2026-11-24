# Segurança

## Como relatar uma vulnerabilidade

**Não abra issue pública.** Use o relato privado do GitHub: aba **Security → Report a vulnerability** deste repositório.

Inclua: o que foi encontrado, como reproduzir, impacto possível e versão ou commit afetado. A equipe confirma o recebimento, avalia a gravidade e informa o andamento pelo próprio relato.

## Versões suportadas

Ainda não há versão publicada. Esta seção será atualizada no primeiro lançamento.

## Regras obrigatórias

- **Segredos** (senhas, tokens, chaves, certificados, `.env`) nunca entram no repositório. O CI verifica segredos em todo push e PR. Se um segredo vazar, ele deve ser **revogado e trocado** imediatamente; apagar do histórico não basta.
- **Servidor autoritativo:** nenhum resultado, recompensa ou progresso é aceito só porque o cliente afirmou (ADR-0003).
- **DesbravaClube:** nunca pedir a senha do usuário; nunca confiar em `club_id` enviado pelo cliente; vínculo validado entre servidores.
- **Privilégio mínimo** em serviços, banco de dados, CI e infraestrutura.
- **Dependências** e imagens fixadas por versão ou digest, atualizadas por PR.
- **Crianças e adolescentes:** sem chat livre, mensagens privadas ou voz na primeira versão; coleta mínima de dados. Conformidade com a LGPD avaliada antes do lançamento público.

Requisitos completos: [PLANO_MESTRE §6](docs/PLANO_MESTRE.md#6-segurança-da-aplicação).
