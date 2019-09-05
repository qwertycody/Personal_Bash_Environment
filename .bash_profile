#!/bin/bash
FILE_BASH_PROFILE="$HOME/.bash_profile"
FILE_BASH_PROFILE_PRIVATE="$HOME/.bash_profile_private"
FILE_ENVIRONMENT_CONFIG="$HOME/environmentConfig.sh"
SCRIPTS="$HOME/scripts"

BASH_PROFILE_FILE_LIST=( "$FILE_BASH_PROFILE" "$FILE_BASH_PROFILE_PRIVATE" "$FILE_ENVIRONMENT_CONFIG" )

function pkill(){
	wmic Path win32_process Where "CommandLine Like '%$2%'" Call Terminate
}

function open_Program()
{
	DIR=$(dirname "${1}")
	cd "$DIR"
	start "" "$1"
}

function misc_search_activeDirectory()
{
	start "" "Rundll32" dsquery.dll OpenQueryWindow
}

function open_Here()
{
	start .
}

function misc_tomcat_start()
{
	cd "$1"
	cd bin
	sh startup.sh
	misc_tomcat_tail "$1"
}

function misc_tomcat_stop()
{
	cd "$1"
	cd bin
	sh shutdown.sh
	misc_tomcat_tail "$1"
}

function open_Docker()
{
   sh "/c/Program Files/Docker Toolbox/start.sh"
}

function misc_tomcat_tail()
{
	cd "$1"
	cd logs
	tail -f catalina.out
}

function open_Eclipse()
{
	open_Program "$ECLIPSE_PATH"
}

function open_SqlDeveloper()
{
	open_Program "$SQLDEVELOPER_PATH"
}

function vscode_open_file()
{
	start "" "$VSCODE_PATH" "$1"
}

function vscode_open_directory()
{
	DIRECTORY_TO_OPEN="$1"

	if [ -z "$1" ]; then
		DIRECTORY_TO_OPEN=$(pwd)
	fi

	start "" "$VSCODE_PATH" "$DIRECTORY_TO_OPEN"
}

function switchTo_privateScripts()
{
	cd "$PRIVATE_SCRIPTS"
}

function switchTo_scripts()
{
	cd "$SCRIPTS"
}

function help()
{
	for file in "${BASH_PROFILE_FILE_LIST[@]}"
	do
		commandsToOutput+=$(cat "$file" | grep "function " | sed 's/function //' | sed 's/{//' | sed 's/}//' |sed 's/()//' | grep -v ".bash_profile")
		commandsToOutput+="\n"
	done

	echo "################################"
	echo "##### Available Functions: #####"
	echo "################################"
	
	printf "$commandsToOutput" | sort
}

function misc_Setup_Environment()
{
	if [ ! -f "$FILE_ENVIRONMENT_CONFIG" ]; then
		touch "$FILE_ENVIRONMENT_CONFIG"
	fi

	if [ ! -d "$SCRIPTS" ]; then
		mkdir "$SCRIPTS"
	fi

	PATH="$PATH:$SCRIPTS"

	#Create Private Bash File if Doesn't Exist and Seed with Variables
	if [ ! -f "$FILE_BASH_PROFILE_PRIVATE" ]; then
		touch "$FILE_BASH_PROFILE_PRIVATE"
		echo '#!/bin/bash' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo '' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PRIVATE_SCRIPTS="$HOME/private_scripts"' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PATH="$PATH:$PRIVATE_SCRIPTS"' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo '' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PROXY_ADDRESS=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PROXY_PORT=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PROXY_BYPASS=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo '' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'ECLIPSE_PATH=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'SQLDEVELOPER_PATH=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'VSCODE_PATH=""' >> "$FILE_BASH_PROFILE_PRIVATE"
	fi

	for file in "${BASH_PROFILE_FILE_LIST[@]}"
	do
		if [ "$file" != "$FILE_BASH_PROFILE" ]; then
			source "$file"
		fi
	done
}

misc_Setup_Environment
help
