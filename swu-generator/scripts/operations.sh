#!/bin/bash

# operations.sh - Script to do some operations with inputs

# Verify if a new value is written in configs
verify_input () {
  # Args:
  # $1 - New entry variable
  # $2 - Name of parameter variable
 
 if [ "$1" ]; then eval $2="$1" ; IS_CONFIG_SAVED="false" ; fi
}
# Compare current and new version 
compare_versions () {
  # Args: 
  # $1 - Current version
  # $2 - New version 

  major_current=$(echo $1 | cut -d. -f1)
  major_new=$(echo $2 | cut -d. -f1)
  result="no"

  if [ $major_new  -gt $major_current ];  then result="yes"; fi
  if [ $major_new  -eq $major_current ];  then
    minor_current=$(echo $1 | cut -d. -f2)
    minor_new=$(echo $2 | cut -d. -f2)
    if [ $minor_new -gt $minor_current ]; then result="yes"
    elif [ $minor_new -eq $minor_current ]; then 
      revision_current=$(echo $1 | cut -d. -f3)
      revision_new=$(echo $2 | cut -d. -f3)
      if [ $revision_new -gt $revision_current ]; then result="yes"; fi; fi; fi 
  echo $result
}

# Verify if the version format is right
verif_version_format () {
  # Args:
  # $1 - New version variable

  number_point=$(echo $1 | grep -o "\." | wc -l )
  if [ "$number_point" = "1" ]
  then
    major=$(echo $1 | cut -d. -f1) 
    minor=$(echo $1 | cut -d. -f2)
    revision="0"
    if [ ! "$minor" ]; then minor="0";fi
  elif [ "$number_point" = "2" ] 
  then 
    major=$(echo $1 | cut -d. -f1) 
    minor=$(echo $1 | cut -d. -f2)  
    revision=$(echo $1 | cut -d. -f3)  
    if [ ! "$minor" ]; then minor="0";fi
    if [ ! "$revision" ]; then revision="0";fi
  else 
    major=$(echo $1 | cut -d. -f1) 
    minor="0"
    revision="0"
  fi
  echo "$major.$minor.$revision"
}

# Verify if versions are in the right format and greater than previous versions
test_versions () {
  # Args:
  # $1 - New version variable
  # $2 - Current version variable
  # $3 - Current version variable's name
 
  if [ "$1" ]
  then
    version_right_format=$(verif_version_format $1)
    is_greater=$(compare_versions $2 $version_right_format)
    if [ $is_greater = "yes" ]; then eval $3="$version_right_format" ; IS_CONFIG_SAVED="false" 
    else dialog --msgbox "Version plus ancienne que la version actuelle" 10 30; fi 
  fi
}
