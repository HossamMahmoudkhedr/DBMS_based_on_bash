#!/bin/bash


## Global Variables
CURRDATABASE=""

## ********************* For display menus ********************
## For display the main menu
displayMainMenu(){
	echo "Display Main"
}

## For display operations on the database
displayDatabaseMenu(){
	local PS3="Please select an option (type the number)> "
	options=("Create Table" "List Tables" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Update Table" "Exit")

	for i in "${!options[@]}"
	do
		printf "%d) %s\n" $((i + 1)) "${options[i]}"
	done

	read option
		case $option in
			1) 
				createTable
				;;
			2)
					listTables
				;;
			3) 
				dropTable
				;;
			4) 
				insertIntoTable
				;;
			5) 
				selectFromTable
				;;
			6)
				deleteFromTable
				;;
			7)
				updateTable
				;;
			8)
				break
				;;
	esac
	
}


## ********************** For manipulating databases **********************
## create database
createDatabase(){

	
	if [[ ! -d "databases" ]]; then
		mkdir "databases"
	fi
	read -p "Enter the new database name -> " dname
	if [[ -z $dname ]]; then
		echo "Database name cannot be empty" 
		return 
	fi
	if [[ -d "databases/$dname" ]]; then
		echo "Databe $dname is exists"
	else
		mkdir "databases/$dname"
		echo "Database created"
	fi

}

## list databases
listDatabases(){
	 ls -1 databases/ | sed 's|^databases/||'
}

## drop database
dropDatabase(){
	local db_name=""
	read -p "Enter the name of the database: " db_name
	echo $db_name
	if [ -d "databases/$db_name" ]; then
		rm -r "databases/$db_name"
		echo "Database deleted successfully!"
	else
		echo "Database doesn't exist"
	fi

}

## connect to datbase
connectToDatabase(){
	local db_name=""
	read -p "Enter the name of the database" db_name
	if [ -d "databases/db_name" ]; then
		$CURRDATABASE=$db_name
		echo "Connected successfully to $CURRDATABASE"
	else
		echo "This database doesn't exist
	fi
}



## ********************** For manupulating tables ************************
## create table
createTable(){
	echo "Create Table"
}

## list tables
listTables(){
	echo "List Tables"
}

## drop table
dropTable(){
	echo "Drop Table"
}

## insert into table
insertIntoTable(){
	echo "Insert Into Table"
}

## select from table
selectFromTable(){
	echo "Select From Table"
}

## delete from table
deleteFromTable(){
	echo "Delete From Table"
}

## update table
updateTable(){
	echo "Update Table"
}

## disconnect form database
disconnect(){
	echo "Disconnect"
}


## ********************* For display menus ********************
## For display the main menu
displayMainMenu(){
        local mainmenu=("Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit" )
        select choice in "${mainmenu[@]}"; do
                case $REPLY in
                        1)
                                echo "Create Database Selected"
                                createDatabase
                                ;;
                        2)
                                echo "List Database Selected"
				listDatabases
                                ;;
                        3)
                                echo "Connect to Database Selected"
                                ;;
                        4)
                                echo "Drop Database Selected"
                                ;;
                        5)
                                echo "Exit The Program"
                                exit 0
                                ;;
                        *)
                                echo "Invailid choice! Please select number between 1 and ${#mainmenu}"
                                ;;
                esac
        done
}
displayMainMenu

