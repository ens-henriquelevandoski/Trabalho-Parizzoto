$ErrorActionPreference = "Stop"

function Passo($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }

Passo "Atualizando a main"
git checkout main
git pull origin main

Passo "Configurando o .gitignore"
$ignorados = @("senha.txt", "notas-pessoais.txt", "rascunho.txt", "teste.log")
foreach ($f in $ignorados) { Set-Content -Path $f -Value "arquivo de teste do .gitignore" -Encoding utf8 }
Set-Content -Path ".gitignore" -Value $ignorados -Encoding utf8
foreach ($f in $ignorados) {
    if (git ls-files $f) { git rm --cached $f }
}
git add .gitignore
git commit -m "Adiciona .gitignore com 4 arquivos ignorados"
git push origin main
Write-Host "Arquivos ignorados pelo Git (devem aparecer abaixo):"
git status --ignored --short

function NovaBranch($branch, $arquivo, $conteudo, $mensagem, $titulo) {
    Passo "Branch $branch"
    git checkout main
    git checkout -b $branch
    Set-Content -Path $arquivo -Value $conteudo -Encoding utf8
    git add $arquivo
    git commit -m $mensagem
    git push -u origin $branch

    if (Get-Command gh -ErrorAction SilentlyContinue) {
        gh pr create --base main --head $branch --title $titulo --body "Alterações da branch $branch."
        gh pr merge $branch --merge --delete-branch=false
        git checkout main
        git pull origin main
    } else {
        Write-Host "gh não encontrado. No GitHub, abra o Pull Request da branch '$branch' para a main e clique em Merge pull request." -ForegroundColor Yellow
        Read-Host "Depois de fazer o merge no GitHub, pressione Enter para continuar"
        git checkout main
        git pull origin main
    }
}

$readme = @"
# Loja de Brinquedos

Página institucional e comercial de uma loja virtual de brinquedos, desenvolvida em **HTML5 e CSS3**, com layout responsivo e identidade visual em vermelho, preto e branco inspirada em peças de montar.

## Sobre o projeto

O projeto foi desenvolvido na disciplina de desenvolvimento web da UGV e também serve como prática de versionamento com **Git e GitHub**, aplicando commits, branches, Pull Requests e ``.gitignore``.

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
| ``index.html`` | Página principal da loja |
| ``contato.html`` | Página de contato |
| ``img.jpg.webp`` | Imagem utilizada na página |
| ``.gitignore`` | Arquivos que não devem ser enviados ao repositório |
| ``entrega-git.ps1`` | Script de automação das etapas de Git e GitHub |

## Fluxo de versionamento

| Branch | Finalidade |
|---|---|
| ``main`` | Versão estável do projeto |
| ``feature-readme`` | Documentação do projeto |
| ``feature-contato`` | Criação da página de contato |

Cada branch foi integrada à ``main`` por meio de Pull Request no GitHub.

## Autor

**Henrique Levandoski**  
Acadêmico da UGV
"@
NovaBranch "feature-readme" "README.md" $readme "Adiciona README com descrição do projeto" "Adiciona README ao projeto"

$contato = @"
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
"@
NovaBranch "feature-contato" "contato.html" $contato "Adiciona página de contato" "Adiciona página de contato"

Passo "Conferência final"
git branch -a
git log --oneline --graph --all -n 15
Write-Host "`nConfira no GitHub: repositório público, 2 branches, 2 Pull Requests merged e o .gitignore." -ForegroundColor Green
