package domain

import "errors"

// Scene represents a set of actions
type Scene struct {
	ID      string    `json:"id"`
	Name    string    `json:"name"`
	Owner   string    `json:"owner"`
	Actions []*Action `json:"actions"`
}

// Validate checks that the scene makes sense
func (s *Scene) Validate() error {

	if s.ID == "" || s.Name == "" || s.Owner == "" || len(s.ID) > 20 {
		return errors.New("Invalid scene value")
	}

	if len(s.Actions) <= 0 {
		return errors.New("A minimum of one action is required")
	}

	for _, action := range s.Actions {
		if err := action.Validate(); err != nil {
			return err
		}
	}

	return nil
}
