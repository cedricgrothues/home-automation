package domain

import "errors"

// Action is a single step in a scene
type Action struct {
	Controller string    `json:"controller"`
	Device     string    `json:"device"`
	Property   *Property `json:"property"`
}

// Validate checks that the action makes sense
func (a *Action) Validate() error {

	if a.Property == nil {
		return errors.New("Property is required")
	}

	if err := a.Property.Validate(); err != nil {
		return err
	}

	if a.Controller == "" || a.Device == "" {
		return errors.New("Invalid action value")
	}

	return nil
}
