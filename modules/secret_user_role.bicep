param kvId string
param principalObjectId string
var roleDefinitionId = '4633458b-17de-408a-b874-0445c86b69e6'
param kvName string

resource kv 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: kvName
}

resource kvSecretUserRA 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kvId, principalObjectId, roleDefinitionId)
  scope: kv
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalObjectId
    principalType: 'ServicePrincipal'
  }
}
