package decode

import (
	"io"
	"time"

	"github.com/francoispqt/gojay"

	"github.com/vulpine-io/softask/pkg/model/users"
	"github.com/vulpine-io/softask/pkg/server/api/v1/encode"
)

type dUser struct {
	users.MutableUser
}

func (d *dUser) UnmarshalJSONObject(dec *gojay.Decoder, k string) (err error) {
	switch k {
	case encode.KeyUserId:
		var tmp int64
		if err = dec.Int64(&tmp); err == nil {
			d.MutableUser.SetId(tmp)
		}

	case encode.KeyUserDisplayName:
		var tmp string
		if err = dec.String(&tmp); err == nil {
			d.MutableUser.SetDisplayName(tmp)
		}

	case encode.KeyUserEmail:
		var tmp string
		if err = dec.String(&tmp); err == nil {
			d.MutableUser.SetEmail(tmp)
		}

	case encode.KeyUserCreated:
		var tmp time.Time
		if err = dec.Time(&tmp, time.RFC3339Nano); err == nil {
			d.MutableUser.SetCreated(tmp)
		}
	}

	return
}

func (d *dUser) NKeys() int {
	return 2
}

func DecodeUser(r io.Reader) (users.User, error) {
	dec := gojay.NewDecoder(r)
	defer dec.Release()

	tmp := users.NewUser()
	if err := dec.Object(&dUser{tmp}); err != nil {
		return nil, err
	}

	return tmp, nil
}
