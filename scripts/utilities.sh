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