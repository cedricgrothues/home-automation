# service.api-gateway

Available on port `4000`
This service redirects traffic to the according controllers / services

## Setup
All configurations for `service.api-gateway` are available at ./config.yaml.

Example config.yaml:
```yaml
port: 4000

services:
    service.device-registry:
        name: Device Registry
        prefix: service.device-registry
        url: "http://192.168.2.117:4001"
    service.controller.sonoff:
        name: Sonoff Controller
        prefix: service.controller.sonoff
        url: "http://192.168.2.117:4002"
    service.controller.sonos:
        name: Sonos Controller
        prefix: service.controller.sonos
        url: "http://192.168.2.117:4003"
```

## Usage

**Definition**

`* /<service-name>/<subquery>`

**Response**

- 404: Not found
- Other status codes depend on the individual services
