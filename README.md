# ☁️ Terraform AWS ASG with Lambda-Based Cost Optimization
Repo Link: https://github.com/prince097cloud-architect/lambda-ec2-asg-terraform.git
## 🧭 Overview

This repository demonstrates a **modular approach** to deploying an EC2-based Auto Scaling Group (ASG) using Terraform, and **automating cost optimization** by integrating AWS Lambda functions to scale down infrastructure during off-hours.

---

## 🧱 Infrastructure Components

### ✅ Terraform Modules
- `Modules/asg` — Provisions EC2 instances using ASG and Launch Templates
- `Modules/lambda_scale_asg` — Manages Lambda function for ASG scaling
- `aws_security_group.asg_sg` — Security group for ASG instances

---

## 📦 Module Usage

### 🔹 Auto Scaling Group Module
terraform-root/
├── Modules/
│   ├── asg/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   └── lambda_scale_asg/
│       ├── main.tf
│       ├── variables.tf
│       ├── lambda_function.py
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
