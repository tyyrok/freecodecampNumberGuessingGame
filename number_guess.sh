#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo -e "\n~~~~~ Number Guessing Game ~~~~~"
echo "Enter your username:"
read -n 22 USERNAME
#check if user exists in db
CHECK_USER_IN_DB=$($PSQL "SELECT name, user_id FROM users WHERE name='$USERNAME' ")
#if not creating user
if [[ -z $CHECK_USER_IN_DB ]]
then
  CREATE_NEW_USER=$($PSQL "INSERT INTO users (name) VALUES ('$USERNAME')")
  if [[ -z $CREATE_NEW_USER ]]
  then
    echo "Error while creating new user!"
  fi
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
#if yes showing his history
else  
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN users USING (user_id) WHERE name='$USERNAME' ")
  echo $GAMES_PLAYED
  USER_ID=$(echo $CHECK_USER_IN_DB | cut -d '|' -f 2)
  if [[ $GAMES_PLAYED == 0 ]]
  then
    GAMES_PLAYED=0
    BEST_GAME=0
  else
    BEST_GAME=$($PSQL "SELECT MIN(best_game) FROM games INNER JOIN users USING (user_id) WHERE name='$USERNAME' ")
  fi
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
#game body
#generating random from 1 to 1000
RAND=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_TRIES=1
#loop for user's guesses
echo "Guess the secret number between 1 and 1000:"
#USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
#read user's guess
read GUESS 
until [[ $GUESS == $RAND ]]
do
  #Checking ig guess is correct?
  while [[ ! $GUESS =~ ^[0-9]+$ ]]
  do
    echo "That is not an integer, guess again:"
    read GUESS
    (( NUMBER_OF_TRIES+=1 ))
  done
  if [[ $GUESS -lt $RAND ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
  read GUESS
  (( NUMBER_OF_TRIES+=1 ))
done
#make a record in DB
CREATE_NEW_GAME=$($PSQL "INSERT INTO games (best_game, user_id) VALUES ($NUMBER_OF_TRIES, $USER_ID)")
  if [[ -z $CREATE_NEW_GAME ]]
  then
    echo "Error while creating new user!"
  fi
#show congrat message

echo "You guessed it in $NUMBER_OF_TRIES tries. The secret number was $RAND. Nice job!"



