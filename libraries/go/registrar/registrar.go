package registrar

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
)

type controller struct {
	ID      string `json:"id"`
	Address string `json:"address"`
	Port    int    `json:"port"`
}

// Register registers a controller to the device registry
func Register(name string, port int) error {

	c := controller{name, getOutboundIP().String(), port}

	data, err := json.Marshal(c)

	if err != nil {
		return err
	}

	resp, err := http.Post("http://localhost:4000/controllers", "application/json; charset=utf-8", bytes.NewReader(data))

	if err != nil {
		return err
	}

	if resp.StatusCode != http.StatusCreated {
		return fmt.Errorf("Invalid Status Code: %d", resp.StatusCode)
	}

	return nil
}

// Unregister a controller
func Unregister(id string) error {
	req, err := http.NewRequest(http.MethodDelete, fmt.Sprintf("http://localhost:4000/controllers/%s", id), nil)

	if err != nil {
		return err
	}

	resp, err := http.DefaultClient.Do(req)

	if err != nil {
		return err
	}

	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("Invalid Status Code: %d", resp.StatusCode)
	}

	return nil
}

func getOutboundIP() net.IP {
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	localAddr := conn.LocalAddr().(*net.UDPAddr)

	return localAddr.IP
}
