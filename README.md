# Dart, Flutter & AWS

Another simple POC, creating an offline AWS Datastore with Amplify

Target: 

* Offline DB for Flutter Applications (Android/IOS)
* Querying and Manipulating Data

As the application will not synchronize, there is no need for an AWS account. You still need to install the NodeJS modules, to use the cli commands as example from the sandbox:

```
amplify pull --sandboxId XXXXXXXXXXXXXXXX  
```

Documentation points:

https://docs.amplify.aws/start/q/integration/flutter/

https://aws.amazon.com/amplify/datastore/

Online Application creating the Data Model and the Skeleton for GraphQL for accessing and manipulating the data: 

https://sandbox.amplifyapp.com/
