#!/bin/bash

source ./scripts/utilities.sh

## Global Variables
CURRDATABASE=""
PATHTODB="databases"

## ********************* For display menus ********************
## For display the main menu
displayMainMenu(){
		
        local mainmenu=("Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit" )
		PS3="Please select an option (type the number)> "
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
                                echo "Invailid choice! Please select number between 1 and 5"
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
		echo ""
        echo "This table already exists"
		echo ""
    elif [ -z "$tb_name" ]; then
		echo ""
        echo "Empty table name!"
    else
        local columns=()
		local pk=""
		local pk_name
		read -p "Enter the primary key name: " pk_name
		pk+="$pk_name"

		echo ""
		PS3="Choose primary key data type: "
		pk+=$(chooseDataType)

			pk+=":notNull:unique:PK"
			
			columns+=("$pk")

		echo ""
        echo "Enter the rest of the columns (Write 'exit' to stop)"
        echo ""
        while true; do
            local column=""
            read -p "Enter column name: " column

            # Exit the loop
            if [[ ${column,,} == "exit" ]]; then
                break
            fi
			PS3="Choose the data type: "

			column+=$(chooseDataType)
			echo ""
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
			echo ""
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

			echo ""
			columns+=("$column")
			PS3="->"			
        done
			
		# Create the table file
        touch "$PATHTODB/$CURRDATABASE/$tb_name"

		echo ${columns[@]} > $PATHTODB/$CURRDATABASE/$tb_name
    fi
}

## list tables
listTables(){
	echo ""
	ls -1 $PATHTODB/$CURRDATABASE | sed 's|^$PATHTODB/$CURRDATABASE||'
	echo ""
}

## drop table
dropTable(){
	local table_name=""
	read -p "Enter the name of the table: " table_name
	if [ -f "$PATHTODB/$CURRDATABASE/$table_name" ]; then
		rm  "$PATHTODB/$CURRDATABASE/$table_name"
		echo ""
		echo "Table deleted successfully!"
		echo ""
	else
		echo ""
		echo "Table doesn't exist"
		echo ""
	fi
}

## insert into table
##id:int:notNull:unique:PK name:string:notNull:notUnique age:int:notNull:notUnique 
insertIntoTable(){
	local table_name=""
	read -p "Enter table name -> " table_name
	if [ ! -f "$PATHTODB/$CURRDATABASE/$table_name" ]; then
		echo ""
		echo "Table not found"
		echo ""
	else
		local meta_data=($(head -n 1 "$PATHTODB/$CURRDATABASE/$table_name"))
		local row=()
		for s_coulmn in "${meta_data[@]}"; do
			local col_name=$(echo $s_coulmn | cut -d':' -f1)
			local col_type=$(echo $s_coulmn | cut -d':' -f2)
			local col_defult=$(echo $s_coulmn | cut -d':' -f3)
			local col_status=$(echo $s_coulmn | cut -d':' -f4)
			local col_pk=$(echo $s_coulmn | grep -o ":PK")
			local value
			while true; do
			echo ""
				read -p "Enetr the value for column $col_name($col_type , $col_defult) -> " value
				if [[ $value == "" ]]; then
					if [[ $col_defult == "notNull" ]]; then
					echo ""
						echo "This column does not allow null values. Please enter a value."
						echo ""
						continue
					fi
				fi
				checkDataType $col_type $value
				if [ $? -eq 1 ]; then
					continue
				fi

				if [[ $col_status == "unique" ]]; then 
					col_index=$(printf "%s\n" "${meta_data[@]}" | grep -nw "$col_name" | cut -d: -f1)
					if [[ -z $col_index ]]; then
						echo ""
						echo "Error: Could not find the column index for $col_name."
						echo ""
						exit 1
					fi
					col_values=$(awk -F':' -v col_idx="$col_index" '{print $col_idx}' "$PATHTODB/$CURRDATABASE/$table_name")					
					if echo "$col_values" | grep -qx "$value"; then
						if [[ -n $col_pk ]]; then
						echo ""
							echo "Primary key must be unique. Try another."
							echo ""
						else
						echo ""
							echo "Column value must be unique. Try another."
							echo ""
						fi
						continue
					fi
				fi
				# row+=("$value")
				if [ $col_type == "string" ]; then
                    row+=("\"$value\"")
                else
                    row+=("$value")
                fi
				break;
			done
		done
		echo ""
		echo "$(IFS=:; echo "${row[*]}")" >> "$PATHTODB/$CURRDATABASE/$table_name"
    	echo "Row inserted successfully!"
		echo ""
	fi
}

