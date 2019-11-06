package helper

// BoolToInt returns either 1 or 0
func BoolToInt(b bool) int {
	if b {
		return 1
	}
	return 0
}
