#!/bin/bash

# shellcheck source=/dev/null
source ./app.conf
nombreAleatoire=${RANDOM:0:2};
fileScores="./scores.txt"
fileHighScores="./highScores.txt"
nombreCoups=0

# Tant que la valeur entrée par l'utilisateur est différente du nombre à trouver, on continue à boucler
while [[ ${saisieUtilisateur} -ne ${nombreAleatoire} ]];
do
    # Incrémentation de 1 pour chaque nouvel essai
    nombreCoups=$((nombreCoups+1))
    echo "Saisissez un nombre :"
    read -r saisieUtilisateur
    if [[ ${saisieUtilisateur} -lt ${nombreAleatoire} ]]
    then
        echo "Le nombre saisie par l'utilisateur est plus petit que le nombre mystère"
    elif [[ ${saisieUtilisateur} -gt ${nombreAleatoire} ]]
    then
        echo "Le nombre saisie par l'utilisateur est plus grand que le nombre mystère"
    fi
done

# Le joueur possède 5 essais maximum pour trouver le nombre
if [[ $nombreCoups -lt "$essaisMaximum" ]]
then
    echo "Bravo, vous avez gagné en $nombreCoups coups !"
    echo "Entrez votre pseudo :"
    read -r gagnant

    nbScoresEnregistres=$(wc -l < ${fileScores})
    # Au bout de 100 scores maximum enregistrés par les joueurs, un reset des scores est effectué
    if [ "$nbScoresEnregistres" -lt "$nombreScoresMaxEnregistres" ];
    then
        echo "${gagnant} : $nombreCoups" >> ${fileScores}       
        # Vérifier si le joueur est dans le classement HighScores
        if grep -q "${gagnant}" ${fileHighScores};
        then
            # Vérifier si le score obtenu est supérieur au précédent déjà obtenu dans le classement HighScores
            joueur=$(grep "${gagnant}" ${fileHighScores})
            coupsJoueurEnCompetition=$(echo "${joueur}" | cut -d ':' -f 2)

            if [ ${nombreCoups} -lt "${coupsJoueurEnCompetition}" ] && [ "${coupsJoueurEnCompetition}" -gt 0 ]
            then
                # Remplacer le score obtenu par le précédent dans le classement HighScores
                echo "Score amélioré, bravo !"
                resultat="${gagnant} : ${nombreCoups}"
                sed -i -e "s/${joueur}/${resultat}/g" ${fileHighScores}
            else
                echo "Retentez votre chance pour améliorer votre score !"
            fi
        else
            # Ajouter le score obtenu dans le classement HighScores
            echo "${gagnant} : $nombreCoups" >> ${fileHighScores}
            echo "En tant que nouveau joueur, votre score a été intégré au classement des meilleurs scores. Rejouer davantage pour pouvoir améliorer votre score !"
        fi  
    else
        echo "Le nombre de score enregistrés à été atteint. Un reset des scores a été effectué !"
        make reset-scores
    fi

else
    echo "Vous avez dépasser le nombre de coups maximum. Recommencez !"
fi