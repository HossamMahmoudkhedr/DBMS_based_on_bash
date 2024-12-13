#!/bin/bash

## For display operations on the database
displayDatabaseMenu(){
	echo "test"
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
		echo "Database $dname is exists"
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
	 echo "test"
}

## connect to datbase
connectToDatabase(){ echo "test"
}


## ********************** For manupulating tables ************************
## create table
createTable(){ echo "test"
}

## list tables
listTables(){ echo "test"
}

## drop table
dropTable(){ echo "test"
}

## insert into table
insertIntoTable(){ echo "test"
}

## select from table
selectFromTable(){ echo "test"
}

## delete from table
deleteFromTable(){ echo "test"
}

## update table
updateTable(){ echo "test"
}

## disconnect form database
disconnect(){ echo "test"
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
