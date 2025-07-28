param location string
param clusterName string
param subnetId string
param enableKeyVaultAddon bool
param enableFileDriverAddon bool
param enableBlobDriver bool

resource aks 'Microsoft.ContainerService/managedClusters@2022-02-01' = {
  name: clusterName
  location: location
  identity:{
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    enableRBAC: true
    kubernetesVersion: '1.30.4'
    addonProfiles: {
      enableKeyVaultSecrets: {
        enabled: enableKeyVaultAddon
      }
      AzureFileCSI: {
        enabled: enableFileDriverAddon
      }
      
    }
    agentPoolProfiles: [
      {
        name: 'systempool'
        mode: 'System'
        count: 1
        vmSize: 'Standard_B2s'
        vnetSubnetID: subnetId
        osType: 'Linux'
        orchestratorVersion: '1.30.4'
      }
    ]
  }
}

output kubeConfig string = aks.listClusterUserCredential().kubeconfigs[0].value
