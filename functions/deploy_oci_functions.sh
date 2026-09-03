#!/usr/bin/env bash
#set -euo pipefail

# Set the variables

region="eu-stockholm-1"
APP_NAME="pythonapp"
APP_OCID=""
NAMESPACE=""
DOCKER_HOST="$region.ocir.io"
DOCKER_USER=""
DOCKER_PASS=""
fun_dir=""




# Main script
fn create context $APP_NAME
fn use context $APP_NAME

# Set the config ocid. 
fn update context oracle.compartment-id $APP_OCID
fn update context oracle.image-compartment-id $APP_OCID

# Set the appurl 
echo "Setting up appurl: fn update context api-url https://functions.$region.oraclecloud.com"
fn update context api-url https://functions.$region.oraclecloud.com

#Set the registry
echo "Setting up registry: fn update context registry $DOCKER_HOST/$NAMESPACE/$APP_NAME"
fn update context registry $DOCKER_HOST/$NAMESPACE/$APP_NAME

# Dockerlogin 
echo "Logging in to OCIR registry host: $DOCKER_HOST"
echo "Dockerlogin:  docker login $DOCKER_HOST -u $NAMESPACE/$DOCKER_USER --password-stdin"
if ! echo "$DOCKER_PASS" | docker login "$DOCKER_HOST" -u "$NAMESPACE/$DOCKER_USER" --password-stdin; then
	echo "ERROR: docker login to $DOCKER_HOST failed" >&2
	exit 1
fi



# Deploying the Apps
echo "Deploying function to app '$APP_NAME'..."
fn -v deploy --app "$APP_NAME" --working-dir $fun_dir