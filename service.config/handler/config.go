package handler

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"time"
)

// Config reseambles the parsed config.json file
type Config struct {
	Version  string    `json:"version"`
	Services []Service `json:"services"`
}

// Service reseambles a single home-automation service
type Service struct {
	Identifier string `json:"identifier"`
	Friendly   string `json:"friendly"`
	Port       int    `json:"port"`
	// Options    struct{} `json:"options"`
}

// Read config files
func Read(path string) (*Config, error) {
	b, err := ioutil.ReadFile(path)

	if err != nil {
		return err
	}

	var c Config

	json.Unmarshal(b, &c)

	return nil, nil
}

// Watch changes in config files
func (h *ConfigHandler) Watch(d time.Duration) {
	for {
		if err := h.Read(); err != nil {
			fmt.Printf("Failed to reload %s! Error: %v\n", h.Path, err)
		}

		fmt.Println(h.Config.Version)

		time.Sleep(d)
	}
}
