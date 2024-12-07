output "key_vault_id" {
  value = azurerm_key_vault.vault.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.vault.vault_uri
} 