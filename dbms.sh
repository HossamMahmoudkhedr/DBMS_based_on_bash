#!/bin/bash


## Global Variables
CURRDATABASE=""
PATHTODB="databases"

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
								echo "Connect to database selected"
								connectToDatabase
                                ;;
                        4)
								echo "Drop database selected"
                                dropDatabase
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

## For display operations on the database
displayDatabaseMenu(){
	
	options=("Create Table" "List Tables" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Update Table" "Disconnect Database" "Exit")

	while true; do
	for i in "${!options[@]}"
	do
		printf "%d) %s\n" $((i + 1)) "${options[i]}"
	done

	read -p "Please select an option (type the number)> " option
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
				disconnect
				;;
			9)
				exit 0
				;;
			*)
				echo "Invalid choice try again!"
				;;
	esac
	done
	
}


## ********************** For manipulating databases **********************
## create database
createDatabase(){
	if [[ ! -d "$PATHTODB" ]]; then
		mkdir "$PATHTODB"
	fi
	read -p "Enter the new database name -> " dname
	if [[ -z $dname ]]; then
		echo "Database name cannot be empty" 
		return 
	fi
	if [[ -d "$PATHTODB/$dname" ]]; then
		echo "Databe $dname is exists"
	else
		mkdir "$PATHTODB/$dname"
		echo "Database created"
	fi

}

## list databases
listDatabases(){
	 ls -1 $PATHTODB/ | sed 's|^$PATHTODB/||'
}

## drop database
dropDatabase(){
	local db_name=""
	read -p "Enter the name of the database: " db_name
	if [ -d "$PATHTODB/$db_name" ]; then
		rm -r "$PATHTODB/$db_name"
		echo "Database deleted successfully!"
	else
		echo "Database doesn't exist"
	fi

}

## connect to datbase
connectToDatabase(){
	local db_name=""
	read -p "Enter the name of the database -> " db_name
	if [ -d "$PATHTODB/$db_name/" ]; then
		CURRDATABASE="$db_name"
		printf "\nConnected successfully to $CURRDATABASE\n"
		displayDatabaseMenu
	else
		echo "This database doesn't exist"
	fi
}



## ********************** For manupulating tables ************************
## create table
createTable(){
    local tb_name=""
    read -p "Enter the name of the table -> " tb_name

    # Check if the table already exists
    if [ -f "$PATHTODB/$CURRDATABASE/$tb_name" ]; then
        echo "This table already exists"
    elif [ -z "$tb_name" ]; then
        echo "Empty table name!"
    else
        # Create the table file
        touch "$PATHTODB/$CURRDATABASE/$tb_name"
        local columns=()
        echo "Enter columns (Write 'exit' to stop)"
        
        while true; do
            local column=""
            read -p "Enter column name: " column

            # Exit the loop
            if [[ ${column,,} == "exit" ]]; then
                break
            fi
            
			PS3="Choose the data type: "
            select datatype in "integer" "string" "boolean" "float" "character"; do
				case $REPLY in
					1)
						column+=":int"
						break
						;;
					2)
						column+=":string"
						break
						;;
					3)
						column+=":boolean"
						break
						;;
					4)
						column+=":float"
						break
						;;
					5)
						column+=":char"
						break
						;;
					*)
						echo "Invalid data type"
						continue
						;;
				esac
			done

            PS3="Allow null values? "
            select choice in "Null" "Not null"; do
                case $REPLY in
                    1)
                        column+=":null"
                        break
                        ;;
                    2)
                        column+=":notNull"
                        break
                        ;;
                    *)
                        echo "Invalid choice, try again."
                        ;;
                esac
            done

            PS3="Allow unique values? "
            select choice in "Unique" "Not Unique"; do
                case $REPLY in
                    1)
                        column+=":unique"
                        break
                        ;;
                    2)
                        column+=":notUnique"
                        break
                        ;;
                    *)
                        echo "Invalid choice, try again."
                        ;;
                esac
            done


			columns+=("$column")
			echo ${columns[@]}			
        done
			

		PS3="Which one of the columns is the primary key? -> "
		select choice in "${columns[@]}"; do
    		if [[ -n $choice ]]; then
        		for i in "${!columns[@]}"; do
            		if [[ $REPLY -eq $((i + 1)) ]]; then
						# Append (PK) to the selected column
						# columns[$i]=$(echo "${columns[$i]}" | sed -E 's/(:[a-zA-Z]+)(:)/\1(PK)\2/')
						columns[$i]="${columns[$i]/:/:PK:}"
						echo "Primary key set to: ${columns[$i]}"
						break 2
            		fi
        		done
    		else
        	echo "Invalid choice, please try again."
    		fi
		done
		echo ${columns[@]} > $PATHTODB/$CURRDATABASE/$tb_name
    fi
}

## list tables
listTables(){
	ls -1 $PATHTODB/$CURRDATABASE | sed 's|^$PATHTODB/$CURRDATABASE||'
}

## drop table
dropTable(){
	local table_name=""
	read -p "Enter the name of the table: " table_name
	if [ -f "$PATHTODB/$CURRDATABASE/$table_name" ]; then
		rm  "$PATHTODB/$CURRDATABASE/$table_name"
		echo "Table deleted successfully!"
	else
		echo "Table doesn't exist"
	fi
}

## insert into table
##id:PK:int:notNull:unique 
insertIntoTable(){
	local table_name="";
	read -p "Enter table name -> " table_name
	if [ ! -f "PATHTODB/$CURRDATABASE/$table_name" ]; then
		echo "Table not found"
	else
		local meta_data=($(head -n 1 "$PATHTODB/$CURRDATABASE/$tb_name"))
		local row=()
		for s_coulmn in "${meta_data[@]}"; do
			local col_name=$(echo $s_coulmn | cut -d':' -f1)
			local col_type=$(echo $s_coulmn | cut -d':' -f2)
			local col_defult=$(echo $s_coulmn | cut -d':' -f3)
			local col_stutas=$(echo $s_coulmn | cut -d':' -f4)
			local col_pk=$(echo $s_coulmn | grep -o ":PK")
			
		done 
	fi
	$column[@] < $PATHTODB/$CURRDATABASE/$tb_name

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
	echo "Disconnected from $CURRDATABASE"
	displayMainMenu
	$CURRDATABASE=""
}

displayMainMenu

