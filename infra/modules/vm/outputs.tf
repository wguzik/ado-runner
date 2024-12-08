output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.pip.ip_address
}

output "password_secret_name" {
  description = "The name of the Key Vault secret containing the VM password"
  value       = azurerm_key_vault_secret.vm_password.name
} 