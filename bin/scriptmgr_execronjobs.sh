#!/bin/bash
set -x

# - preload
cd $(echo $0 | sed -E "s|$(basename $0)||")
. ../conf/scriptmgr_manager.conf

# - bibliotecas
. ${EM_LIB}/general_log
. ${EM_LIB}/general_fun

# - variaveis de ambiente
_carrega_confs ${EM_CONF}/scriptmgr_manager.conf
_carrega_confs ${EM_LIB}/general_var

# - executa os trabalhos
_executa_agendamentos ${1}
