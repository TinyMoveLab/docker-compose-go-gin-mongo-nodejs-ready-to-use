#!/bin/sh

projectname=$(basename "$PWD")

RED='\033[0;31m'
YEL='\033[1;33m'
GRE='\033[0;32m'      
NC='\033[0m'
BGBK='\033[30m\033[107m'
TXB='\033[1m'


if [ $1 = "deploy" ]
then 
	echo "\n${projectname} ${GRE}deploy${NC}" &&
	./start.sh docker-setup &&
	rm -rf letsencrypt/ &&
	./start.sh start production
elif [ $1 = "start" ]
then 
	if [ $2 = "development" ]
	then
		echo "\n${projectname} ${GRE}start${NC} ${BGBK}development${NC}\n" &&
		docker-compose -f dev.yml up -d
	elif [ $2 = "production" ]
	then
		echo "\n${projectname} ${GRE}start${NC} ${TXB}production${NC}\n" &&
		docker-compose -f pro.yml up -d 
	fi
elif [ $1 = "logs" ]
then
	if [ $2 = "development" ]
	then
		echo "\n${projectname} ${YEL}logs${NC} ${BGBK}development${NC}\n" &&
		docker-compose -f dev.yml logs -f

	elif [ $2 = "production" ]
	then
		echo "\n${projectname} ${YEL}logs${NC} ${TXB}production${NC}\n" &&
		docker-compose -f pro.yml logs -f
	fi
elif [ $1 = "stop" ]
then
	if [ $2 = "development" ]
	then
		echo "\n${projectname} ${RED}stop${NC} ${BGBK}development${NC}\n" &&
		docker-compose -f dev.yml down &&
		docker rmi $(docker images --format "{{.Repository}}" | grep ${projectname}_)

	elif [ $2 = "production" ]
	then
		echo "\n${projectname} ${RED}stop${NC} ${TXB}production${NC}\n" &&
		docker-compose -f pro.yml down &&
		docker rmi $(docker images --format "{{.Repository}}" | grep ${projectname})
	fi
elif [ $1 = "sld" ]
then
	echo "\n${projectname} ${GRE}start${NC} + ${YEL}logs${NC} + ${BGBK}development${NC}\n" 
	./start.sh start development &&
	./start.sh logs development
elif [ $1 = "slp" ]
then
	echo "\n${projectname} ${GRE}start${NC} + ${YEL}logs${NC} + ${TXB}production${NC}\n" 
	./start.sh start production &&
	./start.sh logs production
elif [ $1 = "help" ]
then
	echo "" &&
	echo "./start.sh ${GRE}start${NC} ${BGBK}development${NC}" &&
	echo "./start.sh ${GRE}start${NC} ${TXB}production${NC}" &&
	echo "./start.sh ${YEL}logs${NC} ${BGBK}development${NC}" &&
	echo "./start.sh ${YEL}logs${NC} ${TXB}production${NC}" &&
	echo "./start.sh ${RED}stop${NC} ${BGBK}development${NC}" &&
	echo "./start.sh ${RED}stop${NC} ${TXB}production${NC}\n" &&

	echo "./start.sh ${GRE}s${NC}${YEL}l${NC}${BGBK}d${NC}" &&
	echo "\t^ = ${GRE}start${NC} + ${YEL}logs${NC} + ${BGBK}development${NC}" &&
	echo "" &&
	echo "./start.sh ${GRE}s${NC}${YEL}l${NC}${TXB}p${NC}" &&
	echo "\t^ = ${GRE}start${NC} + ${YEL}logs${NC} + ${TXB}production${NC}" &&
	echo ""

	echo "./start.sh ${GRE}deploy${NC}" &&
	echo "\t^ = ${RED}SETUP${NC} ${TXB}docker-compose on digitalocean${NC} and${NC}" &&
	echo "\t    ${GRE}start${NC} + ${TXB}production${NC}" &&
	echo ""
fi
