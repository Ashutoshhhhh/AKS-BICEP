param clusterName string
param nodePoolName string
param nodeCount int
param minNodeCount int
param maxNodeCount int
param vmSize string

resource pool 'Microsoft.ContainerService/managedClusters/agentPools@2024-02-01'= {
  name: '${clusterName}/${nodePoolName}'
  properties: {
    count: nodeCount
    minCount: minNodeCount
    maxCount: maxNodeCount
    vmSize: vmSize
    mode: 'User'
    availabilityZones: [
      '2'
    ]
    enableAutoScaling: true
  }
}
