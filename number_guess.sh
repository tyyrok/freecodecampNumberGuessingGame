#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo -e "\n~~~~~ Number Guessing Game ~~~~~"
echo "Enter your username:"
read -n 22 USERNAME
#check if user exists in db
CHECK_USER_IN_DB=$($PSQL "SELECT name FROM users WHERE name='$USERNAME' ")
#if not creating user
if [[ -z $CHECK_USER_IN_DB ]]
then
  CREATE_NEW_USER=$($PSQL "INSERT INTO users (name) VALUES ('$USERNAME')")
  if [[ -z $CREATE_NEW_USER ]]
  then
    echo "Error while creating new user!"
  fi
  echo -e "\nWelcome, $USERNAME! It looks like is your first time here."
#if yes showing his history
else  
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN users USING (user_id) WHERE name='$USERNAME' ")
  if [[ $GAMES_PLAYED=0 ]]
  then
    GAMES_PLAYED=0
    BEST_GAME=0
  else
    BEST_GAME=$($PSQL "SELECT MAX(best_game) FROM games INNER JOIN users USING (user_id) WHERE name='$USERNAME' ")
  fi
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
#game body
#generating random from 1 to 1000

#loop for user's guesses

#read user's guess

#if yes?
#show congrat message
#make a record in DB

#if no? 