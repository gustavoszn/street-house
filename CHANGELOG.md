# Histórico de alterações

## 2.0.0 — modernização completa

### Segurança

- Removida a API HTTP presa a `localhost` e `10.0.2.2`.
- Removidos logs que expunham URL, status, corpo de resposta e erros de login.
- Removido armazenamento de token e usuário em `SharedPreferences`.
- Removidos fluxos de login e recuperação sem integração funcional.
- Adicionadas regras para impedir o versionamento de arquivos `.env`.
- Aplicação convertida em demonstração sem coleta ou persistência de dados pessoais.

### Interface e experiência

- Nova identidade visual escura com Material 3.
- Nova home de descoberta com busca, artistas e eventos.
- Áreas funcionais para agenda, conexões e perfil artístico.
- Navegação adaptativa: menu lateral no desktop e barra inferior no mobile.
- Componentes com rótulos, tooltips e áreas de toque adequadas.
- Transições suaves e layouts fluidos para diferentes larguras.

### Arquitetura e manutenção

- SDK mínimo atualizado para Dart 3.4.
- Dependências externas reduzidas ao necessário.
- Nome do pacote normalizado para `street_house`.
- Testes atualizados para a experiência atual.
- Pipeline CI para formatação, análise, testes e build web.
- Documentação, política de segurança, contribuição e licença adicionadas.

### Removido

- Telas e serviços antigos duplicados ou sem integração funcional.
- Dependências `http`, `shared_preferences`, `google_fonts` e `url_launcher`.
- Lockfile legado com fontes HTTP e versões incompatíveis com o SDK atual.
