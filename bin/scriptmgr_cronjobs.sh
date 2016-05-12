#!/bin/bash

# - preload
cd $(echo $0 | sed -E "s|$(basename $0)||")
. ../conf/scriptmgr_manager.conf

# - bibliotecas
. ${EM_LIB}/general_log
. ${EM_LIB}/general_fun
. ${EM_LIB}/general_tex
. ${EM_LIB}/general_dia

# - variaveis de ambiente
_carrega_confs ${EM_CONF}/scriptmgr_manager.conf
_carrega_confs ${EM_LIB}/general_var

# - lista dos links instalados no rc.d
ARRAY_PRG=(`cd ${EM_JOB_BIN}; ls cron-*`)

# - montando array de opcoes para o radiolist
COUNT=0
PEGA_OPCOES=""
while [[ ${#ARRAY_PRG[@]} -ne $COUNT ]]; do
	PEGA_OPCOES=$(echo $PEGA_OPCOES; echo `echo ${ARRAY_PRG[$COUNT]} | cut -d '-' -f 2` `echo ${ARRAY_PRG[$COUNT]} | cut -d '-' -f 3`)
	let COUNT=$COUNT+1
done

# - montando a tela de selecao do agendamento
_menu_opcoes_individuais "$TEXT01_CRONJOB" "$PEGA_OPCOES"

# - montando a tela de configuracao da frequencia de agendamento
_caixa_de_mensagem "$TEXT02_CRONJOB" "$TEXT03_CRONJOB"

# - montando a tela de selecao de frequencia do agendamento
_caixa_de_entrada "$TEXT04_CRONJOB $RET_MENU" ""

if [[ -z "$RET_INPUT" ]]; then
	# - desabilitando a rotina conforme usuario
	_caixa_de_mensagem "$TEXT05_CRONJOB" "$TEXT06_CRONJOB ${RET_MENU}"
	rm -f /etc/cron.d/${RET_MENU} > /dev/null 2>&1
	mv ${EM_JOB_BIN}/cron-${RET_MENU}-on ${EM_JOB_BIN}/cron-${RET_MENU}-off > /dev/null 2>&1
else
	if [ $RET_INPUT -gt 60 ]; then
		# - caso seja superior a uma hora nao agendamos
		_caixa_de_mensagem "$TEXT07_CRONJOB" "$TEXT08_CRONJOB"
		exit
	else
		# - habilitando agendamento
		echo "MAILTO=" > /etc/cron.d/$RET_MENU
		echo "*/$RET_INPUT * * * * root (${EM_BIN}/scriptmgr_execronjobs.sh cron-$RET_MENU-on > /dev/null 2>&1)" >> /etc/cron.d/$RET_MENU
		chmod 644 /etc/cron.d/$RET_MENU
		mv ${EM_JOB_BIN}/cron-${RET_MENU}-off ${EM_JOB_BIN}/cron-${RET_MENU}-on > /dev/null 2>&1
	fi
fi
