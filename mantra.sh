#!/bin/bash
# Author: Krzysztof Jodłowski

ARTIFACT_ID=${1:-"myapp"}
NAME=${2:-"myapp"}
DESCRIPTION=${3:-"Demo of $NAME"}
FOLDER_STRUCTURE="$NAME"/src/{main,test}/java/com/academy/"$ARTIFACT_ID" 

echo "Generating project $NAME.."
echo "Creating folder structure.."

mkdir -p "$NAME"/src/{main,test}/java/com/academy/"$ARTIFACT_ID"

echo "Generating pom.xml.."

curl -L -s https://raw.githubusercontent.com/KrzysiekJodlowski/quickstart-pom/master/pom.xml > "$NAME"/pom.xml
sed -i s/#APP/"$ARTIFACT_ID"/g "$NAME"/pom.xml
sed -i s/#NAME/"$NAME"/g "$NAME"/pom.xml
sed -i s/#DESC/"$DESCRIPTION"/g "$NAME"/pom.xml

echo "Generating readme.md.."

cat << EOF > "$NAME"/readme.md
Title: $NAME
Author: Krzysztof Jodłowski
Version: 0.1

To run project you have to use:
- bash or other compatible unix shell
- jdk version 11
- maven version >= 3.6.0

To build project simply run "mvn package" command, to make it work run "java -jar target/$NAME-0.1.jar com.academy.YourMainClass"
EOF

echo "Generating .gitignore.."

curl -L -s https://www.gitignore.io/api/java,maven,intellij+all > "$NAME"/.gitignore
# echo "*.class" >> "$NAME"/.gitignore
# echo "*.swp" >> "$NAME"/.gitignore
# echo ".idea/" >> "$NAME"/.gitignore
# echo "stale_output_checked" >> "$NAME"/.gitignore

echo "Project generated succesfully."
echo "Initializing git repository and creating first commit.."

cd "$NAME"/
git init
git add .
git commit -m "Initialize $NAME project"

echo "Opening project with Intellij Idea.."

intellij-idea-community pom.xml &
