# Vollmed Operações

Scripts de backup, restauração e monitoramento da API [vollmed-api](https://github.com/LucAssis23/vollmed-api), escritos em Shell Script.

## Scripts

| Script | O que faz |
|---|---|
| `backup-aws.sh` | Gera um `mysqldump` por tabela, organiza por data e envia para um bucket S3 (`aws s3 sync`) |
| `restore-aws.sh` | Baixa um backup do S3 e restaura uma tabela (`mysql < arquivo.sql`) |
| `verifica-saude.sh` | Checa o código HTTP da API e envia e-mail de alerta se não for 200 |
| `cobertura-teste.sh` | Consulta a cobertura de testes no SonarCloud e envia e-mail se estiver abaixo da meta (80%) |

## Requisitos

`bash`, `curl`, `jq`, `bc`, cliente MySQL e AWS CLI v2 configurado (`aws configure`) com acesso ao bucket.

## Configuração

Os segredos **não ficam nos scripts nem no repositório**. Eles ficam em um arquivo fora do projeto:

```bash
mkdir -p ~/.config/vollmed
cp alertas.env.example ~/.config/vollmed/alertas.env
chmod 600 ~/.config/vollmed/alertas.env
nano ~/.config/vollmed/alertas.env   # preencha com os valores reais
```

- `SONAR_TOKEN`: token do SonarCloud
- `SMTP_SENHA`: **senha de app** do Gmail (não a senha da conta)
- `API_URL`: endereço da API (muda se a EC2 for parada, a menos que use IP elástico)
- `REMETENTE` e `DESTINATARIO`: e-mails do alerta

Para o backup, as credenciais do MySQL ficam em um `.my.cnf` (`chmod 600`), também fora do repositório.

## Uso

```bash
bash backup-aws.sh vollmed_db          # backup e envio ao S3
bash restore-aws.sh 2026-10-30 medicos # restaura a tabela medicos do backup dessa data
bash verifica-saude.sh                 # checa a API
bash cobertura-teste.sh                # checa a cobertura
```

Rode os scripts **sem `sudo`**: arquivos criados com `sudo` ficam com dono root e causam `Permissão negada` depois.

## Observações

- Os caminhos nos scripts de backup (`/home/lucas/...`) são do meu ambiente. Ajuste para o seu.
- - Os scripts passam no ShellCheck, exceto avisos informativos e de estilo: `SC1091` e `SC2153` (o `source` do arquivo de segredos e as variáveis vindas dele) e `SC2181` (uso do `$?`, mantido de propósito por clareza).
- Credenciais que apareceram em capturas de tela durante o desenvolvimento foram revogadas e recriadas.

## Próximos passos

- Agendar os scripts com `cron`.
- Restringir a política IAM do backup a um único bucket (hoje usa `AmazonS3FullAccess`).
