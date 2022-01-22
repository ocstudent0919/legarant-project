# Déployer les métadonnées du projet vers un environnement de test/production
Pour transférer les  métadonnées, installez le package déverrouillé 04t09000000aO7JAAU dans votre organisation cible.

## Prérequis
L’environnement Salesforce DX installé et configuré ([Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)).

## Installation du package déverrouillé en ligne du commande
- Pour installer la version du package dans votre organisation, vous devez d’abord l’ajouter à votre liste d’organisations autorisées :
```
sfdx auth:web:login -a <alias de l'organisation cible>
```
- Installez le package :
```
sfdx force:package:install --wait 10 --publishwait 10 --package 04t09000000aO7JAAU --noprompt -u <nom d'utilisateur ou alias de l'organisation cible>
```
- Attribuez l’ensemble d’autorisations en exécutant la commande suivante :
```
sfdx force:user:permset:assign -n Legarant -u <nom d'utilisateur ou alias de l'organisation cible>
```
- Si votre organisation cible n’est pas déjà ouverte, ouvrez-la avec cette commande :
```
sfdx force:org:open -u <nom d'utilisateur ou alias de l'organisation cible>
```
- Depuis App Launcher (Lanceur d’application), cherchez et ouvrez **Legarant**.

## Attribution de types d'enregistrement et de présentations de page
Les  objets concernés par cette opération sont Account (Compte), Contact, Contract (Contrat) et Product (Produit). 

Pour spécifier des types d'enregistrement et des attributions de présentation de page :
- Dans Configuration, saisissez ```Profils``` dans la case ```Recherche rapide```, puis sélectionnez **Profils**.
- Sélectionnez ```System Administator``` (Administrateur système).
- Dans la case ```Rechercher les paramètres```, saisissez le nom de l'objet cible (un parmi les quatres mentionnés ci-dessus) et sélectionnez-le dans la liste.
- Cliquez sur ```Modifier```.
- Dans la section ```Types d'enregistrement et attributions de présentation de page```, modifiez le paramètre ```Attribution de présentation de page``` en suivant les indications présentes dans le tableau ci-dessous.

| Objet    | Types d'enregistrement | Attribution de présentation de page |
|----------|------------------------|-------------------------------------|
| Account  | Legarant Account       | Legarant Account Layout             |
| Contact  | Legarant Contact       | Legarant Contact Layout             |
| Contract | Legarant Contract      | Legarant Contract Layout            |
| Product  | Legarant Product       | Legarant Product Layout             |

