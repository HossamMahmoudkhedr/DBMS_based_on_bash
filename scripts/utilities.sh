#!/bin/bash

checkTable(){
    local TABLE=$1
    
    if [ -f "$PATHTODB/$CURRDATABASE/$TABLE" ]; then
        return 0
    else
        return 1
    fi
}

chooseDataType(){
    local choice
    
    select item in "integer" "string" "boolean" "float" "character"; do
			case $REPLY in
				1)
					choice+=":int"
					break
					;;
				2)
					choice+=":string"
					break
					;;
				3)
					choice+=":boolean"
					break
					;;
				4)
					choice+=":float"
					break
					;;
				5)
					choice+=":char"
					break
					;;
				*)
					echo "Invalid data type"
					continue
					;;
			esac
		done
    echo $choice
}
checkDataType()
{
	local col_type=$1
	local value=$2
	case $col_type in 
		int)
		if ! [[ $value =~ ^[0-9]+$ ]]; then
			echo "Invalid integer value. Try again."
			return 1
		fi
		;;
		float)
		if ! [[ $value =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
			echo "Invalid float value. Try again."
			return 1
		fi
		;;
		boolean)
		if ! [[ $value =~ ^(true|false)$ ]]; then
			echo "Invalid boolean value (true/false). Try again."
			return 1
		fi
		;;
		string|char)
		# Strings are generally valid without additional checks
		if [[ $col_type == "char" && ${#value} -ne 1 ]]; then
			echo "Invalid character value. Enter a single character."
			return 1
		fi
		;;
	esac
}