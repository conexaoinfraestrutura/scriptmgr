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

# - cria os links com os servicos desabilitados
_cria_links

# - mensagem para o usuario
_caixa_de_mensagem "$TEXT04_MANUALTASK" "$TEXT05_MANUALTASK"

# - lista dos links instalados no rc.d
ARRAY_PRG=(`cd ${EM_JOB_BIN}; ls *`)

# - montando array de opcoes para o radiolist
COUNT=0
PEGA_OPCOES=""
while [[ ${#ARRAY_PRG[@]} -ne $COUNT ]]; do
	PEGA_OPCOES=$(echo $PEGA_OPCOES; echo `echo ${ARRAY_PRG[$COUNT]}` `echo '#'`)
	let COUNT=$COUNT+1
done

# - montando a tela
_menu_opcoes_individuais "$TEXT01_MANUALTASK" "$PEGA_OPCOES"

if [[ -z $( echo $RET_MENU | grep cron ) ]]; then
	_caixa_de_mensagem "$TEXT02_MANUALTASK" "$TEXT03_MANUALTASK"
	_executa_tarefas ${RET_MENU}
else
	_caixa_de_mensagem "$TEXT02_MANUALTASK" "$TEXT03_MANUALTASK"
	_executa_agendamentos ${RET_MENU}
fi
