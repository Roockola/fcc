#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ ! $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ "$1" =~ ^[0-9]+$ ]]
      then
        ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
      else
        ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
    fi

    if [[ -z $ELEMENT ]]
      then
        echo  "I could not find that element in the database."
      else
        RES=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types using(type_id) WHERE atomic_number = $ELEMENT")
        echo $RES | while IFS='|' read atno name sym mass mpc bpc type; do
          echo "The element with atomic number $atno is $name ($sym). It's a $type, with a mass of $mass amu. $name has a melting point of $mpc celsius and a boiling point of $bpc celsius."
        done
    fi
   #echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius." 
fi