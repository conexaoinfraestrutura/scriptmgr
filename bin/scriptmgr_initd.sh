#!/bin/bash

# - preload
cd $(echo $0 | sed -E "s|$(basename $0)||")
. ../conf/scriptmgr_manager.conf

# - bibliotecas
. ${EM_LIB}/general_dia
. ${EM_LIB}/general_fun
. ${EM_LIB}/general_tex

# - variaveis de ambiente
_carrega_confs ${EM_CONF}/scriptmgr_manager.conf

# - cria os links com os servicos desabilitados
_cria_links

# - lista dos links instalados no rc.d
ARRAY_ENB=(`cd ${EM_RCD}; ls * | sort -n`)

# - montando array de opcoes para o radiolist
COUNT=0
PEGA_OPCOES=""
while [[ ${#ARRAY_ENB[@]} -ne $COUNT ]]; do
	PEGA_OPCOES=$(echo $PEGA_OPCOES; echo `echo ${ARRAY_ENB[$COUNT]} | cut -d '-' -f 1` `echo ${ARRAY_ENB[$COUNT]} | cut -d '-' -f 2` `echo ${ARRAY_ENB[$COUNT]} | cut -d '-' -f 3`)
	let COUNT=$COUNT+1
done

# - montando a tela
_radiolist_opcoes_multiplas "$TEXT01_INITRD" "$PEGA_OPCOES"

# - obtendo as opcoes selecionadas pelo usuario
LN_ESCOLHAS=(`echo $RET_RADIOLIST`)

# - aplicando as configuracoes selecionadas
# - primeiro desligamos todos os servicos
cd ${EM_RCD}
ls * | while read -r LINHA; do
	mv `echo $LINHA | cut -d '-' -f 1`-`echo $LINHA | cut -d '-' -f 2`-`echo $LINHA | cut -d '-' -f 3` `echo $LINHA | cut -d '-' -f 1`-`echo $LINHA | cut -d '-' -f 2`-off > /dev/null 2>&1
done

# - entao habilitamos o que foi selecionado pelo usuario
for ESCOLHAS in ${LN_ESCOLHAS[@]}; do
	ls * | while read -r LINHA; do
		if [[ `echo $LINHA | cut -d '-' -f 1` == $ESCOLHAS ]]; then
			mv `echo $LINHA | cut -d '-' -f 1`-`echo $LINHA | cut -d '-' -f 2`-`echo $LINHA | cut -d '-' -f 3` `echo $LINHA | cut -d '-' -f 1`-`echo $LINHA | cut -d '-' -f 2`-on > /dev/null 2>&1
		fi
	done
done
