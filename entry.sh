#!/bin/bash
set -e

exec "${STEAMAPPDIR}/start-server.sh" \
  -servername "${SERVERNAME}" \
  -adminpassword "${ADMINPASSWORD}"
