# Script PowerShell: Baixar Áudios de Links .m3u8 de um Arquivo `.txt`

Este script em PowerShell permite o download e a conversão automática de áudios `.mp3` a partir de links `.m3u8` fornecidos em um arquivo `listagloboplay.txt`. Ele organiza automaticamente os áudios em uma estrutura de pastas para séries e filmes, facilitando o armazenamento e a organização dos arquivos.

## Funcionalidades

- **Criação de Estrutura de Pastas**: Organiza os arquivos baixados em pastas personalizadas para séries (por temporada) ou filmes.
- **Download e Conversão para `.mp3`**: Baixa os áudios dos links `.m3u8` fornecidos no arquivo `listagloboplay.txt` e converte para `.mp3` com uma taxa de bits de 128 kbps usando `ffmpeg`.

## Pré-requisitos

- **PowerShell**: O script deve ser executado no PowerShell.
- **ffmpeg**: Certifique-se de que o `ffmpeg` está instalado e acessível no caminho do sistema.
  - [Download do ffmpeg](https://ffmpeg.org/download.html)
- **Tampermonkey e Script para Resgatar Links `.m3u8`**: Para capturar os links `.m3u8` do Globoplay, você precisa:
  1. Instalar a extensão [Tampermonkey](https://www.tampermonkey.net/) em seu navegador.
  2. Adicionar o seguinte script no Tampermonkey:

  # Como Configurar e Usar
### Passo 1: Configurar o Arquivo listagloboplay.txt
Crie um arquivo chamado listagloboplay.txt no mesmo diretório onde está o script PowerShell.
Use o Tampermonkey com o script acima para capturar os links .m3u8 e cole cada link no arquivo listagloboplay.txt, colocando um link por linha.
Passo 2: Configurar o Diretório Base de Download
No script, ajuste o valor de $diretorioBase para o diretório onde deseja que os arquivos de áudio sejam salvos.
powershell
Copiar código
$diretorioBase = "C:\Users\bruno\Videos\Captures"
Passo 3: Executar o Script
Abra o PowerShell no diretório onde está o script.
Execute o script com o comando:
powershell
Copiar código
.\baixar_audios.ps1
Passo 4: Selecionar o Tipo de Mídia e Inserir o Nome
O script perguntará se você está baixando uma série ou um filme. Responda com s para série ou f para filme.
Em seguida, insira o nome da série ou filme.
Se for uma série, o script também pedirá o número de temporadas. Ele criará automaticamente pastas separadas para cada temporada.
Passo 5: Progresso e Conclusão
O script mostrará o progresso à medida que baixa e converte os arquivos.
Ao final, todos os áudios estarão organizados na estrutura de pastas especificada.
Estrutura de Pastas Criada
Se for um filme, a estrutura será:

markdown
Copiar código
Captures/
└── Nome_do_Filme/
    └── 01.mp3
    └── 02.mp3
Se for uma série, a estrutura será:

markdown
Copiar código
Captures/
└── Nome_da_Série/
    └── Temporada 1/
        └── 01.mp3
        └── 02.mp3
    └── Temporada 2/
        └── 01.mp3
        └── 02.mp3
Observações
Erros de Download: Caso algum link falhe, o script exibe uma mensagem de erro e continua com o próximo link.
Configuração do PowerShell: Certifique-se de que as configurações de execução do PowerShell permitem a execução de scripts:
powershell
Copiar código
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Licença
Este script é fornecido como está, para uso pessoal ou educacional. Sinta-se livre para modificá-lo conforme necessário.

```javascript
// ==UserScript==
// @name         Copiar .m3u8 de áudio do Globoplay
// @namespace    http://tampermonkey.net/
// @version      1.6
// @description  Copia o link do manifest-audio .m3u8 quando a página é carregada ou mudada, sem duplicações
// @match        https://globoplay.globo.com/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    let lastUrl = window.location.href; // Armazena a URL atual
    let lastAudioLink = ""; // Armazena o último link copiado

    function copyAudioM3U8() {
        setTimeout(() => {
            const requests = performance.getEntriesByType("resource");

            const audioM3U8Links = requests
                .filter(req => req.name.includes('manifest-audio') && req.name.endsWith('.m3u8'))
                .map(req => req.name);

            if (audioM3U8Links.length > 0) {
                const latestLink = audioM3U8Links[audioM3U8Links.length - 1];
                if (latestLink !== lastAudioLink) {
                    lastAudioLink = latestLink;
                    navigator.clipboard.writeText(latestLink).then(() => {
                        alert('Link .m3u8 de áudio copiado: ' + latestLink);
                    });
                }
            }
        }, 5000);
    }

    function checkUrlChange() {
        const currentUrl = window.location.href;
        if (currentUrl !== lastUrl) {
            lastUrl = currentUrl;
            copyAudioM3U8();
        }
    }

    const originalPushState = history.pushState;
    history.pushState = function (...args) {
        originalPushState.apply(this, args);
        checkUrlChange();
    };
    window.addEventListener('popstate', checkUrlChange);
    window.addEventListener('load', copyAudioM3U8);
})();
