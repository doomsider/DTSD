#!/bin/bash
# To convert old player and faction files to the new format
for PUPDATE in /home/user/playerfiles/*
do
sed -i 's/: /=/g' $PUPDATE
done
for FUPDATE in .home/user/factionfiles/*
do
sed -i 's/: /=/g' $FUPDATE
done
