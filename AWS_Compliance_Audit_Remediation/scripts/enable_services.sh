#!/usr/bin/env bash
set -euo pipefail

# EDIT THIS
REGION="${REGION:-eu-west-2}"

echo "[+] Enabling AWS Security Hub in $REGION"
aws securityhub enable-security-hub --enable-default-standards --region "$REGION" || true

echo "[+] Enabling CIS + Foundational Best Practices"
aws securityhub batch-enable-standards --region "$REGION" --standards-subscription-requests '[
  {"StandardsArn":"arn:aws:securityhub:'"$REGION"'::standards/aws-foundational-security-best-practices/v/1.0.0"},
  {"StandardsArn":"arn:aws:securityhub:'"$REGION"'::standards/cis-aws-foundations-benchmark/v/1.4.0"}
]' || true

echo "[+] Enabling Amazon GuardDuty"
DETECTOR_ID="$(aws guardduty create-detector --enable --region "$REGION" --query DetectorId --output text || true)"
echo "Detector ID: $DETECTOR_ID"

echo "[+] Enabling IAM Access Analyzer (account analyzer named 'default')"
aws accessanalyzer create-analyzer --analyzer-name default --type ACCOUNT --region "$REGION" || true

echo "[!] AWS Config: Recommend enabling via Console (recorder + delivery channel)."
echo "    After enabling, you can add key rules via CLI:"
echo "    aws configservice put-config-rule --config-rule '{"ConfigRuleName":"s3-bucket-public-read-prohibited","Source":{"Owner":"AWS","SourceIdentifier":"S3_BUCKET_PUBLIC_READ_PROHIBITED"}}'"
echo "    aws configservice put-config-rule --config-rule '{"ConfigRuleName":"iam-user-mfa-enabled","Source":{"Owner":"AWS","SourceIdentifier":"IAM_USER_MFA_ENABLED"}}'"
echo "    aws configservice put-config-rule --config-rule '{"ConfigRuleName":"rds-storage-encrypted","Source":{"Owner":"AWS","SourceIdentifier":"RDS_STORAGE_ENCRYPTED"}}'"
echo "[+] Done."
