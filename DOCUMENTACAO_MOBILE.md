# Documentação Mobile — Street House

## 1. Visão geral

A versão mobile conecta artistas e organizadores em uma experiência própria para smartphones: entrada guiada, descoberta, perfil/portfólio, comunicação e agenda. A aplicação atual é uma demonstração segura com dados identificados como fictícios.

## 2. Tecnologias utilizadas

- Flutter estável e Dart 3.4+ — interface multiplataforma e tipada.
- Material 3 — componentes nativos, acessibilidade e adaptação visual.
- `cupertino_icons` — compatibilidade visual complementar com iOS.
- `flutter_lints` — análise estática padronizada.
- Nenhuma biblioteca de rede ou armazenamento é usada enquanto não existe backend oficial.

## 3. Arquitetura

Fluxo preparado: **UI → AppController → StreetRepository → futura API**.

```text
lib/
├── main.dart                 tema, bootstrap e shell adaptativo
├── models/                   entidades de domínio
├── repositories/             contrato de dados e implementação mock
├── state/                    estado de carregamento e busca
└── screens/                  acesso, exploração e mensagens
```

## 4. Arquivos criados

| Arquivo | Finalidade |
|---|---|
| `models/domain_models.dart` | Models de artista, evento, conversa, portfólio e papel de usuário. |
| `repositories/street_repository.dart` | Contrato desacoplado e dados mock identificados. |
| `state/app_controller.dart` | Busca e estados loading/success/empty/error. |
| `screens/access_flow.dart` | Splash, onboarding, login validado e escolha Artista/Organizador. |
| `screens/explore_screen.dart` | Busca, filtros, resultados, empty state e perfil resumido. |
| `screens/messages_screen.dart` | Conversas e chat demonstrativo preparado para backend. |
| `vercel.json` | Build Flutter Web, roteamento e headers de segurança. |
| `scripts/vercel-build.sh` | Instalação reproduzível do Flutter e build web. |

## 5. Arquivos alterados

| Arquivo | Alteração | Motivo |
|---|---|---|
| `main.dart` | Material 3, navegação adaptativa e cinco destinos. | Experiência mobile e desktop coerente. |
| `pubspec.yaml` | Dart moderno e dependências mínimas. | Segurança e manutenção. |
| `AndroidManifest.xml` | Cleartext bloqueado. | Impedir HTTP inseguro. |
| `web/index.html` e `manifest.json` | SEO, PWA e identidade. | Publicação web profissional. |
| `widget_test.dart` | Fluxos de splash/onboarding/login. | Cobertura dos estados iniciais. |

## 6. Telas implementadas

| Tela | Objetivo e ações | Rota/integração |
|---|---|---|
| Splash | Entrada animada da marca. | Inicial, local. |
| Onboarding | Três benefícios, pular/continuar/começar. | Local. |
| Login | Papel, e-mail, senha, visibilidade e validação. | Mock; autenticação pendente. |
| Início | Descoberta, busca visual, destaques e eventos. | Shell `/`, mock. |
| Explorar | Busca por nome/categoria/local, filtros e estados. | Repository mock. |
| Agenda | Próximos eventos e status. | Mock. |
| Mensagens | Conversas, não lidas e chat. | Interface mock. |
| Perfil | Dados e atalhos do usuário demonstrativo. | Mock. |

## 7. Navegação

`Splash → Onboarding → Login → HomeShell`. O shell usa `NavigationBar` no smartphone e menu lateral em telas amplas. Destinos: Início, Explorar, Agenda, Mensagens e Perfil. O chat abre por rota Material interna.

## 8. Models

- `UserRole`: Artista ou Organizador.
- `Artist`: identidade pública e disponibilidade.
- `StreetEvent`: compromisso, local, data e status.
- `Conversation`: resumo de conversa e contagem não lida.
- `PortfolioItem`: metadado de trabalho artístico.

## 9. API

`StreetRepository` define o contrato que a futura API deverá implementar. `MockStreetRepository` oferece dados fictícios e latência controlada. Não existem endpoints, tokens ou autenticação reais. A implementação futura deve centralizar base URL HTTPS, timeout, sessão expirada e respostas inválidas no service, mantendo UI desacoplada.

## 10. Funcionalidades

| Funcionalidade | Status | Implementação |
|---|---|---|
| Splash e onboarding | Implementado | Fluxo local navegável. |
| Escolha Artista/Organizador | Implementado | Estado da interface. |
| Login/cadastro/recuperação | Pendente de Back-end | Formulário e validação; sem autenticação falsa. |
| Descoberta e busca | Mock | Repository substituível. |
| Perfil e portfólio | Parcial | Perfil e estrutura de model; CRUD depende da API. |
| Agenda | Mock | Visualização pronta; CRUD depende da API. |
| Mensagens | Pendente de Back-end | Conversas/chat apenas visuais e explicitamente sinalizados. |
| Ajuda/FAQ | Pendente | Próxima etapa de produto. |

## 11. Alterações visuais

A paleta usa roxo principal `#AF20E7`, superfícies escuras e coral como apoio. A navegação inferior, listas horizontais, sheets, chips, áreas de toque e SafeArea priorizam smartphones. Em telas amplas, o shell muda para navegação lateral sem simplesmente ampliar a UI mobile.

## 12. Segurança

- Sem senhas, tokens, chaves ou URLs privadas no bundle.
- Sem persistência insegura de sessão.
- HTTP cleartext bloqueado no Android.
- `.env` ignorado.
- Dados fictícios declarados na interface e documentação.
- Camada de autorização reservada ao futuro backend.

## 13. Testes

Testes de widget cobrem Splash → Onboarding e Onboarding → Login. O build Flutter Web é executado com sucesso pela Vercel. O GitHub Actions está configurado para format, analyze, test e build, mas o runner da conta está bloqueado por billing; isso ocorre antes de executar o código.

## 14. Pendências

Backend, autenticação, cadastro persistente, recuperação, upload de portfólio, CRUD de eventos, chat em tempo real, notificações e suporte/FAQ dependem de API e decisões de produto. Nada disso é apresentado como integração concluída.

## 15. Como executar

```bash
flutter pub get
flutter analyze
flutter test
flutter run
flutter build web --release
```

Requer Flutter 3.22+ e Dart 3.4+. Não há variáveis obrigatórias na demonstração.

## 16. Histórico das alterações

| Alteração | Arquivos | Resultado |
|---|---|---|
| Segurança e remoção da API antiga | `services/`, Manifest, pubspec | Demo sem credenciais ou tráfego inseguro. |
| Nova base visual | `main.dart` | Material 3 adaptativo. |
| Fluxo de entrada | `access_flow.dart` | Splash, onboarding e login. |
| Domínio e dados | models/repository/state | Preparação para API real. |
| Exploração e mensagens | screens | Fluxos mobile e estados explícitos. |
| Publicação | scripts e `vercel.json` | Deploy reprodutível na Vercel. |
