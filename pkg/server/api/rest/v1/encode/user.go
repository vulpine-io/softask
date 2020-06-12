package encode

import (
	"github.com/francoispqt/gojay"
	"github.com/vulpine-io/softask/pkg/model/users"
	"io"
	"time"
)

const (
	KeyUserId          = "id"
	KeyUserDisplayName = "displayName"
	KeyUserEmail       = "email"
	KeyUserCreated     = "created"
)

func EncodeFullUser(w io.Writer, u users.User) error {
	enc := gojay.NewEncoder(w)
	defer enc.Release()

	enc.AppendByte('{')
	enc.Int64Key(KeyUserId, u.Id())
	enc.StringKey(KeyUserDisplayName, u.DisplayName())
	enc.StringKey(KeyUserEmail, u.Email())

	t := u.Created()
	enc.TimeKey(KeyUserCreated, &t, time.RFC3339Nano)
	enc.AppendByte('}')

	_, err := enc.Write()

	return err
}
