param location string
param resourceGroupName string
param functionAppName string
param functionName string

resource function 'Microsoft.Web/sites/functions@2021-02-01' = {
  name: functionName
  location: location
  properties: {
    config: {
      bindingExtensions: {
        http: {
          routes: [
            {
              routeTemplate: 'api/{name}',
              methods: [
                'get',
                'post'
              ]
            }
          ]
        }
      }
    }
    entryPoint: '${functionName}.Function.Run'
    scriptFile: '${functionName}.dll'
  }
  dependsOn: [
    'Microsoft.Web/sites/siteextensions/Microsoft.Azure.Functions.Extensions',
    'Microsoft.Web/sites/functions'
  ]
}

resource packageReference 'Microsoft.Web/sites/functions/extensions@2021-02-01' = {
  name: 'Microsoft.Extensions.DependencyInjection'
  properties: {
    version: '[3.1.14, 4.0.0)'
  }
  dependsOn: [
    function
  ]
}

output functionName string = function.properties.name
output functionUrl string = function.outputs.invokeUrl