## select from table
selectFromTable(){
	local tb_name
	read -p "Enter the table name -> " tb_name
	
	checkTable $tb_name

	if [ $? -eq 0 ];then
		local ID
		local meta=()
		read -p "Enter the id value -> " ID
		meta=($(head -n 1 "$PATHTODB/$CURRDATABASE/$tb_name"))
		for ((i = 0; i < ${#meta[@]}; i++)); do
			col_name="${meta[$i]}"
			if [[ $i -eq $((${#meta[@]} - 1)) ]]; then
				echo $col_name | awk -F: '{printf "%s\n", $1}'
			else
				echo $col_name | awk -F: '{printf "%s | ", $1}'
			fi
		done
		grep -w "$ID" "$PATHTODB/$CURRDATABASE/$tb_name" | awk -F: '{for(i=1; i<=NF; i++) if(i==NF) print $i; else printf "%s | ", $i}'
	else
		echo ""
		echo "The table dosen't exist"
		echo ""
	fi
}

## delete from table
deleteFromTable(){
	local tb_name
	read -p "Enter the tabel name -> " tb_name
	checkTable $tb_name
	if [ $? -eq 0 ];then
		
		local col_name  
		local line_num
		local pk=""
		local  -i index=1
		local meta_data=($(head -n 1 "$PATHTODB/$CURRDATABASE/$tb_name"))
		for data in "${meta_data[@]}"; do
			index=$((index + 1))
			pk=($(echo $data | grep -o ":PK"))
			if [[ $pk != ""  ]]; then
				col_name=($(echo $data | cut -d':' -f1))
				break
			fi
		done
		local primary_key
		read -p "Enter the ${col_name} -> " primary_key
		local rnum=($(grep -nw "$primary_key" $PATHTODB/$CURRDATABASE/$tb_name ))
		if [ ${#rnum[@]} -ne 0 ]; then
			for line in "${rnum[@]}";do

			local line_num=$(echo "$line" | awk -F: '{print $1}')
			local primary=$(echo "$line" | awk -F: -v idx="$index" '{print $idx}')

			
			if [[ "$primary" -eq "$primary_key" ]]; then
				local decision
				
				while true; do
				read -p "Are you sure to delete the row with id = $primary_key (y or n) -> " decision
				if [ $decision == "y" ];then
					sed -i "${line_num}d" "$PATHTODB/$CURRDATABASE/$tb_name"
					echo "The row has been deleted successfully!"
					break
				elif [ $decision == "n" ]; then
					break
				fi
				done
			fi
			done
		else
			# echo "$primary_key Not Found!"
			echo "There is no value of $col_name equals $primary_key"
		fi
	else
		echo "Table Not Found!"
	fi
}

## update table
updateTable(){
	local tb_name
	read -p "Enter the tabel name -> " tb_name
	checkTable $tb_name
	if [ $? -eq 0 ];then
		
		local col_name  
		local line_num
		local pk=""
		local  -i index=1
		local meta_data=($(head -n 1 "$PATHTODB/$CURRDATABASE/$tb_name"))
		for data in "${meta_data[@]}"; do
			index=$((index + 1))
			pk=($(echo $data | grep -o ":PK"))
			if [[ $pk != ""  ]]; then
				col_name=($(echo $data | cut -d':' -f1))
				break
			fi
		done
		local primary_key
		read -p "Enter the ${col_name} -> " primary_key
		local rnum=($(grep -nw "$primary_key" $PATHTODB/$CURRDATABASE/$tb_name ))
		if [ ${#rnum[@]} -ne 0 ]; then
			for line in "${rnum[@]}";do

			local line_num=$(echo "$line" | awk -F: '{print $1}')
			local primary=$(echo "$line" | awk -F: -v idx="$index" '{print $idx}')
			if [[ "$primary" -eq "$primary_key" ]]; then
				local decision
				local col_number
				local value
				local column
				local new_value
				echo ""
				PS3="Which one of the column name to update -> "
				select choice in "${meta_data[@]:1}"; do
					if [[ -n $choice ]]; then
					echo "This is the line to be modified -> $line"
						for i in "${!meta_data[@]}"; do
							if [[ $REPLY -eq $((i + 1)) ]]; then
								col_number=$(($REPLY+2))
								column=${meta_data[$i+1]}
								value=$(echo $line | awk -F: -v col="$col_number" '{print $col}')	
								break														
							fi
						done
						if [[ -n $column && -n $value ]]; then
							echo ""
							echo "$column = $value"
							echo ""
							break
						fi
					else
					echo ""
					echo "Invalid choice, please try again."
					echo ""
					fi
				done 
				while true; do
				local col_name=$(echo $column | cut -d':' -f1)
				local col_type=$(echo $column | cut -d':' -f2)
				local col_defult=$(echo $column | cut -d':' -f3)
				local col_status=$(echo $column | cut -d':' -f4)
				
				read -p "Are you sure to update the row with id = $primary_key (y or n) -> " decision
				echo ""
				if [ $decision == "y" ];then
					while true; do
						read -p "Enter the new value -> " new_value

							if [[ $new_value == "" ]]; then
								if [[ $col_defult == "notNull" ]]; then
									echo "This column does not allow null values. Please enter a value."
									continue
								fi
							fi

							checkDataType $col_type $new_value
							if [ $? -eq 1 ]; then
								continue
							fi
					
							if [[ $col_status == "unique" ]]; then 
								col_index=$(printf "%s\n" "${meta_data[@]}" | grep -nw "$col_name" | cut -d: -f1)
								if [[ -z $col_index ]]; then
									echo "Error: Could not find the column index for $col_name."
									exit 1
								fi
								col_values=$(awk -F':' -v col_idx="$col_index" '{print $col_idx}' "$PATHTODB/$CURRDATABASE/$table_name")					
								if echo "$col_values" | grep -qx "$new_value"; then
									echo "Column value must be unique. Try another."
									continue
								fi
							fi
							
							if [ $col_type == "string" ]; then
								new_value="\"$new_value\""
							fi
							break 
							done
							
							sed -i "${line_num}s/$value/$new_value/" "$PATHTODB/$CURRDATABASE/$tb_name"
							echo "Done"
							echo ""
							break
						
						
				elif [ $decision == "n" ]; then
					
					break
				fi
				done
			fi
			done
		else
			echo ""
			echo "There is no value of $col_name equals $primary_key"
			echo ""
		fi
	else
		echo ""
		echo "Table Not Found!"
		echo ""
	fi
}

## disconnect form database
disconnect(){
	echo ""
	echo "Disconnected from $CURRDATABASE"
	echo ""
	displayMainMenu
	$CURRDATABASE=""
}

displayMainMenu

