## eSchool

This repository automates end-to-end deployment of a Java web application with a MySQL backend on Azure. It uses:

* **Terraform** to provision two Linux VMs: one for further application setup, one for MySQL.
* **Ansible** to configure the VMs, install required packages, deploy the web application, and ensure the service is up.
* **Bash** (`generate_inventory.sh`) to build your Ansible inventory from Terraform outputs.

Once complete, the web app is exposed on port 8080 of VM1 (e.g., `http://<app-ip>:8080`).

---

## Prerequisites

1. **Azure CLI** installed and authenticated (`az login`).
2. **Terraform** v1.x installed.
3. **Ansible** 2.9+ installed.
4. A local `~/.ssh` directory.

---

## 1. Generate SSH Keys

Generate a dedicated SSH keypair for each VM and save them under `~/.ssh/`:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/vm1_key -C "vm1_user" -N ""
ssh-keygen -t ed25519 -f ~/.ssh/vm2_key -C "vm2_user" -N ""
```
---

## 2. Credentials 

! Your service principal must have **Contributor** rights on the target subscription !
Place your previously generated "subscription-id", "app-id", "client-secret", and "tenant-id", in `terraform.tfvars.json` file as in  `terraform.tfvars.example.json`:

---

## 3. Terraform: Infrastructure Provision

1. **Enter the Terraform directory**

   ```bash
   cd terraform
   ```
2. **Initialize**

   ```bash
   terraform init
   ```
3. **Plan** (using your credentials file)

   ```bash
   terraform plan -var-file="terraform.tfvars.json"
   ```
4. **Apply**

   ```bash
   terraform apply -var-file="terraform.tfvars.json"
   ```

> After completion, Terraform will output:
>
> * VM public IPs
> * Admin usernames
> * Paths to your SSH key files
Which will be used to generate hosts.ini for Ansible
---

## 4. Build Ansible Inventory

Run the Bash script to generate `hosts.ini`:

```bash
../generate_inventory.sh
```

This script reads the Terraform outputs (from `terraform/terraform.tfstate`) and writes a dynamic inventory file at the repository root.

---

## 5. Configuration and Deployment with Ansible

Execute your playbook to install OS dependencies, configure MySQL, deploy the Java web app, and start the service:

1. **Enter the Ansible directory**

   ```bash
   cd ansible
   ```
1. **Run Playbook**

   ```bash
   ansible-playbook -i hosts.ini site.yaml
   ```
   
* **`site.yaml`** includes roles/tasks for both VMs and the database.
* It will use your `~/.ssh/vm1_key` or `vm2_key` automatically (as defined in `hosts.ini`).

---

## 6. Verify and Access the Application

Once Ansible completes:

In your browser, go to:

   ```
   http://<vm1-ip>:8080
   ```

You should see the Java web application’s homepage.

---

You’re all set!
