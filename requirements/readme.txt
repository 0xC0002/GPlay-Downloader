Script de Download de Áudios da Globoplay
Este script em PowerShell permite que você baixe áudios de episódios da Globoplay utilizando links .m3u8.

Requisitos
1. Sistema Operacional: Windows 10 ou superior
2. PowerShell: Recomendado PowerShell 7.0 ou superior
3. Ferramenta Externa: ffmpeg deve estar instalado e no PATH do sistema.
   Baixe o ffmpeg em: https://ffmpeg.org/download.html
4. Verifique se o ffmpeg está acessível no terminal executando o comando ffmpeg -version.
5. .NET Framework
 

Preparação
Este script requer algumas configurações no sistema para ser executado com sucesso:

Passo 1: Desbloquear o Script
O Windows pode ter bloqueado sua execução. Para desbloqueá-lo, siga estes passos:

1. Abra o PowerShell.
2. Navegue até o diretório onde o script está salvo.
3. Execute o seguinte comando para desbloquear o script:
Unblock-File -Path "caminho\para\o\script\baixar_audios.ps1"
Observação: Substitua "caminho\para\o\script\baixar_audios.ps1" pelo caminho completo do script.

Passo 2: Configurar a Política de Execução
Para executar scripts PowerShell no Windows, você precisa permitir a execução de scripts. O nível recomendado é RemoteSigned, que permite a execução de scripts locais não assinados, mas requer assinatura para scripts baixados de outras fontes.

1. Abra o PowerShell como Administrador.
2. Execute o seguinte comando:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
3. Quando solicitado, digite A e pressione Enter para confirmar.
