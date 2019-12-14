package dao

import (
	"encoding/xml"
	"errors"
	"fmt"
	"regexp"
)

// Play : Start the media playback
func (s *Sonos) Play() error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Speed"] = 1

	_, err := transportService.request(s.Address, "Play", options)

	if err != nil {
		return err
	}

	return nil
}

// PlayURI plays the given uri on the device
func (s *Sonos) PlayURI(uri, meta string) error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["CurrentURI"] = uri
	options["CurrentURIMetaData"] = meta

	_, err := transportService.request(s.Address, "SetAVTransportURI", options)

	if err != nil {
		return err
	}

	err = s.Play()

	if err != nil {
		return err
	}

	return nil
}

// Pause the media playback
func (s *Sonos) Pause() error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0

	_, err := transportService.request(s.Address, "Pause", options)

	if err != nil {
		return err
	}

	return nil
}

// Stop the media playback
func (s *Sonos) Stop() error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0

	_, err := transportService.request(s.Address, "Stop", options)

	if err != nil {
		return err
	}

	return nil
}

// Next track
func (s *Sonos) Next() error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0

	_, err := transportService.request(s.Address, "Next", options)

	if err != nil {
		return err
	}

	return nil
}

// Seek jups to a specific timestamp in the song
func (s *Sonos) Seek(timestamp string) error {
	if ok, _ := regexp.Match("^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$", []byte(timestamp)); !ok {
		return errors.New("invalid timestamp, use HH:MM:SS format")
	}

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Unit"] = "REL_TIME"
	options["Target"] = timestamp

	_, err := transportService.request(s.Address, "Seek", options)

	if err != nil {
		return err
	}

	// TODO : FIND OUT WHY THIS IS MOT WORKING

	return nil
}

// Previous track
func (s *Sonos) Previous() error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0

	_, err := transportService.request(s.Address, "Previous", options)

	if err != nil {
		return err
	}

	return nil
}

// GetPositionInfo does that
func (s *Sonos) GetPositionInfo() error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0

	_, err := transportService.request(s.Address, "GetPositionInfo", options)

	if err != nil {
		return err
	}

	return nil
}

// GetCurrentTrack returns a pointer to a track struct with useful information about the current track
func (s *Sonos) GetCurrentTrack() (*Track, error) {
	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"

	xmlString, err := transportService.request(s.Address, "GetPositionInfo", options)

	if err != nil {
		return nil, err
	}

	response := &track{}

	err = xml.Unmarshal([]byte(xmlString), response)

	if err != nil {
		return nil, err
	}

	fmt.Println(response.TrackURI)

	response.TrackMetaData.DIDLLite = &didllite{}
	err = xml.Unmarshal([]byte(response.TrackMetaData.Text), response.TrackMetaData.DIDLLite)

	if err != nil {
		return nil, err
	}

	track := &Track{}
	track.Title = response.TrackMetaData.DIDLLite.Title
	track.Artist = response.TrackMetaData.DIDLLite.Creator

	track.Album = &album{}
	track.Album.Title = response.TrackMetaData.DIDLLite.Album
	track.Album.Cover = response.TrackMetaData.DIDLLite.AlbumArtURI

	track.Duration = response.TrackDuration
	track.Position = response.RelTime
	track.URI = response.TrackURI

	return track, nil
}

// Track is the struct that is actually returned, when GetCurrentTrack is called
type Track struct {
	Title    string `json:"title"`
	Artist   string `json:"artist"`
	Album    *album `json:"album"`
	Duration string `json:"duration"`
	Position string `json:"position"`
	URI      string `json:"uri"`
}

type album struct {
	Title string `json:"title"`
	Cover string `json:"cover"`
}

// Structs to unmarshall Sonos's xml response
type track struct {
	TrackDuration string `xml:"Body>GetPositionInfoResponse>TrackDuration"`
	TrackMetaData struct {
		Text     string `xml:",chardata"`
		DIDLLite *didllite
	} `xml:"Body>GetPositionInfoResponse>TrackMetaData"`
	TrackURI string `xml:"Body>GetPositionInfoResponse>TrackURI"`
	RelTime  string `xml:"Body>GetPositionInfoResponse>RelTime"`
}

type didllite struct {
	AlbumArtURI string `xml:"item>albumArtURI"`
	Title       string `xml:"item>title"`
	Creator     string `xml:"item>creator"`
	Album       string `xml:"item>album"`
	Tiid        string `xml:"item>tiid"`
}
