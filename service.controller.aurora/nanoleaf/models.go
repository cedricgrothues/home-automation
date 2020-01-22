package nanoleaf

// AddUserResponse is returned when adding a new user
type AddUserResponse struct {
	AuthToken *string `json:"auth_token,omitempty"`
}

// OnValue defines th power struct
type OnValue struct {
	Value *bool `json:"value,omitempty"`
}

// RangedValue defines values like brightness, etc.
type RangedValue struct {
	Value    *int `json:"value,omitempty"`
	Max      *int `json:"max,omitempty"`
	Min      *int `json:"min,omitempty"`
	Duration *int `json:"duration,omitempty"`
}

// State defines the base state
type State struct {
	On         *OnValue     `json:"on,omitempty"`
	Brightness *RangedValue `json:"brightness,omitempty"`
	Hue        *RangedValue `json:"hue,omitempty"`
	Sat        *RangedValue `json:"sat,omitempty"`
	CT         *RangedValue `json:"ct,omitempty"`
	ColorMode  *string      `json:"colormode,omitempty"`
}

// Effects defines all effects
type Effects struct {
	Select      *string    `json:"select,omitempty"`
	EffectsList *[]*string `json:"effectsList,omitempty"`
}

// Position defines the panelID
type Position struct {
	PanelID *int     `json:"panelId,omitempty"`
	X       *int     `json:"x,omitempty"`
	Y       *int     `json:"y,omitempty"`
	O       *float64 `json:"o,omitempty"`
}

// Layout defines the panel layout
type Layout struct {
	NumPanels    *int         `json:"numPanels,omitempty"`
	SideLength   *int         `json:"sideLength,omitempty"`
	PositionData *[]*Position `json:"positionData,omitempty"`
}

// PanelLayout defines the panel layout
type PanelLayout struct {
	Layout            *Layout      `json:"layout,omitempty"`
	GlobalOrientation *RangedValue `json:"globalOrientation,omitempty"`
}

// Rhythm defines the rythm module
type Rhythm struct {
	RhythmConnected *bool     `json:"rhythmConnected,omitempty"`
	RhythmActive    *bool     `json:"rhythmActive,omitempty"`
	RhythmID        *int      `json:"rhythmId,omitempty"`
	HardwareVersion *string   `json:"hardwareVersion,omitempty"`
	FirmwareVersion *string   `json:"firmwareVersion,omitempty"`
	AuxAvailable    *bool     `json:"auxAvailable,omitempty"`
	RhythmMode      *int      `json:"rhythmMode,omitempty"`
	RhythmPos       *Position `json:"rhythmPos,omitempty"`
}

// DeviceInfo defines the general device info
type DeviceInfo struct {
	Name            *string      `json:"name"`
	SerialNo        *string      `json:"serialNo"`
	Manufacturer    *string      `json:"manufacturer"`
	FirmwareVersion *string      `json:"firmwareVersion"`
	Model           *string      `json:"model"`
	State           *State       `json:"state"`
	Effects         *Effects     `json:"effects"`
	PanelLayout     *PanelLayout `json:"panelLayout"`
	Rhythm          *Rhythm      `json:"rhythm"`
}
