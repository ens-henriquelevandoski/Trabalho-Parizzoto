$ErrorActionPreference = "Stop"
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Passo($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }

function Salvar($arquivo, $texto) {
    $caminho = Join-Path (Get-Location).Path $arquivo
    [System.IO.File]::WriteAllText($caminho, $texto, $utf8)
}

$readme = @'
# Loja de Brinquedos

Página institucional e comercial de uma loja virtual de brinquedos, desenvolvida em **HTML5 e CSS3**, com layout responsivo e identidade visual em vermelho, preto e branco inspirada em peças de montar.

## Sobre o projeto

O projeto foi desenvolvido na disciplina de desenvolvimento web da UGV e também serve como prática de versionamento com **Git e GitHub**, aplicando commits, branches, Pull Requests e `.gitignore`.

## Funcionalidades

- Layout responsivo, adaptado para desktop, tablet e celular
- Aviso promocional no topo, cabeçalho e menu de navegação
- Seção de boas-vindas com chamada para ação
- Compra por faixa etária
- Destaques e produtos mais vendidos
- Localização e informações de contato
- Perguntas frequentes
- Cadastro para receber ofertas e novidades
- Recursos de acessibilidade, como foco visível, textos alternativos nas imagens e respeito à preferência por movimento reduzido

## Tecnologias

| Tecnologia | Uso |
|---|---|
| HTML5 | Estrutura semântica da página |
| CSS3 | Estilização, layout responsivo e variáveis de tema |
| Google Fonts (Rubik) | Tipografia |
| Git e GitHub | Versionamento e colaboração |

## Estrutura do repositório

| Arquivo | Descrição |
|---|---|
| `index.html` | Página principal da loja |
| `contato.html` | Página de contato |
| `.gitignore` | Arquivos que não devem ser enviados ao repositório |
| `entrega-git.ps1` | Script de automação das etapas de Git e GitHub |

## Fluxo de versionamento

| Branch | Finalidade |
|---|---|
| `main` | Versão estável do projeto |
| `feature-readme` | Documentação do projeto |
| `feature-contato` | Criação da página de contato |

Cada branch foi integrada à `main` por meio de Pull Request no GitHub.

## Autor

**Henrique Levandoski**  
Acadêmico da UGV
'@

$contato = @'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Contato - Loja de Brinquedos</title>
</head>
<body>
  <h1>Contato</h1>
  <p>Fale com a nossa loja pelo e-mail contato@lojadebrinquedos.com.</p>
  <a href="index.html">Voltar para a página inicial</a>
</body>
</html>
'@

Passo "Corrigindo o README"
git checkout feature-readme
Salvar "README.md" $readme
git add README.md
git commit -m "Corrige acentuacao do README"
git push origin feature-readme

Write-Host "Abra https://github.com/ens-henriquelevandoski/Trabalho-Parizzoto/pull/new/feature-readme, crie o Pull Request e clique em Merge pull request." -ForegroundColor Yellow
Read-Host "Depois do merge, pressione Enter para continuar"
git checkout main
git pull origin main

Passo "Branch feature-contato"
git checkout -b feature-contato
Salvar "contato.html" $contato
git add contato.html
git commit -m "Adiciona pagina de contato"
git push -u origin feature-contato

Write-Host "Abra https://github.com/ens-henriquelevandoski/Trabalho-Parizzoto/pull/new/feature-contato, crie o Pull Request e clique em Merge pull request." -ForegroundColor Yellow
Read-Host "Depois do merge, pressione Enter para continuar"
git checkout main
git pull origin main

Passo "Conferencia final"
git branch -a
git log --oneline --graph --all -n 15
