#!/bin/bash

# Inputs de GitHub Actions
FORTISSL=$1
VPN_USER=$2
VPN_PASSWORD=$3
VPN_HOST=$4
VPN_PORT=$5
VPN_SERVERCERT=$6
CUSTOM_COMMAND=$7

# Si es una conexión FortiSSL, entonces validamos los campos requeridos
if [ "$FORTISSL" == "true" ]; then
  # Validamos que los parametros necesarios para realizar la conexión de fortissl tengan un valor
  if [ -z "$VPN_USER" ] || [ -z "$VPN_PASSWORD" ] || [ -z "$VPN_HOST" ]; then
    echo "Error: VPN_USER, VPN_PASSWORD, and VPN_HOST are required for FortiSSL connection."
    exit 1
  fi

  # Realizamos la conexión con OpenConnect utilizando FortiSSL
  echo "Connecting to FortiSSL VPN at $VPN_HOST on port $VPN_PORT..."
  echo $VPN_PASSWORD | sudo openconnect --protocol=fortinet \
    -u $VPN_USER \
    --passwd-on-stdin \
    $VPN_HOST:$VPN_PORT \
    --servercert $VPN_SERVERCERT \
    --background 
else
  # Si no es FortiSSL, entonces validamos que el comando personalizado tenga un valor
  if [ -z "$CUSTOM_COMMAND" ]; then
    echo "Error: CUSTOM_COMMAND is required for non-FortiSSL connections."
    exit 1
  fi

  # Ejecutar el comando de autenticación personalizado
  echo "Running custom authentication command..."
  eval "$CUSTOM_COMMAND"
fi