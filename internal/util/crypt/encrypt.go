package crypt

import (
	"crypto/cipher"
	"fmt"

	"github.com/sirupsen/logrus"
	"golang.org/x/crypto/twofish"
)

type Twofish interface {
	Encrypt(val string) string
	Decrypt(val string) string
}

var two Twofish

func GetTwofish() Twofish {
	if two == nil {
		logrus.Fatal("Attempted to retrieve Twofish handler before it was initialized")
	}

	return two
}

func InitTwofish(key, iv []byte) error {
	if two != nil {
		logrus.Fatal("Attempted to initialize Twofish handler more than once")
	}

	block, err := twofish.NewCipher(key)
	if err != nil {
		return err
	}

	two = &tfMan{block, iv}

	return nil
}

type tfMan struct {
	block *twofish.Cipher
	iv []byte
}

func (t *tfMan) Encrypt(val string) string {
	enc := cipher.NewCFBEncrypter(t.block, t.iv)
	raw := []byte(val)
	out := make([]byte, len(raw))
	enc.XORKeyStream(out, raw)
	return fmt.Sprintf("%x", out)
}

func (t *tfMan) Decrypt(val string) string {
	dec := cipher.NewCFBDecrypter(t.block, t.iv)
	raw := []byte(val)
	out := make([]byte, len(raw))
	dec.XORKeyStream(out, raw)
	return fmt.Sprintf()
}

