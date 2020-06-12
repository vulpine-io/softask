package decode

import (
	"github.com/francoispqt/gojay"
	"github.com/vulpine-io/softask/pkg/model/users"
	v1 "github.com/vulpine-io/softask/pkg/server/api/rest/v1"
	"io"
)

type dUser struct {
	users.MutableUser
}

func (d *dUser) UnmarshalJSONObject(dec *gojay.Decoder, k string) (err error) {
	switch k {
	case v1.KeyUserId:
		var tmp int64
		if err = dec.Int64(&tmp); err != nil {
			d.MutableUser.SetId(tmp)
		}
	case v1.KeyUserDisplayName:
		var tmp string
		if err = dec.String(&tmp); err != nil {
			d.MutableUser.SetDisplayName(tmp)
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
