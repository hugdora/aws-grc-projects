# Cloud Security Policy (Template)

## 1. Purpose
This Cloud Security Policy defines the minimum security requirements for the organisation’s use of AWS cloud services.  
The purpose is to protect organisational data, ensure compliance with applicable regulations, and align with industry best practices.


## 2. Scope

This Cloud Security Policy applies to all cloud environments, services, and users under the organisation’s control.

- **AWS Accounts**: Production and Non-Production accounts within the AWS Organisation.  
- **Regions**: All active AWS regions where services are deployed, with primary focus on `eu-west-2` and `us-east-1`.  
- **Services in Scope**:  
  - Compute: EC2, Lambda  
  - Storage: S3, EBS, RDS  
  - Networking: VPC, Security Groups  
  - Security & Governance: IAM, KMS, CloudTrail, AWS Config, GuardDuty, Security Hub  
- **Users**: All employees, contractors, and third parties with access to AWS resources.  
- **Data Classifications**: Confidential, Internal, and Public (based on company data handling policy).  

---

## 3. Compliance Frameworks

This policy aligns with the following external frameworks and industry standards:

- **ISO/IEC 27001** – Information Security Management System (ISMS)  
- **SOC 2 Type II** – Trust Service Criteria: Security, Availability, Confidentiality  
- **CIS AWS Foundations Benchmark v1.4**  
- **NIST Cybersecurity Framework (CSF)** – Identify, Protect, Detect, Respond, Recover  
- **GDPR** – For the processing and storage of personal data  

---

## 4. Roles & Responsibilities

- **CISO / Security Lead**  
  - Accountable for overall security governance and policy approval.  

- **GRC Analyst**  
  - Responsible for risk assessments, compliance monitoring, and policy enforcement.  
  - Maintains the Risk Register and coordinates with auditors.  

- **Cloud/DevOps Engineers**  
  - Implement technical security controls in AWS (IAM, Config, KMS, GuardDuty, Security Hub).  
  - Ensure services meet compliance requirements.  

- **Data Owners**  
  - Classify and approve access to data according to sensitivity.  

- **Incident Response Team**  
  - Detect, contain, and recover from security incidents in AWS.  
  - Provide post-incident reports and lessons learned. 


## 5. Access Control (IAM)

Access to AWS resources must follow the principles of **least privilege** and **role-based access control (RBAC)** 
to ensure that only authorised users and services have the permissions they need.

### 5.1 Identity Management
- All AWS account access must be integrated with the corporate Identity Provider (IdP) via **SSO** where possible.  
- Long-lived IAM users are prohibited; instead, IAM roles and temporary credentials (STS) must be used.  
- The AWS root account must be secured with MFA and not used for daily operations.  

### 5.2 Authentication & MFA
- **Multi-Factor Authentication (MFA)** is mandatory for all users and administrative access.  
- API keys must be rotated regularly and never hard-coded in applications or scripts.  
- Password policies must comply with ISO 27001 Annex A.9 (length, complexity, expiry, lockout).  

### 5.3 Authorization & Privilege Management
- Permissions must follow the **least privilege principle**, granting only the access required for a role.  
- Privileged operations (e.g., IAM changes, KMS key management, network modifications) must require documented approval.  
- Use **permission boundaries** or **service control policies (SCPs)** to enforce compliance guardrails across accounts.  

### 5.4 Access Reviews
- Access rights must be reviewed **quarterly** to ensure appropriateness.  
- Orphaned accounts and unused access keys must be revoked within 30 days.  
- Evidence of access reviews must be recorded in the **Evidence Log** for audits.  

### 5.5 Logging & Monitoring
- All IAM changes (create, modify, delete) must be captured via **AWS CloudTrail** and stored in a centralized S3 bucket.  
- Unauthorised or suspicious access attempts must trigger alerts in **Security Hub** or SIEM (QRadar).  


## 6. Data Protection & Encryption

All organisational data stored or processed in AWS must be protected against unauthorised access, modification, or disclosure.  
Encryption at rest and in transit is mandatory for all sensitive and confidential data.

