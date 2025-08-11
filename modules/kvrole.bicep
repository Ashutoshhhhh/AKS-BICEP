param pricipalObjectId string
param keyVaultId string
param kvName string 
var roleDefinitionId = '00482a5a-887f-4fb3-b363-3b7fe8e74483'

resource kv 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: kvName
  
}
resource kvRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVaultId, pricipalObjectId, roleDefinitionId)
  scope: kv
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: pricipalObjectId
    principalType: 'User'
  }
}
