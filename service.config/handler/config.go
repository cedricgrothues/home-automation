package handler

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
)

// Config reseambles the parsed config.json file
type Config struct {
	path    string
	Version string `json:"version"`
	Polling struct {
		Enabled  bool `json:"enabled"`
		Interval int  `json:"interval"`
	} `json:"polling"`
	Environment string    `json:"environment"`
	Services    []Service `json:"services"`
}

// Service reseambles a single home-automation service
type Service struct {
	Identifier string                 `json:"identifier"`
	Friendly   string                 `json:"friendly"`
	Port       int                    `json:"port"`
	Options    map[string]interface{} `json:"options"`
}

// Read config files
func Read(path string) (*Config, error) {
	b, err := ioutil.ReadFile(path)

	if err != nil {
		return nil, err
	}

	var c Config
	c.path = path

	json.Unmarshal(b, &c)

	return &c, nil
}

// Update reads the specified file and updates the config's values accordingly
func (c *Config) Update() error {
	b, err := ioutil.ReadFile(c.path)

	if err != nil {
		return err
	}

	json.Unmarshal(b, &c)

	return nil
}

// Watch changes in config files
func (c *Config) Watch(d time.Duration) {
	for {
		if err := c.Update(); err != nil {
			fmt.Printf("Failed to reload %s! Error: %v\n", c.path, err)
		}

		time.Sleep(d)
	}
}

// Get retrieves a specific service config from the config file
func (c *Config) Get(identifier string) (*Service, error) {
	for i := range c.Services {
		if c.Services[i].Identifier == identifier {
			return &c.Services[i], nil
		}
	}

	return nil, fmt.Errorf("Service %s not found in %s", identifier, c.path)
}

// ReadConfig returns a config for a givend device
func (c *Config) ReadConfig(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	service, err := c.Get(p[0].Value)

	if err != nil {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusNotFound)

		w.Write([]byte(fmt.Sprintf("{\"message\":\"%v\"}", err)))
		return
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(service)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// ReloadConfig reloads the config
func (c *Config) ReloadConfig(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	err := c.Update()

	if err != nil {
		panic("could not reload config file")
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	w.Write([]byte("{\"message\": \"Config file reloaded successfully\"}"))
}
