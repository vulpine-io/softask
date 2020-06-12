package crypt

import (
	"crypto/sha256"
	"fmt"
)

func Hash(val string) (string, error) {
	tmp := sha256.New()

	if _, err := tmp.Write([]byte(val)); err != nil {
		return "", err
	}

	return fmt.Sprintf("%x", tmp.Sum(nil)), nil
}
