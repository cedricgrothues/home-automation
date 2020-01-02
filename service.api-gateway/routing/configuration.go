package routing

import (
	"io/ioutil"

	"gopkg.in/yaml.v2"
)

// Configuration represents the config loaded from the YAML file
type Configuration struct {
	Port     int                 `yaml:"port"`
	Services map[string]*Service `yaml:"services"`
}

// Service is a single Service definition
type Service struct {
	Name     string   `yaml:"name"`
	Prefix   string   `yaml:"prefix"`
	Upstream string   `yaml:"upstream"`
	Plugins  []Plugin `yaml:"plugins"`
}

// Plugin is the configuration for a particular plugin
type Plugin struct {
	Name    string                 `yaml:"name"`
	Enabled bool                   `yaml:"enabled"`
	Config  map[string]interface{} `yaml:"config"`
}

// Load reads a YAML file and returns a Configuration struct
func Load(filename string) (*Configuration, error) {
	b, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	var c Configuration
	err = yaml.Unmarshal(b, &c)
	if err != nil {
		return nil, err
	}

	return &c, nil
}
