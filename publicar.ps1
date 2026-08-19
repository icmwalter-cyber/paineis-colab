# Publica este caderno num repositorio publico do GitHub e devolve o link do Colab.
# Antes de rodar, faca login uma vez:   gh auth login
#
# Cuidado (motivo do erro de 18/08/2026): no Windows PowerShell 5.1, redirecionar a saida de
# erro de um programa (o "2>$null") transforma um aviso comum em erro fatal e derruba o script.
# Por isso aqui NAO se redireciona nada: conferimos o codigo de saida ($LASTEXITCODE) na mao.

$ErrorActionPreference = 'Continue'
Set-Location $PSScriptRoot

$REPO = 'paineis-colab'

# --- 1. conta ---------------------------------------------------------------
$user = (gh api user --jq .login)
if ($LASTEXITCODE -ne 0 -or -not $user) {
  Write-Host "Voce ainda nao entrou no GitHub. Rode primeiro:  gh auth login" -ForegroundColor Yellow
  exit 1
}
$user = $user.Trim()
Write-Host "Conta do GitHub: $user"

# --- 2. acerta o link dentro do README --------------------------------------
$readme = Get-Content README.md -Raw -Encoding utf8
if ($readme -match 'SEU-USUARIO') {
  $readme.Replace('SEU-USUARIO', $user) | Set-Content README.md -Encoding utf8 -NoNewline
  Write-Host "README ajustado com o seu nome de usuario."
}

# --- 3. guarda a versao atual -----------------------------------------------
if (-not (Test-Path .git)) { git init -b main | Out-Null }
git add -A
# E-mail de commit: o endereco "noreply" do proprio GitHub. NUNCA por o e-mail pessoal aqui -
# o repositorio e publico, e o e-mail do autor de um commit fica visivel para qualquer um.
$mail = "$user@users.noreply.github.com"
git -c user.name="$user" -c user.email="$mail" commit -m "Paineis de IA no Colab: um play e pronto" | Out-Null
# (se nao houver nada novo, o commit falha e tudo bem - seguimos)

# --- 4. cria o repositorio, se ainda nao existir -----------------------------
$existe = $false
gh api "repos/$user/$REPO" --silent
if ($LASTEXITCODE -eq 0) { $existe = $true }

if ($existe) {
  Write-Host "O repositorio $user/$REPO ja existe. Vou so atualizar."
} else {
  Write-Host "Criando o repositorio publico $user/$REPO ..."
  gh repo create $REPO --public --description "WanGP no Google Colab: um play e pronto"
  if ($LASTEXITCODE -ne 0) { Write-Host "Nao consegui criar o repositorio." -ForegroundColor Red; exit 1 }
}

# --- 5. envia ----------------------------------------------------------------
git remote remove origin
git remote add origin "https://github.com/$user/$REPO.git"
git push -u origin main --force
if ($LASTEXITCODE -ne 0) { Write-Host "Nao consegui enviar os arquivos." -ForegroundColor Red; exit 1 }

# --- 6. os links ------------------------------------------------------------
$base = "https://colab.research.google.com/github/$user/$REPO/blob/main"
$foto  = "$base/fooocus_colab.ipynb"
$video = "$base/wangp_colab.ipynb"
Write-Host ""
Write-Host "PRONTO. Os links para mandar para qualquer pessoa:" -ForegroundColor Green
Write-Host ""
Write-Host "  FOTOS  (Fooocus): $foto"
Write-Host "  VIDEOS (WanGP)  : $video"
Write-Host ""
try { "$foto`r`n$video" | Set-Clipboard; Write-Host "(ja copiei os dois para a area de transferencia)" } catch {}
