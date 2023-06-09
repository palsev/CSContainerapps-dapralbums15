param storage_account_name string
param storage_container_name string
param containerAppsEnvName string
param secretStoreName string

resource caEnvironment  'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppsEnvName
}

resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-06-01-preview' = {
  parent: caEnvironment
  name: 'statestore'
  properties: {
    componentType: 'state.azure.blobstorage'
    version: 'v1'
    ignoreErrors: false
    initTimeout: '5s'
    metadata: [
      {
        name: 'accountName'
        value: storage_account_name
      }
      {
        name: 'containerName'
        value: storage_container_name
      }
      {
        name: 'accountKey'
        secretRef: 'storageaccountkey'
      }
    ]
    secretStoreComponent: secretStoreName
    scopes: ['album-api']
  }
}
