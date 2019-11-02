package config

import (
	"fmt"
	"io/ioutil"
	"reflect"
	"sync"
	"time"

	"gopkg.in/yaml.v2"
)

// Config is a wrapper around the config file's path
type Config struct {
	data map[string]interface{}
	Path string
	lock sync.RWMutex
}

// Load reads config data from the file at c.path
func (c *Config) Load() error {
	data, err := ioutil.ReadFile(c.Path)

	if err != nil {
		return err
	}

	err = c.from(data)
	if err != nil {
		return fmt.Errorf("failed to set config from bytes: %v", err)
	}

	return nil
}

// Watch updates the config every d duration
func (c *Config) Watch(d time.Duration) {
	for {
		if err := c.Load(); err != nil {
			fmt.Println("Failed to reload config")
		}

		time.Sleep(d)
	}
}

// Get returns the data for other keys
func (c *Config) Get(k string) (interface{}, error) {
	c.lock.RLock()
	defer c.lock.RUnlock()

	if _, ok := c.data[k]; !ok {
		return nil, fmt.Errorf("no value for key %s", k)
	}

	return c.data[k], nil
}

// Service returns the config for the given service
func (c *Config) Service(s string) (map[string]interface{}, error) {
	c.lock.RLock()
	defer c.lock.RUnlock()

	services, ok := c.data["services"].(map[string]interface{})

	if !ok {
		return nil, fmt.Errorf("services is not a map")
	}

	if _, ok := services[s]; !ok {
		return nil, fmt.Errorf("no config for service")
	}

	config, ok := services[s].(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("service config is not a map")
	}

	return config, nil
}

func (c *Config) from(bytes []byte) error {
	var raw map[interface{}]interface{}
	if err := yaml.Unmarshal(bytes, &raw); err != nil {
		return err
	}

	config, err := convert(raw)
	if err != nil {
		return err
	}

	if reflect.DeepEqual(config, c.data) {
		return nil
	}

	c.lock.Lock()
	defer c.lock.Unlock()
	c.data = config

	return nil
}

// convert recursively iterates over a map with interface{} keys and asserts that they are strings
func convert(m map[interface{}]interface{}) (map[string]interface{}, error) {
	n := make(map[string]interface{})

	for k, v := range m {
		str, ok := k.(string)
		if !ok {
			return nil, fmt.Errorf("Key is not a String")
		}

		if vMap, ok := v.(map[interface{}]interface{}); ok {
			var err error
			v, err = convert(vMap)
			if err != nil {
				return nil, err
			}
		}

		n[str] = v
	}

	return n, nil
}
