# Segurança

## Versões suportadas

Apenas a versão mais recente da branch `main` recebe correções.

## Relato responsável

Não abra uma issue pública para vulnerabilidades. Envie o relato de forma privada pelo recurso **Security Advisories** do GitHub, incluindo impacto, reprodução e correção sugerida quando possível.

## Premissas atuais

Street House é uma demonstração client-side: não autentica usuários, não armazena tokens e não coleta dados pessoais. Nenhuma credencial deve ser adicionada ao bundle Flutter. Integrações futuras devem usar HTTPS e segredos apenas no servidor.
