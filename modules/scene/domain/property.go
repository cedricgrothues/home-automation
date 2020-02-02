package domain

import "errors"

// Property defines an action property.
// The value is going to be stored as a
// string, it's type will be stored accoringly
type Property struct {
	Name  string      `json:"name"`
	Value interface{} `json:"value"`
}

// Validate checks that the action makes sense
func (p *Property) Validate() error {

	if p.Name == "" || p.Value == "" {
		return errors.New("Invalid property value")
	}

	return nil
}
