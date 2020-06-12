package crypt

import (
	"crypto/cipher"

	"github.com/sirupsen/logrus"
	"golang.org/x/crypto/twofish"
)

type Twofish interface {
	Encrypt(val string) (string, error)
	Decrypt(val string) (string, error)
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

	dec := cipher.NewCBCDecrypter(block, iv)
	enc := cipher.NewCBCEncrypter(block, iv)
	two = &tfMan{dec, enc}

	return nil
}

type tfMan struct {
	block *twofish.Cipher
	iv []byte
}

func (t *tfMan) Encrypt(val string) (string, error) {
	enc := cipher.NewCFBEncrypter(t.block, t.iv)
	enc.XORKeyStream()
}

func (t *tfMan) Decrypt(val string) (string, error) {
	panic("implement me")
}