### 6.1 Encryption at Rest
- **Amazon S3**: All buckets must have **default encryption (AES-256 or AWS KMS CMKs)** enabled.  
- **Amazon RDS & EBS**: All databases and volumes must be encrypted using KMS-managed keys.  
- **Snapshots & Backups**: All RDS, EBS, and S3 backups must be encrypted by default.  
- **KMS Key Management**:  
  - Keys must be rotated automatically every 12 months (where supported).  
  - CMK (Customer Managed Keys) must be used for sensitive workloads.  
  - Key usage must be logged and monitored via CloudTrail.  

### 6.2 Encryption in Transit
- All data in transit must be encrypted using **TLS 1.2 or higher**.  
- AWS services must enforce **HTTPS (port 443)** for web applications and APIs.  
- VPN or AWS Direct Connect with MACsec must be used for secure on-premise to cloud connections.  

### 6.3 Data Classification & Handling
- Data must be classified into **Confidential, Internal, and Public** categories.  
- Confidential data requires KMS CMK encryption and additional access restrictions.  
- Public buckets or endpoints must be explicitly approved by the Data Owner and documented.  

### 6.4 Public Access & Guardrails
- **S3 Block Public Access** must be enabled at the account level.  
- Any exceptions must be documented, risk-assessed, and approved by the CISO.  
- AWS Config rules must enforce “no public S3 buckets” and “no unencrypted RDS/EBS volumes.”  

### 6.5 Logging & Monitoring
- AWS CloudTrail and Config must log all encryption-related changes (e.g., disabling bucket encryption, key deletion).  
- Security Hub must be enabled to continuously check encryption compliance.  
- Non-compliant resources must trigger alerts in SIEM (e.g., QRadar).  


## 7. Logging, Monitoring & Detection

The organisation must maintain continuous visibility of AWS environments to detect security events, ensure compliance, and provide evidence for audits.  
All logging and monitoring controls must be implemented, monitored, and regularly reviewed.

### 7.1 Logging Requirements
- **AWS CloudTrail** must be enabled across all accounts and regions.  
- Logs must be delivered to a central, dedicated S3 bucket with access logging enabled.  
- CloudTrail must capture both **management events** and **data events** (e.g., S3 object-level actions).  
- Logs must be retained for a minimum of **365 days** and made immutable via S3 Object Lock.  

### 7.2 Configuration Monitoring
- **AWS Config** must be enabled to continuously record resource changes.  
- Compliance rules must enforce key requirements (e.g., S3 encryption, IAM MFA, RDS encryption).  
- Non-compliant resources must be flagged and remediation tracked.  

### 7.3 Threat Detection
- **Amazon GuardDuty** must be enabled in all accounts and regions to detect malicious activity.  
- Findings must be integrated into **AWS Security Hub** for centralized visibility.  
- High-severity findings must trigger alerts in the SIEM (QRadar).  

### 7.4 Centralized Monitoring
- **AWS Security Hub** must be enabled with **CIS Benchmarks** and **Foundational Security Best Practices** standards.  
- Alerts must be sent to the SOC/Security team for triage and escalation.  
- Metrics (e.g., number of non-compliant resources, MTTR for findings) must be reported quarterly.  

### 7.5 Evidence & Audit Readiness
- Evidence of logging and monitoring configurations must be documented in the **Evidence Log**.  
- Screenshots or CLI outputs of Security Hub, GuardDuty, and Config dashboards must be collected for audits.  
- Regular reviews must be scheduled to validate logging integrity and completeness. 


## 8. Vulnerability & Patch Management

The organisation must maintain a formal process for identifying, assessing, and remediating vulnerabilities across all AWS resources.  
Systems must be patched in accordance with risk severity and compliance requirements.

### 8.1 Vulnerability Scanning
- **AWS Inspector** must be enabled to scan EC2 instances, container images (ECR), and Lambda functions.  
- Scans must be run at least **weekly**, with results reviewed by the Security Team.  
- Critical and High vulnerabilities must be remediated within **30 days**; Medium within **60 days**; Low within **90 days**.  

### 8.2 Patch Management
- All EC2 instances must use **automated patching tools** (e.g., Systems Manager Patch Manager).  
- RDS instances must have **automatic minor version upgrades** enabled.  
- Container images must be rebuilt regularly to include the latest security patches.  
- Patching evidence must be logged and retained for audit review.  

