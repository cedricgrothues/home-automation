# service.api-gateway

Available on port `4000`
This service redirects traffic to the according controllers / services

## Setup
All configurations for `service.api-gateway` are available at ./config.json.

Example config.yaml:
```json
{
    "port": 4000,
    "services": [
        {
            "identifier": "service.device-registry",
            "name": "Device Registry",
            "upstream": "http://service.device-registry:4001"
        },
        {
            "identifier": "service.controller.sonoff",
            "name": "Sonoff Controller",
            "upstream": "http://service.controller.sonoff:4002"
        },
        {
            "identifier": "service.controller.sonos",
            "name": "Sonos Controller",
            "upstream": "http://service.controller.sonos:4003"
        },
        {
            "identifier": "service.controller.aurora",
            "name": "Nanoleaf Aurora Controller",
            "upstream": "http://service.controller.aurora:4004"
        }
    ]
}
```

## Usage

**Definition**

`* /<service-name>/<subquery>`

**Response**

- 404: Not found
- Other status codes depend on the individual services
