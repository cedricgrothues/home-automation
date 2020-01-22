package routing

import (
	"encoding/json"
	"os"
)

// Configuration represents the config loaded from the YAML file
type Configuration struct {
	Port     int        `json:"port"`
	Services []*Service `json:"services"`
}

// Service is a single Service definition
type Service struct {
	Name       string   `json:"name"`
	Identifier string   `json:"identifier"`
	Upstream   string   `json:"upstream"`
	Plugins    []Plugin `json:"plugins"`
}

// Plugin is the configuration for a particular plugin
type Plugin struct {
	Name    string                 `json:"name"`
	Enabled bool                   `json:"enabled"`
	Config  map[string]interface{} `json:"config"`
}

// Load reads a JSON file and returns a Configuration struct
func Load(filename string) (*Configuration, error) {
	f, err := os.Open(filename)

	if err != nil {
		return nil, err
	}

	defer f.Close()

	var c Configuration

	err = json.NewDecoder(f).Decode(&c)

	if err != nil {
		return nil, err
	}

	return &c, nil
}
