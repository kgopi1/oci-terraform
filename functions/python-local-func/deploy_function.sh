#!/usr/bin/env bash
set -euo pipefail

# deploy_function.sh
# Small helper to configure Fn context, login to OCIR, deploy the function and optionally invoke it.

usage() {
  cat <<EOF
Usage: $0 [--app APP_NAME] [--context CONTEXT_NAME]

Environment variables accepted (will prompt if missing):
  COMPARTMENT_ID           Compartment OCID for the function and image
  API_URL                  Functions API URL (e.g. https://functions.eu-stockholm-1.oraclecloud.com)
  REGISTRY                 Full registry path (e.g. eu-stockholm-1.ocir.io/namespace/repo)
  IMAGE_COMPARTMENT_ID     Compartment OCID where images are stored
  DOCKER_USER              OCIR username (tenancy/namespace user)
  DOCKER_PASS              OCIR password or auth token (recommended via env)
  APP_NAME                 Fn app name (default: pythonfn)
  CONTEXT_NAME             Fn context name (default: pythonfn)
  FUNCTION_OCID            Optional: function OCID to run an invoke after deploy
  OUTPUT_FILE              File to write invoke output (default: output.txt)
  REQUEST_BODY             Body to send to function invoke (default: empty)

Examples:
  COMPARTMENT_ID=ocid1... ./deploy_function.sh
  ./deploy_function.sh --app pythonfn
EOF
}

APP_NAME=pythonfn
CONTEXT_NAME=pythonfn
OUTPUT_FILE=output.txt
REQUEST_BODY=""

while [[ ${#} -gt 0 ]]; do
  case "$1" in
    --app) APP_NAME="$2"; shift 2;;
    --context) CONTEXT_NAME="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 2;;
  esac
done

prompt_if_empty() {
  local varname="$1" prompt_msg="$2" silent=${3:-false}
  if [ -z "${!varname:-}" ]; then
    if [ "$silent" = true ]; then
      read -rsp "$prompt_msg: " val; echo
    else
      read -rp "$prompt_msg: " val
    fi
    printf -v "$varname" "%s" "$val"
  fi
}

prompt_if_empty COMPARTMENT_ID "Compartment OCID"
prompt_if_empty API_URL "Functions API URL (example: https://functions.eu-stockholm-1.oraclecloud.com)"
prompt_if_empty REGISTRY "Registry (example: eu-stockholm-1.ocir.io/namespace/repo)"
prompt_if_empty IMAGE_COMPARTMENT_ID "Image compartment OCID"
prompt_if_empty DOCKER_USER "Docker/OCIR username"
prompt_if_empty DOCKER_PASS "Docker/OCIR password or auth token" true
prompt_if_empty FUNCTION_OCID "(Optional) Function OCID to invoke (leave blank to skip)"
prompt_if_empty OUTPUT_FILE "Output file for invoke (default: output.txt)"
prompt_if_empty REQUEST_BODY "Request body for invoke (default: empty)"

# Ensure we have required values
if [ -z "${COMPARTMENT_ID:-}" ] || [ -z "${API_URL:-}" ] || [ -z "${REGISTRY:-}" ] || [ -z "${IMAGE_COMPARTMENT_ID:-}" ]; then
  echo "Missing required configuration. Aborting." >&2
  usage
  exit 1
fi

DOCKER_HOST="${REGISTRY%%/*}"

echo "Creating and using Fn context '$CONTEXT_NAME'..."
fn create context "$CONTEXT_NAME" --provider oracle || true
fn use context "$CONTEXT_NAME"

echo "Updating Fn context values..."
fn update context oracle.compartment-id "$COMPARTMENT_ID"
fn update context api-url "$API_URL"
fn update context registry "$REGISTRY"
fn update context oracle.image-compartment-id "$IMAGE_COMPARTMENT_ID"

echo "Logging in to OCIR registry host: $DOCKER_HOST"
echo "$DOCKER_PASS" | docker login "$DOCKER_HOST" -u "$DOCKER_USER" --password-stdin

echo "Deploying function to app '$APP_NAME'..."
fn -v deploy --app "$APP_NAME"

if [ -n "${FUNCTION_OCID:-}" ]; then
  echo "Invoking function $FUNCTION_OCID and saving output to $OUTPUT_FILE"
  oci fn function invoke --function-id "$FUNCTION_OCID" --file "$OUTPUT_FILE" --body "$REQUEST_BODY"
  echo "Invoke complete. Output saved to $OUTPUT_FILE"
else
  echo "No function OCID provided; skipping invocation."
  echo "To invoke later run: oci fn function invoke --function-id <function-ocid> --file \"$OUTPUT_FILE\" --body \"$REQUEST_BODY\""
fi

echo "Done."
