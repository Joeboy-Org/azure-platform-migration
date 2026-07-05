subscription_id = "YOUR_PROD_SUBSCRIPTION_ID"
environment     = "prod"
project         = "apm"
location        = "eastus"

allowed_ssh_cidrs = ["YOUR_IP/32"]
allowed_rdp_cidrs = ["YOUR_IP/32"]

# Set secrets via environment variables:
# export TF_VAR_vm_admin_password="..."
# export TF_VAR_windows_vm_admin_password="..."
