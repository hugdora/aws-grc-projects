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

# AWS GRC Projects – AWS Compliance Audit & Remediation

## 📌 Overview
This project simulates a **Governance, Risk, and Compliance (GRC) audit on AWS**, focused on identifying, remediating, and tracking high-risk findings across **Security Hub, AWS Config, GuardDuty, and IAM Access Analyzer**.  

The work mirrors real-world compliance tasks mapped to **CIS AWS Foundations Benchmark** and **ISO 27001** controls.

---

## ⚙️ Tools & Services Used
- **AWS Security Hub** – Findings & compliance checks  
- **AWS Config** – Resource compliance & delivery channels  
- **AWS GuardDuty** – Threat detection (recon/port scanning)  
- **IAM Access Analyzer** – Public / external access detection  
- **EC2 Security Groups** – Network hardening  
- **S3** – Public access remediation  
- **PowerShell + AWS CLI** – Automation, evidence export  
- **CSV tracking** – Audit Remediation Plan & Evidence Log  

---

## 🔍 What I Did
1. **Enabled core services** (Security Hub, GuardDuty, Config, Access Analyzer).  
2. **Collected baseline findings** (JSON exports for Security Hub, GuardDuty, IAM Access Analyzer).  
3. **Created an Audit Remediation Plan** mapping findings to CIS & ISO controls.  
4. **Executed remediation**:
   - Enforced **IAM MFA** for users.  
   - Restricted **EC2 Security Group** open ports (22/3389) to analyst IP.  
   - Applied **S3 Block Public Access** and encryption.  
5. **Re-collected findings (after remediation)** to demonstrate reduced risks.  
6. **Logged evidence** (screenshots + JSON exports) in an **Evidence Log CSV**.

---

## 📊 Before vs After

| Service       | Findings (Before) | Findings (After) | Example Remediation |
|---------------|------------------|------------------|---------------------|
| Security Hub  | 126              | 131 (new scans)  | MFA, S3, SG hardening |
| GuardDuty     | Recon detected   | None new         | Blocked public ingress |
| IAM Analyzer  | 5 ACTIVE         | 0 external risks | Restricted S3/role sharing |
| EC2 SG        | Open to 0.0.0.0  | Restricted to /32 | Analyst IP only |

---

## 📂 Evidence

All evidence is tracked in:  
- **`Audit_Remediation_Plan.csv`** → Findings, mapping, remediation, status  
- **`Evidence_Log_Project2.csv`** → Screenshots & JSON exports collected  

Example evidence files:
- `Evidence/iam_mfa_after.png` → Screenshot of MFA enforcement  
- `findings/securityhub_findings_after2.json` → Post-remediation Security Hub export  
- `Evidence/sg_restricted.png` → Screenshot of updated EC2 SG inbound rules  

---

## 📑 Example Remediation Entries

**IAM MFA Enforcement**  
- **Before**: IAM user without MFA  
- **Remediation**: Enabled MFA & enforced policy  
- **Evidence**: `Evidence/iam_mfa_after.png` + JSON export  
- **Status**: ✅ Closed  

**EC2 Security Groups**  
- **Before**: SSH/RDP open to 0.0.0.0/0  
- **Remediation**: Restricted to analyst IP (78.146.x.x/32)  
- **Evidence**: `Evidence/sg_restricted.png` + Security Hub findings  
- **Status**: ✅ Closed  

---

## 📈 Workflow Diagram

```mermaid
flowchart TD
    A[Enable AWS Services<br>Security Hub / Config / GuardDuty / Access Analyzer] --> B[Collect Baseline Findings<br>JSON Exports + Evidence]
    B --> C[Create Audit Remediation Plan<br>Map to CIS & ISO 27001]
    C --> D[Apply Remediations<br>MFA, SG Hardening, S3 Block Public Access]
    D --> E[Collect Findings After<br>Evidence Logs + Screenshots]
    E --> F[Close Findings & Track in CSV<br>Audit_Remediation_Plan.csv & Evidence_Log.csv]
