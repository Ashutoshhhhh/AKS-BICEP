
param uamiName string
param ficName string
param oidcIssuer string
param k8sNamespace string
param k8sServiceAccount string 

var subject = 'system:serviceaccount:${k8sNamespace}:${k8sServiceAccount}'

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: uamiName
}

resource fic 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  parent: uami
  name: ficName
  properties: { 
    issuer: oidcIssuer
    subject: subject
    audiences: [
      'api://AzureADTokenExchange'
      
    ]
    
  }
}
