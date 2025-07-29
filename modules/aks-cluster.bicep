@description('Azure region for all resources')
param location string

@description('AKS cluster name')
param clusterName string

@description('Subnet resource ID')
param subnetId string

@description('Enable Azure Key Vault Secrets CSI Driver add-on')
param enableKeyVaultAddon bool = false

@description('Enable Azure Files CSI Driver')
param enableFileDriverAddon bool = false

@description('Enable Azure Blob CSI Driver')
param enableBlobDriver bool = false

// Use an API version that supports storageProfile
resource aks 'Microsoft.ContainerService/managedClusters@2023-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    kubernetesVersion: '1.30.4'
    enableRBAC: true

    // Valid addonProfiles in this API version
    addonProfiles: {
      // Key Vault provider for Secrets Store CSI driver
      azureKeyvaultSecretsProvider: {
        enabled: enableKeyVaultAddon
      }
    }

    // Configure CSI drivers
    storageProfile: {
      // Azure Files CSI driver
      fileCSIDriver: {
        enabled: enableFileDriverAddon
      }
      // Azure Blob CSI driver
      blobCSIDriver: {
        enabled: enableBlobDriver
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


