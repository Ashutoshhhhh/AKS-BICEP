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
