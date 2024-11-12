# Garante que o PowerShell interprete e exiba corretamente caracteres especiais
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Defina aqui o diretório base onde as séries/filmes serão salvos
$diretorioBase = "C:\Users\bruno\Videos\Captures"

# Função para criar a estrutura de pastas
function CriarEstruturaDePastas() {
    param (
        [string]$nome,     # Nome da série ou filme
        [bool]$ehSerie      # Indica se é série (true) ou filme (false)
    )

    # Cria a pasta principal com o nome da série/filme
    $caminhoPasta = Join-Path $diretorioBase -ChildPath $nome
    New-Item -ItemType Directory -Path $caminhoPasta -Force | Out-Null

    # Se for uma série, pergunta o número de temporadas e cria as pastas
    if ($ehSerie) {
        $numTemporadas = Read-Host "Quantas temporadas a série possui?"

        for ($i = 1; $i -le $numTemporadas; $i++) {
            $pastaTemporada = "Temporada $i"
            $caminhoTemporada = Join-Path $caminhoPasta -ChildPath $pastaTemporada
            New-Item -ItemType Directory -Path $caminhoTemporada -Force | Out-Null
        }
    }

    # Retorna o caminho da pasta principal
    return $caminhoPasta
}

# Pergunta ao usuário se é uma série ou filme
$tipo = Read-Host "Serie ou um filme? (s/f)"
$ehSerie = $tipo.ToLower() -eq "s"

# Pergunta o nome da série ou filme
$nomeMidia = Read-Host "Qual o nome da serie ou filme?"

# Cria a estrutura de pastas e obtém o caminho da pasta principal
$pastaPrincipal = CriarEstruturaDePastas -nome $nomeMidia -ehSerie $ehSerie

# Verifica se o arquivo listagloboplay.txt existe
if (!(Test-Path .\listagloboplay.txt)) {
    Write-Host "Erro: O arquivo listagloboplay.txt não foi encontrado!"
    exit 1
}

# Obtém o total de links no arquivo para calcular a porcentagem
$totalLinks = (Get-Content .\listagloboplay.txt | Where-Object { $_.Trim() -ne "" }).Count
$contador = 1 # Inicializa um contador para os episódios

# Lê cada linha do arquivo e baixa o áudio
Get-Content .\listagloboplay.txt | ForEach-Object {
    $url = $_.Trim()

    # Ignora linhas vazias
    if ($url -eq "") { return }

    # Define o nome do arquivo baseado no número do episódio
    $nomeArquivo = "$contador.mp3"

    # Define o caminho completo do arquivo
    $caminhoArquivo = Join-Path $pastaPrincipal -ChildPath $nomeArquivo

    Write-Host "Baixando e convertendo: $url -> $caminhoArquivo"

    # Baixa e converte o áudio para .mp3 com bitrate fixo de 128 kbps usando ffmpeg
    ffmpeg -i $url -c:a libmp3lame -b:a 128k $caminhoArquivo

    # Verifica se houve erro no download ou conversão
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erro ao baixar/converter: $url"
    } else {
        Write-Host "Download e conversão concluídos: $caminhoArquivo"
    }

    # Calcula e exibe a porcentagem de progresso total
    $progressoTotal = [math]::Round(($contador / $totalLinks) * 100, 2)
    Write-Host "Progresso total: $progressoTotal% ($contador de $totalLinks episódios)"

    # Incrementa o contador para o próximo episódio
    $contador++
}