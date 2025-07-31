param clusterName string
param location string

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-07-01'= {
  name: '${clusterName}-static-ip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
