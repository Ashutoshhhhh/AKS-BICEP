targetScope = 'resourceGroup'

param location string
param resourcePrefix string
param vnetAddressSpace string
param subnetPrefix string

module network './modules/network.bicep' = {
    name: 'networkModule'
    params: {
      location: location
      resourcePrefix: resourcePrefix
      vnetAddressSpace: vnetAddressSpace   
      subnetPrefix: subnetPrefix
    }
}

param clusterName string
param nodePoolName string
param nodeCount int
param minNodeCount int
param maxNodeCount int
param vmSize string
param enableKeyVaultAddon bool = true
param enableFileDriver bool = true
param enableBlobDriver bool = true
module aksCluster './modules/aks-cluster.bicep' = {
  name: 'aksClusterDeploy'
  params: {
    location: location
    clusterName: clusterName
    subnetId: network.outputs.subnetId
    enableKeyVaultAddon: enableKeyVaultAddon
    enableFileDriverAddon: enableFileDriver
    enableBlobDriver: enableBlobDriver
  }
}

module nodepool'./modules/nodepool.bicep' = {
  dependsOn: [
    aksCluster
    network
  ]
  name: 'nodePoolDeploy'
  params: {
    clusterName: clusterName
    nodePoolName: nodePoolName
    nodeCount: nodeCount
    minNodeCount: minNodeCount
    maxNodeCount: maxNodeCount
    vmSize: vmSize
  }
}

// module staticcip './modules/static-ip.bicep' = {
//   name: 'staticIpDeply'
//   params: {
//     location: location
//     clusterName: clusterName

//   }
// }
param kvName string

module keyVault './modules/keyvault.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    location: location
    kvName: kvName
    
  }
}
param pricipalObjectId string

module kvAdmin './modules/kvrole.bicep' = {
  name: 'keyVaultAdminRole'
  params: {
    pricipalObjectId: pricipalObjectId
    keyVaultId: keyVault.outputs.keyVaultId
    kvName: kvName
    
    
  }
}

param appSecretName string

@secure()
param appSecretValue string

module kvSecret './modules/kvsecret.bicep'= {
  name: 'keyVaultSecret'
  params: {
    keyVaultName: kvName
    appSecretName: appSecretName
    appSecretValue: appSecretValue
    
  }
}

param uamiName string

module uami './modules/uami.bicep' = {
  name: 'uamiDeploy'
  params: {
    location: location
    uamiName: uamiName
  }
}

module kvSecretUserRole './modules/secret_user_role.bicep'= {
  name: 'kvSecretUserRole'
  params: {
    kvId: keyVault.outputs.keyVaultId
    principalObjectId: uami.outputs.uamiId
    kvName: kvName
  }
}


param ficName string
param k8sNamespace string
param k8sServiceAccount string

module uamiFic './modules/uami-fic.bicep' = {
  name: 'uamiFicDeploy'
  params: {
    uamiName: uamiName
    ficName: ficName
    oidcIssuer: aksCluster.outputs.oidcIssuer
    k8sNamespace: k8sNamespace
    k8sServiceAccount: k8sServiceAccount
  }
}
