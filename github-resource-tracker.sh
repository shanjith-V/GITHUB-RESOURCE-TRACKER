#!/bin/bash






#github api to integrate with your script to give request and get response using github_api
API_URL="https://api.github.com"


#username and token to authenticate to github
USERNAME=$username
TOKEN=$token

#$1 organization name and $2 repo name to run the script 
REPO_ORGANIZATION=$1
REPO_NAME=$2


#function to make a get request from gitapi with using curl to send request to get auth by name and token
function github_api_get() {
	local endpoint="$1"
	#local secondendpoint="$2"
	local url="${API_URL}/${endpoint}"
        #send a request to a api with authentication
        curl -s -u"${USERNAME}:${TOKEN}" "$url"
}


#function to list used who have read access to the repo
function list_users_with_read_access() {

        #to get access for the repo and this is provided in github documentation
        local endpoint="repos/${REPO_ORGANIZATION}/${REPO_NAME}/collaborators"



        #it will get the auth function and give this to endpoint to access
        #In collaborators variable  the curl command is executed and json info is printed
        #jq -r is to get particular data from json is usd to print list of users where in  the repo users listing have a permissions block  there pull is true for every users login name and prinint the login in jq .
        #if u want to print particualr data use dot(.) followed by the field (login).
	collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select (.permissions.pull == true) | .login')"



if [[ -z "$collaborators" ]]; then
echo "No users with read access found for ${REPO_ORGANIZATION}/${REPO_NAME}."
else
echo "Users with read access to ${REPO_ORGANIZATION}/${REPO_NAME}:"
echo "$collaborators"
fi


}

#main script
list_users_with_read_access
