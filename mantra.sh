#!/bin/bash
# Author: Krzysztof Jodłowski

ARTIFACT_ID=${1:-"myapp"}
NAME=${2:-"myapp"}
DESCRIPTION=${3:-"Demo of $NAME"}

echo "Generating project $NAME.."
echo "Creating folder structure.."

mkdir -p "$NAME"/src/{main,test}/java/com/academy/"$ARTIFACT_ID"
mkdir -p "$NAME"/src/main/resources
mkdir -p "$NAME"/src/test/resources

echo "Generating pom.xml.."

curl -L -s https://raw.githubusercontent.com/KrzysiekJodlowski/quickstart-pom/master/pom.xml > "$NAME"/pom.xml
sed -i s/"#APP"/"$ARTIFACT_ID"/g "$NAME"/pom.xml
sed -i s/"#NAME"/"$NAME"/g "$NAME"/pom.xml
sed -i s/"#DESC"/"$DESCRIPTION"/g "$NAME"/pom.xml

echo "Generating readme.."

cat << EOF > "$NAME"/readme.adoc
== $NAME

*Author*: _Krzysztof Jodłowski_ +
*Version*: _0.1_

$DESCRIPTION

To run project you have to use:

* bash or other compatible unix shell
* jdk version 11+
* maven version 3.6.0+

To build project simply run _"mvn package"_ command, to make it work run _"java -jar target/$NAME-0.1.jar"_
EOF

echo "Generating .gitignore.."

curl -L -s https://www.gitignore.io/api/java,maven,intellij+all > "$NAME"/.gitignore"$NAME"/.gitignore
echo stale_outputs_checked >> "$NAME"/.gitignore

echo "Project generated succesfully."
echo "Initializing git repository and creating first commit.."

cd "$NAME"/
git init
git add .
git commit -m "Initialize $NAME project"

echo "Opening project with Intellij Idea.."

intellij-idea-community pom.xml . &
