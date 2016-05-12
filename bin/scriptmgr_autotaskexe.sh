#!/bin/bash

# - preload
cd $(echo $0 | sed -E "s|$(basename $0)||")
. ../conf/scriptmgr_manager.conf

# - bibliotecas
. ${EM_LIB}/general_log
. ${EM_LIB}/general_fun

# - variaveis de ambiente
_carrega_confs ${EM_CONF}/scriptmgr_manager.conf
_carrega_confs ${EM_LIB}/general_var

# - cria os links com os servicos desabilitados
_cria_links

# - executa os trabalhos
ARRAY_FILA=(`cd ${EM_RCD}; ls --ignore="cron-*" | grep on | sort -n`)
_executa_tarefas "${ARRAY_FILA[@]}"
