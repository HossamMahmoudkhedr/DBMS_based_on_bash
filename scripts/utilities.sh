#!/bin/bash

checkTable(){
    local TABLE=$1
    
    if [ -f "$PATHTODB/$CURRDATABASE/$TABLE" ]; then
        return 0
    else
        return 1
    fi
}