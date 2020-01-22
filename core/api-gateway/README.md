# core.api-gateway

Available on port `4000`
This service redirects traffic to the according controllers / services

## Setup
All configurations for `core.api-gateway` are available at ./config.json.

Example config.yaml:
```json
{
    "port": 4000,
    "services": [
        {
            "identifier": "core.device-registry",
            "name": "Device Registry",
            "upstream": "http://core.device-registry:4001"
        },
        {
            "identifier": "modules.sonoff",
            "name": "Sonoff Controller",
            "upstream": "http://modules.sonoff:4002"
        },
        {
            "identifier": "modules.sonos",
            "name": "Sonos Controller",
            "upstream": "http://modules.sonos:4003"
        },
        {
            "identifier": "modules.aurora",
            "name": "Nanoleaf Aurora Controller",
            "upstream": "http://modules.aurora:4004"
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
