#!/bin/bash
clear

dircount=0
# no output = command > /dev/null 2>&1

PS3='Please enter the number of the project: '

FOLDERS=()

options=("go to THEME dir"
    "go to THEME with bundle compass"
    "Root with Drush Clear Cache ALL and feature revert all        "
    "Root with Drush Clear Cache ALL"
    "Root with GIT pull"
    "just the root man, just the root")
# Regex would be beter to be sure it's a certain folder.
[[ -d $1 ]] && PROJECT=$1 || PROJECT=false

# Get all the folders without the /
if [ "$PROJECT" = false ]; then
    for f in ~/www/*; do
        if [[ -d $f ]]; then
            FOLDERS+=("${f##*/}")
        fi
    done

    # list all the folders
    select DIRNAME in "${FOLDERS[@]}";
    do
        if [[ $REPLY =~ '^[0-9]+$' ]] && [[ $REPLY -le ${#FOLDERS[@]} ]]; then
            echo -e "\n==========[ \e[0;32m $DIRNAME \e[m ]============\n"
            PROJECT="~/www/$DIRNAME"
            break
        else
            echo "$REPLY: Not on the list, please enter the number of the project"
        fi
    done
fi


PS3='Please enter your choice: '
#does the dir exist

# make selection
select opt in "${options[@]\n\n}"
do
    echo -e "executing: $opt, please wait\n"

    case $REPLY in
        1)
        theme_dir=/htdocs/sites/all/themes/
        theme=()
        for f in $PROJECT$theme_dir*; do
          if [ -d "$f" ] && [[ $f != *"omega" ]]; then
             dircount=$(($dircount+1))
             theme+=("$f")
          fi
        done

        if [ "$dircount" -eq 1 ]; then
            cd ${theme[0]}
        elif [ "$dircount" -gt 1 ]; then
            echo "gt"
                echo ${theme}
            select opt in "${theme[@]}";
            do
                cd ${theme[$REPLY-1]}
                break;
            done
        else
            echo "No themes where found"
            cd $PROJECT && ls -al
        fi
        break
        ;;
        2)
        theme_dir=/htdocs/sites/all/themes/
        theme=()
        for f in $PROJECT$theme_dir*; do
          if [ -d "$f" ] && [[ $f != *"omega" ]]; then
             dircount=$(($dircount+1))
             theme+=("$f")
          fi
        done

        if [ "$dircount" -eq 1 ]; then
            cd ${theme[0]}
            com
        elif [ "$dircount" -gt 1 ]; then
            echo "gt"
                echo ${theme}
                bundle exec compass watch
            select opt in "${theme[@]}";
            do
                cd ${theme[$REPLY-1]}
                bundle exec compass watch
                break;
            done
        else
            echo "No themes where found"
            cd $PROJECT && ls -al
        fi
        break
        ;;
        3)
        cd $PROJECT"/htdocs" && drush fra -y && drush cc all
        break
        ;;
        4)
        cd $PROJECT"/htdocs" && drush cc all
        break
        ;;
        5)
        cd $PROJECT"/htdocs" && git pull
        break
        ;;
        6)
        cd $PROJECT"/htdocs"
        break
        ;;
    esac
done

