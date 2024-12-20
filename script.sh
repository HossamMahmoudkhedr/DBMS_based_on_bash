#!/bin/bash

## Global Variables
CURRDATABASE=""
PATHTODB="databases"

# Ensure the database path exists
mkdir -p "$PATHTODB"

## Helper functions
display_error() {
    zenity --error --text="$1"
}

display_info() {
    zenity --info --text="$1"
}

get_input() {
    zenity --entry --text="$1"
}

display_menu() {
    zenity --list --radiolist --column="Select" --column="Option" \
        FALSE "$1" FALSE "$2" FALSE "$3" FALSE "$4" FALSE "$5" \
        FALSE "$6" FALSE "$7" --text="$8" --height=400
}

## Database operations
createDatabase() {
    local dname
    dname=$(get_input "Enter the new database name:")
    if [[ -z $dname ]]; then
        display_error "Database name cannot be empty."
        return
    fi
    if [[ -d "$PATHTODB/$dname" ]]; then
        display_error "Database '$dname' already exists."
    else
        mkdir "$PATHTODB/$dname"
        display_info "Database '$dname' created successfully."
    fi
}

listDatabases() {
    databases=$(ls -1 "$PATHTODB" 2>/dev/null)
    if [[ -z $databases ]]; then
        display_error "No databases found."
    else
        zenity --info --text="Databases:\n$databases"
    fi
}

dropDatabase() {
    local db_name
    db_name=$(get_input "Enter the database name to delete:")
    if [[ -d "$PATHTODB/$db_name" ]]; then
        rm -rf "$PATHTODB/$db_name"
        display_info "Database '$db_name' deleted successfully."
    else
        display_error "Database '$db_name' does not exist."
    fi
}

connectToDatabase() {
    local db_name
    db_name=$(get_input "Enter the database name to connect to:")
    if [[ -d "$PATHTODB/$db_name" ]]; then
        CURRDATABASE="$db_name"
        display_info "Connected to database '$CURRDATABASE'."
        displayDatabaseMenu
    else
        display_error "Database '$db_name' does not exist."
    fi
}

## Table operations
createTable() {
    local tb_name
    tb_name=$(get_input "Enter the table name:")
    if [[ -z $tb_name ]]; then
        display_error "Table name cannot be empty."
        return
    fi
    if [[ -f "$PATHTODB/$CURRDATABASE/$tb_name" ]]; then
        display_error "Table '$tb_name' already exists."
        return
    fi
    schema=$(get_input "Enter table schema (column1 type1, column2 type2, ...):")
    if [[ -z $schema ]]; then
        display_error "Schema cannot be empty."
        return
    fi
    echo "$schema" > "$PATHTODB/$CURRDATABASE/$tb_name"
    display_info "Table '$tb_name' created with schema:\n$schema"
}

listTables() {
    tables=$(ls -1 "$PATHTODB/$CURRDATABASE" 2>/dev/null)
    if [[ -z $tables ]]; then
        display_error "No tables found in the database."
    else
        zenity --info --text="Tables:\n$tables"
    fi
}

dropTable() {
    local table_name
    table_name=$(get_input "Enter the table name to delete:")
    if [[ -f "$PATHTODB/$CURRDATABASE/$table_name" ]]; then
        rm "$PATHTODB/$CURRDATABASE/$table_name"
        display_info "Table '$table_name' deleted successfully."
    else
        display_error "Table '$table_name' does not exist."
    fi
}

insertIntoTable() {
    local table_name
    table_name=$(get_input "Enter the table name to insert data into:")
    if [[ ! -f "$PATHTODB/$CURRDATABASE/$table_name" ]]; then
        display_error "Table '$table_name' does not exist."
        return
    fi
    data=$(get_input "Enter data to insert (e.g., value1,value2,...):")
    if [[ -z $data ]]; then
        display_error "Data cannot be empty."
        return
    fi
    echo "$data" >> "$PATHTODB/$CURRDATABASE/$table_name"
    display_info "Data inserted into table '$table_name'."
}

selectFromTable() {
    local table_name
    table_name=$(get_input "Enter the table name to select data from:")
    if [[ ! -f "$PATHTODB/$CURRDATABASE/$table_name" ]]; then
        display_error "Table '$table_name' does not exist."
        return
    fi
    data=$(cat "$PATHTODB/$CURRDATABASE/$table_name")
    zenity --info --text="Data in '$table_name':\n$data"
}

deleteFromTable() {
    local table_name
    table_name=$(get_input "Enter the table name to delete data from:")
    if [[ ! -f "$PATHTODB/$CURRDATABASE/$table_name" ]]; then
        display_error "Table '$table_name' does not exist."
        return
    fi
    data=$(get_input "Enter data to delete (e.g., value1,value2,...):")
    if grep -q "$data" "$PATHTODB/$CURRDATABASE/$table_name"; then
        sed -i "/$data/d" "$PATHTODB/$CURRDATABASE/$table_name"
        display_info "Data deleted from table '$table_name'."
    else
        display_error "Data not found in table '$table_name'."
    fi
}

## Menus
displayMainMenu() {
    while true; do
        choice=$(display_menu \
            "Create Database" \
            "List Databases" \
            "Connect to Database" \
            "Drop Database" \
            "Exit" \
            "" "" \
            "Main Menu")
        case $choice in
            "Create Database") createDatabase ;;
            "List Databases") listDatabases ;;
            "Connect to Database") connectToDatabase ;;
            "Drop Database") dropDatabase ;;
            "Exit") exit ;;
            *) display_error "Invalid choice!" ;;
        esac
    done
}

displayDatabaseMenu() {
    while true; do
        choice=$(display_menu \
            "Create Table" \
            "List Tables" \
            "Drop Table" \
            "Insert into Table" \
            "Select from Table" \
            "Delete from Table" \
            "Disconnect Database" \
            "Database Menu")
        case $choice in
            "Create Table") createTable ;;
            "List Tables") listTables ;;
            "Drop Table") dropTable ;;
            "Insert into Table") insertIntoTable ;;
            "Select from Table") selectFromTable ;;
            "Delete from Table") deleteFromTable ;;
            "Disconnect Database") CURRDATABASE=""; return ;;
            *) display_error "Invalid choice!" ;;
        esac
    done
}

## Start the program
displayMainMenu