### 8.3 Remediation & Exception Handling
- Vulnerabilities must be prioritised using a **risk-based approach** (CVSS score, exploitability, data sensitivity).  
- Exceptions must be documented in the **Risk Register**, with compensating controls applied.  
- Business-approved exceptions must include an expiration date and periodic review.  

### 8.4 Compliance Integration
- **AWS Security Hub** findings related to vulnerabilities must be reviewed and tracked to closure.  
- Reports must be generated quarterly to demonstrate compliance with **ISO 27001** and **CIS Benchmarks**.  
- Evidence (scan reports, patching logs) must be added to the **Evidence Log** for audits.  

## 9. Secure Development & CI/CD

The organisation must ensure that all software development and deployment pipelines follow secure coding and DevSecOps practices.
Security controls must be integrated into every stage of the CI/CD lifecycle to reduce risk and ensure compliance.

### 9.1 Source Code & Version Control
- All source code must be stored in **approved repositories** (e.g., GitHub, CodeCommit) with branch protection enabled.
- Commit signing and access controls must be enforced.
- Secrets (API keys, passwords, tokens) must never be hard-coded in source code.

### 9.2 Pipeline Security
- CI/CD pipelines (e.g., Jenkins, GitHub Actions, GitLab CI, AWS CodePipeline) must run with **least privilege IAM roles**.
- **Infrastructure as Code (IaC)** templates (Terraform, CloudFormation) must be scanned using tools like **Checkov** or **cfn-nag**.
- Build and deploy pipelines must require **multi-step approval** for production releases.

### 9.3 Security Testing
- **Static Application Security Testing (SAST)** and **Dynamic Application Security Testing (DAST)** tools must be integrated into the CI/CD process.
- Containers must be scanned for vulnerabilities (e.g., Trivy, Clair) before deployment.
- Dependencies must be checked against known vulnerabilities (e.g., using OWASP Dependency-Check).

### 9.4 Secrets Management
- Secrets must be managed using **AWS Secrets Manager** or **AWS Systems Manager Parameter Store**.
- Secrets must be rotated regularly and logged for audit purposes.
- Direct use of plaintext secrets in CI/CD pipelines is strictly prohibited.

### 9.5 Audit & Evidence
- Logs of pipeline executions, security scan results, and approvals must be retained for at least **12 months**.
- Evidence of secure development practices must be stored in the **Evidence Log** to support compliance audits.
- Metrics (e.g., vulnerabilities detected per release, pipeline security failures) must be reported quarterly.
## 10. Backup, DR & Resilience

The organisation must ensure that critical AWS workloads and data are resilient to failures and recoverable within approved business requirements.
Backup and disaster recovery (DR) processes must be documented, tested, and aligned with compliance standards.

### 10.1 Backup Requirements
- All production data (S3, RDS, EBS, DynamoDB) must be backed up automatically.
- Backups must be **encrypted** using AWS KMS CMKs.
- Backup copies must be stored in at least **two Availability Zones (AZs)**.
- Backup retention must align with business requirements (minimum **90 days**).

### 10.2 Recovery Objectives
- Recovery Point Objective (RPO): **24 hours** maximum.
- Recovery Time Objective (RTO): **4 hours** maximum for critical systems.
- RPO/RTO values must be reviewed annually and updated based on business needs.

### 10.3 High Availability & Resilience
- Critical workloads must use **Multi-AZ deployments** (RDS, EKS, etc.).
- Where feasible, workloads must be designed for **Multi-Region resilience**.
- Auto Scaling Groups must be implemented to maintain service availability.

### 10.4 Testing & Validation
- Disaster Recovery plans must be tested at least **annually**.
- Backup restoration tests must be performed quarterly to validate integrity.
- Test results and evidence must be stored in the **Evidence Log** for audit readiness.

### 10.5 Documentation & Audit
- Backup and DR processes must be documented and reviewed annually.
- Audit evidence (screenshots, restore test logs, DR drill reports) must be collected and retained for **ISO 27001** and **SOC 2** audits.

## 11. Incident Response

