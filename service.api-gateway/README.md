# service.api-gateway

Available on port `4000`
This service redirects traffic to the according controllers / services

## Usage

**Definition**

`GET /<service-name>/<subquery>`

**Response**

- 404: Not found
- Other status codes depend on the individual services