#!/bin/bash
# Author: Krzysztof Jodłowski

NAME=${1:-"my-app"}
GROUP=${2:-"com.epam"}
GROUP_PATH="${GROUP//.//}"
VERSION=${3:-"0.1"}
FOLDER_STRUCTURE="$NAME"/src/{main,test}/java/"$GROUP_PATH"/"$NAME" 

echo "Generating project $NAME with groupId $GROUP, version $VERSION.."
echo "Creating folder structure.."

mkdir -p "$NAME"/src/{main,test}/java/"$GROUP_PATH"/"$NAME" 
touch "$NAME"/src/main/java/"$GROUP_PATH"/"$NAME"/App.java
touch "$NAME"/src/test/java/"$GROUP_PATH"/"$NAME"/AppTest.java

echo "Generating pom.xml.."

curl -L -s https://raw.githubusercontent.com/KrzysiekJodlowski/quickstart-pom/master/pom.xml > "$NAME"/pom.xml
sed -i s/*GROUP*/"$GROUP"/g "$NAME"/pom.xml
sed -i s/*NAME*/"$NAME"/g "$NAME"/pom.xml
sed -i s/*ARTIFACT*/"$NAME"/g "$NAME"/pom.xml
sed -i s/*VERSION*/"$VERSION"/g "$NAME"/pom.xml

echo "Generating readme.md.."

cat << EOF > "$NAME"/readme.md
Title: $NAME
Author: Krzysztof Jodłowski
Version: $VERSION

To run project you have to use:
- bash or other compatible unix shell
- jdk version $(java --version | head -n 1)
- maven version $(mvn -v | head -n 1 | grep -o [0-9]\.[0-9]\.[0-9])

To build project simply run "mvn package" command, to make it work run "java -cp target/$NAME-$VERSION.jar $GROUP.$NAME"
EOF

echo "Generating .gitignore.."

curl -L -s https://raw.githubusercontent.com/github/gitignore/master/Global/JetBrains.gitignore > "$NAME"/.gitignore
echo "*.class" >> "$NAME"/.gitignore
echo "*.swp" >> "$NAME"/.gitignore
echo ".idea/" >> "$NAME"/.gitignore
echo "stale_output_checked" >> "$NAME"/.gitignore

echo "Project generated succesfully."
echo "Initializing git repository and creating first commit.."

cd "$NAME"/
git init
git add .
git commit -m "Initialize $NAME project"

echo "Opening project with Intellij Idea.."

intellij-idea-community pom.xml
