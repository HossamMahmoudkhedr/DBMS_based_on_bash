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
	echo "Create Database"
}

## list databases
listDatabases(){
	echo "List Databases"
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

displayDatabaseMenu
