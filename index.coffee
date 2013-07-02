_ = require('underscore')

application = JSON.parse(process.env.VCAP_APPLICATION || "{}")

try
  vcapServices = JSON.parse(process.env.VCAP_SERVICES)
catch err
  vcapServices = {}

services = _.flatten(_.map(vcapServices, (svcs, t) -> svcs))

module.exports =

  appName: application.name
  port: process.env.VCAP_APP_PORT || process.env.PORT
  instanceIndex: application.instance_index
  services: services

  application: application
  vcapServices: vcapServices

  getService: (name, credsOverride) ->
    if credsOverride
      if _.isString(credsOverride)
        service = name: name, credentials: JSON.parse(credsOverride)
      else
        service = name: name, credentials: credsOverride
      console.log "Using overrided credentials for service: " + name
    else
      service = _.find(services, (s) -> s.name.match name )
      if service
        console.log "Using service: " + service.name
      else
        console.error "Could not find service: " + name
    service
