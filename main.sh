#!/bin/bash

# function that animates the roulette wheel spinning
spin_animation() {
    local duration=$1
    local end=$((SECONDS + duration)) # seconds is provided as param when fun is called
    # actual spinning animation
    while [ $SECONDS -lt $end ]; do 
        for s in / - \\ \|; do 
            printf "\r$s"
            sleep 0.1
        done
    done
    printf "\n"
}

# function that does the trigger pull animation
trigger_animation() {
    printf "Pulling the trigger"
    for dot in {1..3}; do 
        printf "."
        sleep 0.5
    done
    printf "\n"
}

# animation for safe trigger pull
safe_animation() {
    printf "\rClick. You're safe."
    sleep 0.5
    for s in / - \\ \|; do 
        printf "\rClick. You're safe. $s"
        sleep 0.2
    done
    printf "\r                       \r"
}

# actual game function
gun_roulette() {
    echo "!! Welcome to Gun Roulette !!"
    echo " Spinning the revolver cylinder..."
    spin_animation 3

    # randomly get bullet in one out of 6 chambers
    bullet=$(( RANDOM % 6 + 1 ))
    turn=1 # this for a feel of two player game, but the other player is computer

    while true; do 
        if [ $turn -eq 1 ]; then 
            echo "It's your turn." 
            echo "Type s to spin and p to pull the trigger."
            read -r action
        else 
            echo "It's the computer's turn."
            action="p"
        fi

        if [ "$action" == "s" ]; then
            echo "Spinning the cylinder..."
            spin_animation 3
            bullet=$(( RANDOM % 6 + 1 ))
            echo "Cylinder spun. Now you can pull the trigger."
        elif [ "$action" == "p" ]; then
            trigger_animation
            # randomly select the chamber to fire
            chamber=$(( RANDOM % 6 + 1 ))
            if [ $chamber -eq $bullet ]; then
                if [ $turn -eq 1 ]; then 
                    echo "BANG!!!! You're dead."
                else    
                    echo "BANG!! Computer's Dead."
                fi
                exit 0 
            else
                safe_animation
                echo "Click. You're safe."
            fi
            # change turns
            if [ $turn -eq 1 ]; then
                turn=2
            else
                turn=1
            fi
        else
            echo "Invalid Command, please type s or p again."
        fi
    done
}

# start the game
gun_roulette
