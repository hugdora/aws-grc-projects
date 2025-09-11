# AWS Compliance Audit & Remediation

## 📌 Overview
Hands-on audit of an AWS environment using native services (Security Hub, GuardDuty, IAM Access Analyzer, AWS Config).  
Findings are mapped to **CIS AWS Foundations** and **ISO 27001 Annex A**; a **Remediation Plan** tracks fixes, owners, and evidence.

## ⚠️ Cost & Safety Notes
- Use a **non-production** AWS account.  
- Prefer **free-tier** resources where possible (t2/t3.micro).  
- **Delete resources** after the lab to avoid charges.

---

## ✅ Prerequisites
- AWS account + AWS CLI configured (`aws configure sso` or keys)  
- Chosen region, e.g., `eu-west-2`  
- (Optional) Sample resources to audit: S3 bucket, EC2 instance, RDS instance, 1-2 IAM users/roles

---

## 🧭 Scope
**Services in scope:** EC2, S3, IAM, RDS  
**Frameworks:** CIS AWS Foundations, ISO 27001 Annex A, NIST CSF

---

## 🛠️ Step-by-step

### Step 1 — Enable Security Services
Use **console** or run the helper script in `./scripts/enable_services.sh` (edit REGION first).  
- **Security Hub**: enable CIS + AWS Foundational Best Practices  
- **GuardDuty**: create detector and enable  
- **IAM Access Analyzer**: create account analyzer  
- **AWS Config**: enable (console recommended); add key rules (S3 not public, RDS/volumes encrypted, IAM MFA)

### Step 2 — Generate Findings
- Intentionally create or tweak test resources (e.g., an S3 bucket with public read) to trigger findings.  
- Wait a few minutes for Security Hub/Config to populate results.

### Step 3 — Export Findings
Use **console export** or run the helper script `./scripts/export_findings.sh`.  
- Security Hub -> `findings.json`  
- GuardDuty -> `guardduty_findings.json`  
- Access Analyzer -> `access_analyzer_findings.json`

Store them under `./findings/` and record in **Evidence**.

### Step 4 — Map to Frameworks & Plan Remediation
Update **Audit_Remediation_Plan.csv**: severity, CIS/ISO mapping, remediation action, owner, due date, evidence.

### Step 5 — Remediate & Re-Check
Apply fixes (Block Public Access, enforce MFA, enable encryption, restrict SGs).  
Re-export findings to show improvement and attach before/after evidence.

### Remediation Results
- **IAM MFA**: Enforced MFA for console users and added deny-if-no-MFA guardrail policy. 
  - Evidence: Evidence/iam_mfa_after.png, findings/securityhub_findings_after2.json
- **EC2 Security Group**: Removed 0.0.0.0/0 on SSH (22) and RDP (3389), restricted to analyst IP (78.146.96.193/32).
  - Evidence: Evidence/sg_restricted_after.png, findings/securityhub_findings_ec2_after.json
- Re-ran Security Hub exports to demonstrate post-fix posture and updated the Audit Remediation Plan to **Closed** for both items.


### Step 6 — Cleanup
Terminate EC2/RDS and remove test S3 buckets after saving evidence.  
Optionally disable Security Hub/GuardDuty/Inspector and remove Config rules.

---

## 📂 Deliverables
- `Audit_Remediation_Plan.csv` — tracked findings, mappings, remediation  
- `findings/*.json` — exported findings  
- `Evidence/*` — screenshots, CLI outputs, and proof

---

## 🔎 Mapping Cheatsheet (examples)
- **S3 public access** → CIS 3.1, ISO 27001 A.9/A.13  
- **IAM without MFA** → CIS 1.x, ISO 27001 A.9  
- **RDS not encrypted** → CIS 2.x, ISO 27001 A.10  
- **Open SSH to 0.0.0.0/0** → CIS 4.x, ISO 27001 A.13  
- **GuardDuty recon** → NIST CSF (DE.CM), ISO 27001 A.12

---

## 📋 Evidence Guidance
Capture console screenshots (Security Hub dashboard, S3 bucket config), CLI outputs, and JSON exports.  
Reference them in the `Evidence` column of `Audit_Remediation_Plan.csv` and store files under `./Evidence` or `./findings`.

---

## 📦 How to Run
```bash
# 1) Edit REGION in scripts, then run
bash ./scripts/enable_services.sh

# 2) Trigger a few misconfigs intentionally (then fix later)

# 3) Export findings
bash ./scripts/export_findings.sh

# 4) Update Audit_Remediation_Plan.csv with mappings + remediation

# 5) After remediation, export again and capture 'after' evidence
```