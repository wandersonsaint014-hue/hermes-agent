# Hermes original com preparação em português

Fork de [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent), licença MIT original preservada. Não é distribuição oficial nem produto integrado ao VOID. O núcleo original e seu README foram mantidos; esta branch adiciona somente guias e scripts `pt-br/`.

**Base inspecionada:** `cf4f3a7396814ffcaef69d9af09f7cfdade3ddbe`. Fixar versão melhora reprodutibilidade, não garante ausência de vulnerabilidades. Revise atualizações oficiais antes de adotá-las; o pin deste script não muda sozinho.

## O que resolve
- Perfil separado em `~/.hermes-pt-br`, sem sobrescrever o perfil padrão.
- Interface parcial em `pt` e personalidade persistente solicitando respostas em pt-BR.
- Instalador oficial com SHA-256 conferido e código de origem fixado.
- Navegador e controle do computador omitidos; sem conexão automática a contas ou modelo.
- Backup de SOUL.md diferente antes de aplicar o perfil.

**Não promete instalação sem problemas ou tradução completa.** Logs, ferramentas, descrições e erros podem permanecer em inglês. O idioma das respostas também depende do modelo. Instruções de personalidade não constituem isolamento ou autorização técnica.

## Linux, WSL2 ou macOS Apple Silicon
Requer Git, curl, tar, Python 3 e ao menos 3 GiB livres como verificação inicial conservadora. A instalação completa pode precisar de mais espaço. Não execute como root. O instalador original baixa dependências, pode solicitar pacotes do sistema e publicar `~/.local/bin/hermes`, além de alterar a configuração de PATH do shell. Embora o perfil seja separado, o lançador é compartilhado com outras instalações Hermes: revise isso se já usa Hermes.

```bash
git clone --branch pt-br-setup https://github.com/wandersonsaint014-hue/hermes-agent.git hermes-portugues
cd hermes-portugues
bash pt-br/install.sh
```

O script mostra o escopo e pede confirmação. `--yes` aceita somente a instalação anunciada, não ações futuras do agente.

Após concluir, em cada terminal destinado a esse perfil:
```bash
export HERMES_HOME="$HOME/.hermes-pt-br"
export HERMES_LANGUAGE=pt
export PATH="$HOME/.local/bin:$PATH"
hermes status
hermes model
hermes tools
hermes
```

Escolha conscientemente provedor/modelo e ferramentas. Não cole chaves em issues, commits ou conversas. Use o mecanismo oficial de configuração. Nenhum provedor pago é escolhido por este pacote. Um modelo local requer instalação e recursos próprios, não incluídos aqui.

## Aplicar somente idioma numa instalação existente
Use um perfil de teste dedicado. O comando abaixo preserva outras configurações, mas altera idioma e personalidade desse perfil, criando backup da personalidade anterior quando necessário:
```bash
python3 pt-br/apply.py --home "$HOME/.hermes-pt-br" --hermes hermes
```
Depois inicie com o mesmo `HERMES_HOME` e `HERMES_LANGUAGE=pt`. Para desfazer, restaure o backup de SOUL.md e execute `hermes config set display.language en` nesse perfil.

## Windows e Android
- Windows nativo: siga o [guia oficial de instalação](https://hermes-agent.nousresearch.com/docs/getting-started/installation), sem usar este script Bash. Depois, com Python disponível, aplique `apply.py` a um perfil dedicado e defina `HERMES_HOME`/`HERMES_LANGUAGE` no PowerShell antes de iniciar.
- Android/Termux aarch64: use exclusivamente o repositório APT assinado e o guia Termux oficial vinculado na página de instalação. Não execute o instalador desktop no Android. A aplicação de `apply.py` depende de Python e da CLI já funcionarem. Não foi validada em aparelho real.

## Segurança e validação
Use VM/container separado para experimentar ferramentas; HERMES_HOME separado não impede acesso aos demais arquivos da máquina. Não habilite gateway, integrações, MCP ou acesso a projetos reais sem avaliar permissões. Não use `--yolo` ou `--oneshot` nos testes de aprovação: a ajuda desta versão informa que o modo one-shot ignora aprovações automaticamente.

Veja [roteiro e limites da validação](pt-br/TESTES.md). Sem modelo configurado, não há teste real de conversa. Nunca publique logs sem revisar possíveis segredos.

Para verificar sintaxe sem instalar:
```bash
bash -n pt-br/install.sh
python3 -m py_compile pt-br/apply.py
```

## Atualizações
A branch `main` permanece como cópia do original; as adaptações estão em `pt-br-setup`. Compare upstream antes de sincronizar. O comando upstream `hermes update` pode avançar a versão instalada: não o execute esperando preservar este pin. Atualizações devem ser revisadas e testadas antes de uso com dados reais.
