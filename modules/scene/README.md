# modules.scene

Available on port `4006`
This service is used to define sequences of actions

Example Scene:
```json
{
  "id": 134552433,
  "name": "Gute Nacht!",
  "owner": "Cedric Grothues",
  "actions": [
    {
      "controller": "modules.sonos",
      "device": "bedroom-player",
      "property": "playing",
      "value": false
    }
  ]
}
```
