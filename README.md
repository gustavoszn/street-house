# Street House

Plataforma demonstrativa que aproxima artistas independentes, coletivos e organizadores de eventos. O projeto apresenta uma experiência multiplataforma construída com Flutter, com foco em descoberta, agenda, conexões profissionais e portfólio artístico.

> Projeto acadêmico e demonstrativo. Os nomes, eventos e perfis exibidos são fictícios; a aplicação não coleta dados pessoais nem realiza autenticação real.

## Experiência

- Descoberta de artistas e eventos próximos;
- agenda visual de apresentações e oportunidades;
- rede de conexões entre artistas e produtores;
- perfil artístico demonstrativo;
- navegação lateral em telas amplas e barra inferior no mobile;
- tema escuro Material 3 com componentes acessíveis;
- layout responsivo para Web, Android, iOS e desktop.

## Executar localmente

Requisitos: Flutter 3.22+ e Dart 3.4+.

```bash
flutter pub get
flutter run -d chrome
```

Para gerar a versão web:

```bash
flutter build web --release
```

## Qualidade

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

O workflow em `.github/workflows/quality.yml` executa essas verificações e o build web em cada push e pull request.

## Arquitetura e segurança

A versão 2.0 foi convertida em uma demonstração local segura. Ela não contém backend, credenciais, tokens, telemetria ou persistência de dados. Qualquer integração futura deverá usar HTTPS, configuração por ambiente e armazenamento seguro de credenciais no dispositivo.

Consulte [CHANGELOG.md](CHANGELOG.md) para o histórico detalhado e [SECURITY.md](SECURITY.md) para a política de segurança.

## Autoria

Concepção e desenvolvimento por Gustavo Brito Rodrigues de Sousa.

## Licença

Distribuído sob a licença MIT. Consulte [LICENSE](LICENSE).
