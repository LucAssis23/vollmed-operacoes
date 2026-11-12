#! /bin/bash


CAMINHO_RESTORE=/home/lucas/restore-aws
CAMINHO_CNF=/home/lucas/backups/.my.cnf

aws s3 sync "s3://vollmed/$1" "$CAMINHO_RESTORE"

cd "$CAMINHO_RESTORE" || exit
if [ -f "$2.sql" ]; then
	mysql --defaults-extra-file="$CAMINHO_CNF" vollmed_db < "$2.sql"
	if [ $? -eq 0 ]; then
		echo "Os dados foram restaurados com sucesso!"
	else
		echo "Houve um erro durante a restauração de dados."
	fi
else
	echo "O arquivo procurado não existe no diretório"
fi