The organisation must have a structured process to detect, contain, eradicate, and recover from cloud security incidents.  
Incident response (IR) must be tested regularly and aligned with regulatory and compliance requirements.

### 11.1 Roles & Responsibilities
- **Incident Response Lead** – coordinates response activities and communications.  
- **GRC Analyst** – ensures incidents are documented, mapped to compliance frameworks, and logged in the Risk Register.  
- **Cloud/DevOps Engineers** – execute technical containment and remediation steps.  
- **Management** – approves escalations and communicates with regulators, customers, or external parties.  

### 11.2 Detection & Notification
- Incidents must be detected through **GuardDuty, Security Hub, AWS Config, and CloudTrail logs**.  
- High-severity alerts must be escalated to the SOC within **15 minutes**.  
- Stakeholders must be notified based on severity (CISO, Legal, Compliance, Business Owners).  

### 11.3 Response Procedures
- **Containment**: Isolate affected AWS resources (e.g., disable IAM keys, quarantine EC2 instance).  
- **Eradication**: Remove malicious code, revoke compromised credentials, and patch vulnerabilities.  
- **Recovery**: Restore from backups, re-deploy services with secure configurations.  
- **Evidence Collection**: Preserve CloudTrail logs, GuardDuty findings, and screenshots for forensic analysis.  

### 11.4 Incident Types & Playbooks
Playbooks must exist for the following AWS-specific scenarios:  
- **Compromised IAM user/role**  
- **S3 bucket data exposure**  
- **EC2 compromise (malware, crypto-mining)**  
- **RDS data breach**  
- **GuardDuty high-severity finding**  

### 11.5 Post-Incident Review
- A lessons-learned session must be conducted within **7 days** of incident closure.  
- Root cause analysis (RCA) must be documented and linked to risk treatment plans.  
- New or updated controls must be added to the **Risk Register**.  

### 11.6 Audit & Evidence
- Incident reports must be retained for a minimum of **2 years**.  
- Evidence of incidents and responses (logs, screenshots, timelines) must be added to the **Evidence Log**.  
- Compliance teams must ensure reports align with **ISO 27001 A.16** and **ISO 27035** requirements.  

## 12. Third Parties & SaaS

The organisation must manage third-party and SaaS providers to ensure they meet the organisation’s security and compliance requirements.  
All vendor relationships must include formal due diligence, documented risk assessments, and contractual security obligations.

### 12.1 Vendor Due Diligence
- Security and compliance reviews must be conducted before engaging any third-party or SaaS provider.  
- Vendors must demonstrate compliance with recognized frameworks (e.g., ISO 27001, SOC 2, GDPR).  
- Critical vendors must provide recent **penetration test reports** or **security certifications**.  

### 12.2 Risk Assessment
- Third-party risks must be documented in the **Risk Register**.  
- Vendors handling sensitive or regulated data must be classified as **High Risk**.  
- Risk treatment plans must be documented for any gaps identified.  

### 12.3 Contractual Requirements
- Contracts must include security clauses covering:  
  - Data ownership and processing responsibilities (GDPR Article 28).  
  - Encryption and data protection requirements.  
  - Incident reporting timelines (e.g., within 24–72 hours).  
  - Right-to-audit or request compliance evidence.  
- Termination clauses must ensure data is securely deleted or returned upon contract end.  

### 12.4 Continuous Monitoring
- Vendor performance and compliance must be reviewed **annually**.  
- Any changes to vendor services must trigger a new risk assessment.  
- Evidence of vendor reviews must be retained in the **Evidence Log**.  

### 12.5 SaaS Applications
- SaaS applications must be approved by IT Security before use.  
- Identity and access must be integrated with the corporate **SSO** where possible.  
- SaaS vendors must provide evidence of **regular security testing** and **patch management**.  

## 13. Compliance, Audits & Evidence
The organisation must maintain compliance with applicable laws, regulations, and industry frameworks.  
All AWS environments must be audit-ready, with controls documented, evidence collected, and reviews performed regularly.

### 13.1 Compliance Frameworks
- AWS environments must be assessed against the following frameworks:  
  - **ISO/IEC 27001** – Information Security Management System  
  - **SOC 2 Type II** – Trust Service Criteria (Security, Availability, Confidentiality)  
  - **CIS AWS Foundations Benchmark**  
  - **NIST Cybersecurity Framework (CSF)**  
  - **GDPR** – Data protection requirements for personal data  

