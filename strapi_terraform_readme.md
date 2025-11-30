# Strapi on AWS EC2 using Terraform

This project deploys a complete AWS infrastructure for running **Strapi CMS** inside an EC2 instance using Terraform. It automatically installs Node.js, Yarn, and creates a Strapi project via user-data.

---

## 🚀 Features

- Creates a secure **VPC** (Virtual Private Cloud)
- Public **subnet** with automatic public IP
- **Internet Gateway** and **Route Table** for internet access
- **Security Group** allowing ports:
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)
  - Strapi (1337)
- Launches **EC2 instance** and installs:
  - Node.js 20
  - Yarn
  - Strapi project (`strapi-app`)

---

## 📂 Project Structure

```
terraform-aws/
├── main.tf
├── variables.tf
├── provider.tf
├── outputs.tf
└── README.md
```

---

## 🔧 Prerequisites

- AWS Account
- IAM User with programmatic access
- Terraform installed (≥ v1.0)
- AWS CLI installed
- SSH key pair created in AWS

---

## 🔐 Configure AWS Credentials

```sh
aws configure
```
Provide:
- AWS Access Key
- AWS Secret Key
- Region (example: `us-east-1`)
- Output: json

---

## ▶️ Deploy Infrastructure

### Initialize Terraform
```sh
terraform init
```

### Validate configuration
```sh
terraform validate
```

### Preview resources
```sh
terraform plan
```

### Apply and create infrastructure
```sh
terraform apply
```

To override instance type:
```sh
terraform apply -var="instance_type=t3.small"
```

---

## 💻 Access EC2 Instance (SSH)

```sh
ssh -i <your-key>.pem ubuntu@<EC2-Public-IP>
```

---

## ▶️ Start Strapi Manually

Once connected to EC2:

```sh
cd ~/strapi-app
npm install
npm run develop
```

Strapi will output:
```
http://localhost:1337/admin
```

To access from your browser:
```
http://<EC2-Public-IP>:1337/admin
```

Ensure your Security Group has port **1337** open.

---

## 🧹 Destroy Infrastructure

To delete all AWS resources created:

```sh
terraform destroy
```

---

## ⚠️ Troubleshooting

### ❌ `SignatureDoesNotMatch: Signature expired`
Fix: Sync your Windows system time.

### ❌ Strapi not accessible in browser
- Ensure port **1337** is open in Security Group
- Make sure Strapi is running:
  ```sh
  npm run develop
  ```
- Open correct URL:
  `http://<public-ip>:1337/admin`

### ❌ SQLite error (better-sqlite3)
Install build tools, remove `node_modules`, reinstall:
```sh
sudo apt install build-essential python3 make g++
rm -rf node_modules package-lock.json
npm install
```

---

## 📘 License
MIT

---

If you want, I can also generate **outputs.tf**, **provider.tf**, or a full project structure automatically.

