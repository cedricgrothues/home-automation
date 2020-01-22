# modules.sonos

Available on port `4003`

## Features

- [x] Play
- [x] Pause
- [x] Stop
- [x] Next track
- [x] Previous track
- [ ] Get current transport information(if speaker is playing,paused,stopped)
- [ ] Get information about the currently playing track
	- [ ] Track title
	- [ ] Artist
	- [ ] Album
	- [ ] Album Art (if available)
	- [ ] Track length
	- [ ] Duration played (for example, 30 seconds into a 3 minute song)
	- [ ] Playlist position (for example, item 5 in the playlist)
	- [ ] Track URI
- [x] Mute (or unmute) the speaker
- [x] Get or set the speaker volume
- [ ] Get or set the speaker's bass EQ
- [ ] Get or set the speaker's treble EQ
- [ ] Toggle the speaker's loudness compensation
- [x] Turn on (or off) the white status light on the unit
- [ ] Switch the speaker's source to line-in (doesn't work on the Play:3 since it doesn't have a line-in)
- [ ] Get the speaker's information
	- [ ] Zone Name
	- [ ] Zone Icon
	- [ ] UID (usually something like RINCON_XXXXXXXXXXXXXXXXX)
	- [ ] Serial Number
	- [ ] Software version
	- [ ] Hardware version
	- [ ] MAC Address
	- [ ] Set the speaker's Zone Name
- [x] Find all the Sonos speakers in a network.
- [ ] Put all Sonos speakers in a network into "party mode".
- [ ] "Unjoin" speakers from a group.
- [ ] Manage the Sonos queue (get the items in it, add to it, clear it, play a specific song from it)
- [ ] Get the saved favorite radio stations and shows (title and stream URI)

## Usage

### Lookup device details

**Definition**

`GET /devices/<id>`

**Response**

- 404: device not found
- 200: success

```json (This is most likely going to be updated within the next couple of days)
{
  "identifier": "kitchen-sonos",
  "name": "Sonos on the kitchen counter",
  "address": "123.456.7.890",
  "state": {
    "status": "playing",
    "service": "Apple Music",
    "volume": {
      "type": "int",
      "min": 0,
      "max": 10,
      "value": 3
    },
    "song": "song-uid",
    "artist": "",
  }
}
```

### Lookup device details

**Definition**

`PATCH /devices/<id>`

**Arguments**

- `"volume":int` adjust the device volume

**Response**

- 404: device not found
- 200: success

```json (This is most likely going to be updated within the next couple of days)
{
  "identifier": "kitchen-sonos",
  "name": "Sonos on the kitchen counter",
  "address": "123.456.7.890",
  "state": {
    "status": {
      "status": "paused",
      "service": "Apple Music",
      "song": "song-uid"
    },
    "volume": {
      "type": "int",
      "min": 0,
      "max": 10,
      "value": 3
    }
  }
}
```
