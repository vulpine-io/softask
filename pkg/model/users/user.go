package users

import "time"

type User interface {
	Id() int64
	DisplayName() string
	Email() string
	Created() time.Time
}

type MutableUser interface {
	User

	SetId(id int64) MutableUser
	SetDisplayName(name string) MutableUser
	SetEmail(email string) MutableUser
	SetCreated(at time.Time) MutableUser
}

func NewUser() MutableUser {
	return new(user)
}

type user struct {
	id    int64
	name  string
	email string
	created time.Time
}

func (u *user) Id() int64 {
	return u.id
}

func (u *user) SetId(id int64) MutableUser {
	u.id = id
	return u
}

func (u *user) DisplayName() string {
	return u.name
}

func (u *user) SetDisplayName(name string) MutableUser {
	u.name = name
	return u
}

func (u *user) Email() string {
	return u.email
}

func (u *user) SetEmail(email string) MutableUser {
	u.email = email
	return u
}

func (u *user) Created() time.Time {
	return u.created
}

func (u *user) SetCreated(at time.Time) MutableUser {
	u.created = at
	return u
}
