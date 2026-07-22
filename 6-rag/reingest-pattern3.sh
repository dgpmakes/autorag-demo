#!/usr/bin/env bash
# Declarative path (preferred for workshop recreate):
#   oc apply -f 6-rag/pattern3-ingest.yaml
#   oc wait -n llamastack --for=condition=complete job/pattern3-rag-ingest --timeout=300s
#   oc apply -f 8-app/deployment.yaml
#
# This helper deletes/re-applies the Job (Jobs are immutable once created).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAMESPACE="${NAMESPACE:-llamastack}"

oc delete job pattern3-rag-ingest -n "$NAMESPACE" --ignore-not-found
oc apply -f "${SCRIPT_DIR}/pattern3-ingest.yaml"
oc wait -n "$NAMESPACE" --for=condition=complete job/pattern3-rag-ingest --timeout=300s
oc logs -n "$NAMESPACE" job/pattern3-rag-ingest

echo
echo "App ConfigMap uses VECTOR_STORE_ID=pizza-bank-pattern3 (8-app/deployment.yaml)."
