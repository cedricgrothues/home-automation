package models

// Device defines instance of a device
type Device struct {
	ID         string `json:"id"`
	Name       string `json:"name"`
	Type       string `json:"type"`
	Controller string `json:"controller"`
	Address    string `json:"address"`
	Room       *Room  `json:"room,omitempty"`
	RoomID     string `json:"room_id,omitempty"`
}

// Room has an id, name and devices
type Room struct {
	ID      string   `json:"id"`
	Name    string   `json:"name"`
	Devices []Device `json:"devices,omitempty"`
}
