
param appSecretName string
@secure()
param appSecretValue string 
param keyVaultName string

resource kv 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: keyVaultName
  
}
resource secret 'Microsoft.KeyVault/vaults/secrets@2024-11-01' = {
  
  parent: kv
  name:appSecretName
  properties: {
    value: appSecretValue
  }
}
