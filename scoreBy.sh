#!/bin/bash
file="./highScores.txt"

# shellcheck source=/dev/null
source app.conf


echo "Entrez le nom d'un joueur pour avoir son score:"
read -r joueur

if grep -q "${joueur}" ${file};
then
    joueur=$(grep "${joueur}" ${file})
    echo "${joueur}"
else
    echo "Le joueur que vous avez saisis n'a pas été trouvé."
fi