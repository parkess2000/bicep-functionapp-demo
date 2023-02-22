param location string
param resourceGroupName string
param functionAppName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${functionAppName}-appServicePlan'
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource functionExtension 'Microsoft.Web/sites/siteextensions@2021-02-01' = {
  name: 'Microsoft.Azure.Functions.Extensions'
  location: functionApp.location
  kind: 'functionapp'
  properties: {
    version: '~4'
  }
  dependsOn: [
    functionApp
  ]
}

module function1 './function.bicep' = {
  name: 'function1'
  params: {
    location: location
    resourceGroupName: resourceGroupName
    functionAppName: functionAppName
    functionName: 'Function1'
  }
}

module function2 './function.bicep' = {
  name: 'function2'
  params: {
    location: location
    resourceGroupName: resourceGroupName
    functionAppName: functionAppName
    functionName: 'Function2'
  }
}

output functionAppUrl string = functionApp.properties.defaultHostName

output function1Name string = function1.outputs.functionName
output function1Url string = function1.outputs.functionUrl

output function2Name string = function2.outputs.functionName
output function2Url string = function2.outputs.functionUrl
