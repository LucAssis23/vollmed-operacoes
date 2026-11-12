#! /bin/bash

source "$HOME/.config/vollmed/alertas.env"
codigo_http=$(curl --write-out '%{http_code}' --silent --output /dev/null "$API_URL" --connect-timeout 5) 

if [ "$codigo_http" -ne 200 ]; then
	remetente=$REMETENTE
	destinatario=$DESTINATARIO
	assunto="ALERTA: API VollMed fora do ar"
	corpo="Subject: $assunto\n\nA aplicação VollMed retornou o status http ($codigo_http). Favor verificar servidor."

	curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
        --mail-from "$remetente" \
        --mail-rcpt "$destinatario" \
        --user "$remetente:$SMTP_SENHA" \
        -T <(echo -e "$corpo")
fi


