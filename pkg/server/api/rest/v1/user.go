package v1

import (
	"github.com/francoispqt/gojay"
	"github.com/vulpine-io/softask/pkg/model"
	"io"
)

const (
	KeyUserId          = "id"
	KeyUserDisplayName = "displayName"
)

func EncodeUser(w io.Writer, u model.User) error {
	enc := gojay.NewEncoder(w)
	defer enc.Release()

	enc.AppendByte('{')
	enc.Int64Key(KeyUserId, u.Id())
	enc.StringKey(KeyUserDisplayName, u.DisplayName())
	enc.AppendByte('}')

	_, err := enc.Write()

	return err
}
