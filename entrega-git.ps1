# Execute DENTRO da pasta do repositório clonado (ex.: Trabalho-Andrea), no PowerShell.
# Requisitos: git instalado e login feito no GitHub. O GitHub CLI (gh) é opcional:
# com ele os Pull Requests são abertos e integrados automaticamente.

$ErrorActionPreference = "Stop"

function Passo($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }

# 0. Garantir que estamos na main atualizada
Passo "Atualizando a main"
git checkout main
git pull origin main

# 1. .gitignore com 4 arquivos distintos
Passo "Configurando o .gitignore"
$ignorados = @("senha.txt", "notas-pessoais.txt", "rascunho.txt", "teste.log")
foreach ($f in $ignorados) { Set-Content -Path $f -Value "arquivo de teste do .gitignore" -Encoding utf8 }
Set-Content -Path ".gitignore" -Value $ignorados -Encoding utf8
foreach ($f in $ignorados) {
    if (git ls-files $f) { git rm --cached $f }   # tira do remoto se já tinha sido enviado
}
git add .gitignore
git commit -m "Adiciona .gitignore com 4 arquivos ignorados"
git push origin main
Write-Host "Arquivos ignorados pelo Git (devem aparecer abaixo):"
git status --ignored --short

# Função para criar branch, commitar, enviar e integrar o PR
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

# 2. Primeira branch: README.md
$readme = @"
# Loja de Brinquedos

Projeto de página responsiva em HTML e CSS (index.html) com cabeçalho, menu, corpo e rodapé.

## Como visualizar
Abra o arquivo index.html no navegador.
"@
NovaBranch "feature-readme" "README.md" $readme "Adiciona README com descrição do projeto" "Adiciona README ao projeto"

# 3. Segunda branch: página de contato
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
  <p>Fale com a nossa loja pelo e-mail contato@lojadebrinquedos.example.</p>
  <a href="index.html">Voltar para a página inicial</a>
</body>
</html>
"@
NovaBranch "feature-contato" "contato.html" $contato "Adiciona página de contato" "Adiciona página de contato"

# 4. Conferência final
Passo "Conferência final"
git branch -a
git log --oneline --graph --all -n 15
Write-Host "`nConfira no GitHub: repositório público, 2 branches, 2 Pull Requests merged e o .gitignore." -ForegroundColor Green
