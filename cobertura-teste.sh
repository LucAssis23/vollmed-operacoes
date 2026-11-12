#! /bin/bash

source "$HOME/.config/vollmed/alertas.env"
PROJECT_KEY="LucAssis23_vollmed-api"
COVERAGE_THRESHOLD=80

SONAR_API_URL="https://sonarcloud.io/api/measures/search_history?metrics=coverage&component=$PROJECT_KEY"

cobertura=$(curl -s -u "${SONAR_TOKEN}:" "$SONAR_API_URL" | jq -r '.measures[0].history | map(select(.value != null)) | sort_by(.date) | last | .value')

if (( $(echo "$cobertura < $COVERAGE_THRESHOLD" | bc -l) )); then
	remetente=$REMETENTE
	destinatario=$DESTINATARIO
	assunto="ALERTA: Cobertura de teste baixa"
	corpo="Subject: $assunto\n\nA cobertura de teste do projeto é inferior a ${COVERAGE_THRESHOLD}%. Por favor, verifique o SonarCloud para mais detalhes."

	curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
		--mail-from "$remetente" \
		--mail-rcpt "$destinatario" \
		--user "$remetente:$SMTP_SENHA" \
		-T <(echo -e "$corpo")
fi