### 13.2 Control Documentation
- All implemented security controls must be documented, with references to framework requirements.  
- Control owners must be identified and accountable for compliance.  
- Changes to AWS configurations must be reflected in updated documentation.  

### 13.3 Audit Preparation
- Internal audits must be conducted **at least annually**.  
- Evidence of compliance must be collected and stored in the **Evidence Log**.  
- Findings must be tracked in the **Risk Register**, with remediation plans assigned.  

### 13.4 Evidence Collection
- Evidence must include (where applicable):  
  - Screenshots of AWS Security Hub, GuardDuty, IAM, Config, and CloudTrail dashboards  
  - CLI/SDK command outputs (e.g., encryption, MFA enforcement, policy checks)  
  - Exported reports (e.g., Security Hub findings, vulnerability scans)  
  - Completed access review reports and meeting minutes  
- Evidence must be stored in a secure repository with controlled access.  

### 13.5 External Audits
- Third-party audits (e.g., SOC 2, ISO certification) must be supported with requested evidence.  
- All auditor requests must be logged, tracked, and responded to within defined timelines.  
- Post-audit remediation plans must be created and monitored until closure.  

## 14. Training & Awareness

All employees, contractors, and third parties with access to AWS resources must receive appropriate security and compliance training.
The goal is to ensure staff understand their responsibilities, can recognise risks, and support the organisation’s compliance objectives.

### 14.1 Mandatory Training
- All new hires must complete **security and compliance onboarding training** within 30 days of joining.
- Annual refresher training is mandatory for all employees.
- Training must cover AWS security basics, data protection, incident response, and acceptable use.

### 14.2 Role-Based Training
- **Cloud/DevOps Engineers** must receive additional training on secure AWS configuration and compliance frameworks (e.g., CIS, ISO 27001).
- **GRC Analysts and Compliance Teams** must receive training on audit preparation, risk management, and control documentation.
- **Managers and Data Owners** must receive awareness training on regulatory obligations (e.g., GDPR, SOC 2).

### 14.3 Awareness Activities
- Quarterly security awareness campaigns (e.g., phishing simulations, newsletters) must be conducted.
- Incident simulations and tabletop exercises must be held at least annually to strengthen preparedness.
- Training metrics (completion rates, test scores) must be tracked and reported to management.

### 14.4 Evidence & Compliance
- Training completion records must be retained for **audit purposes**.
- Evidence of awareness campaigns (emails, attendance lists, simulation reports) must be stored in the **Evidence Log**.
- Non-compliance with training requirements must be escalated to HR and management.

## 15. Metrics & Review

The effectiveness of this Cloud Security Policy must be measured, reviewed, and improved continuously.  
Key performance indicators (KPIs) and audit results will be used to ensure compliance and alignment with business objectives.

### 15.1 Metrics & KPIs
- % of AWS resources compliant with CIS Benchmarks and ISO 27001 controls  
- % of IAM users with MFA enabled  
- % of encrypted resources (S3, RDS, EBS)  
- Mean Time to Detect (MTTD) and Mean Time to Respond (MTTR) to incidents  
- % of vulnerabilities remediated within SLA (30/60/90 days)  
- Training completion rates and phishing simulation results  

### 15.2 Policy Review Cycle
- This policy must be reviewed at least **annually** or after significant changes (e.g., new regulations, AWS services, or incidents).  
- Reviews must be conducted by the **GRC team** and approved by the **CISO/Security Lead**.  
- Updates must be version-controlled, with changes logged in the policy history.  

### 15.3 Continuous Improvement
- Lessons learned from incidents, audits, and risk assessments must feed into policy updates.  
- Metrics must be analysed quarterly to identify trends and areas for improvement.  
- Stakeholders must be informed of major updates to ensure consistent compliance.  

---
*Version:* 1.0  |  *Owner:*  Huguette Dora Edjangue |  **Approved by:** CISO / Security Lead | *Approved:*  09/09/2025  |  *Next Review:*  09/09/2026
