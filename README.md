# AppFog Env

This module provides easy access to the AppFog services and application environment information from within a running app instance.

## Installation

    npm install appfog-env

## Basic Usage

    var appfog = require('appfog-env');

    console.log(appfog);

## Properties

### .appName [String]

Application name.

### .port [String]

Port number assigned to the app instance.

#### Usage Example

    var server = http.createServer(app).listen(appfog.port || 3000);

### .instanceIndex [Integer]

Zero-based instance index for the current instance. This might be useful when logging or running tasks from only the first instance.

### .services [Array]

Services bound to the app instance.

#### Usage Example

**Get the first service bound to the app:**

    var creds = appfog.services[0].credentials

### .application [Hash]

Parsed from process.env.VCAP_APPLICATION

### .vcapServices [Hash]

Parsed from process.env.VCAP_SERVICES

## Methods

### .getService(name, overrideCreds) [Hash]

Returns the vcap service info for a specified service. Returns null if  no override credentials are provide or the service is not found.

**name** - Name string or regex used to find the service.

**overrideCreds** - If provided the method returns automatically with the overrides without looking for the service.

#### Usage Examples

**Get service by name or exit if not found:**

    var service = appfog.getService('mysql-db-name') || process.exit 1
    var creds = service.credentials

    var client = mysql.createConnection({
       host: creds.hostname || 'localhost',
       user: creds.username,
       password: creds.password,
       database: creds.name,
       port: creds.port || 3306
    });

**Override with a local development database:**

Set a local environment variable with the override credentials:

     export DEV_DATABASE='{ "username": "root", "name": "dev-db-name" }'

Then in code:

     var service = appfog.getService('mysql-db-name', process.env.DEV_DATABASE);
