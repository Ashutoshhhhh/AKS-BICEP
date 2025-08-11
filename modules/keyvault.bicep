param location string
param kvName string 
param enablePurgeProteciton bool = true

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01'={
  location: location
  name: kvName
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enablePurgeProtection: enablePurgeProteciton
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'

    }
  }
}

output keyVaultId string = keyVault.id
