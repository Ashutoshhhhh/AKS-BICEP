param location string
param resourcePrefix string
param subnetPrefix string
param vnetAddressSpace string

resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
    name: '${resourcePrefix}-vnet'
    location: location
    properties: {
        addressSpace: {
            addressPrefixes:[
                vnetAddressSpace
            ]
        }
        subnets: [
            {
                name: 'aks-subnet'
                properties:{
                    addressPrefix: subnetPrefix
                }
            }
        ]
    }
}

output vnetId string = vnet.id
output subnetId string = 'vnet.properties.subnets[0].id'
