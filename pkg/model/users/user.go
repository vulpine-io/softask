package users

type User interface {
	Id() int64
	DisplayName() string
	Email() string

}

type MutableUser interface {
	User

	SetId(id int64) MutableUser
	SetDisplayName(name string) MutableUser
}

func NewUser() MutableUser {
	return new(user)
}

type user struct {
	id   int64
	name string
}

func (u *user) Id() int64 {
	return u.id
}

func (u *user) DisplayName() string {
	return u.name
}

func (u *user) SetId(id int64) MutableUser {
	u.id = id
	return u
}

func (u *user) SetDisplayName(name string) MutableUser {
	u.name = name
	return u
}
