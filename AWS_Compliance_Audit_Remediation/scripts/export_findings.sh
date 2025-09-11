#!/usr/bin/env bash
set -euo pipefail
REGION="${REGION:-eu-west-2}"

mkdir -p ./findings

echo "[+] Exporting Security Hub findings to findings/securityhub_findings.json"
aws securityhub get-findings --region "$REGION" > findings/securityhub_findings.json || true

echo "[+] Exporting GuardDuty findings to findings/guardduty_findings.json"
DET_ID="$(aws guardduty list-detectors --region "$REGION" --query 'DetectorIds[0]' --output text)"
if [ "$DET_ID" != "None" ] && [ -n "$DET_ID" ]; then
  IDS=$(aws guardduty list-findings --detector-id "$DET_ID" --region "$REGION" --query 'FindingIds' --output json)
  aws guardduty get-findings --detector-id "$DET_ID" --finding-ids $(echo $IDS | jq -r '.[]' | xargs) --region "$REGION" > findings/guardduty_findings.json || true
else
  echo "[-] No GuardDuty detector found"
fi

echo "[+] Exporting Access Analyzer findings to findings/access_analyzer_findings.json"
aws accessanalyzer list-analyzers --region "$REGION" --query 'analyzers[?name==`default`].arn' --output text || true
aws accessanalyzer list-findings --analyzer-name default --region "$REGION" > findings/access_analyzer_findings.json || true

echo "[+] Done."
