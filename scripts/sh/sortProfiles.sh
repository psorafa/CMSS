#!/bin/bash
# Use this script to sort and deduplicate profiles before you create pull request.

java -jar scripts/java/profilesSort.jar --directory.profiles="cmss/app/default/profiles"
java -jar scripts/java/profilesSort.jar --directory.profiles="cmss/app/community/profiles"