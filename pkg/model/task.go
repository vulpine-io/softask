package model

import "time"

type Task interface {
	Id() int64
	Key() string
	Name() string
	Description() string
	CreatedBy() User
	CreatedOn() time.Time
	LastUpdated() time.Time
}

type MutableTask interface {
	Task

	SetId()
	SetName(name string) MutableTask
	SetDescription(desc string) MutableTask
	SetCreatedOn(on time.Time) MutableTask
	SetCreatedBy(user User) MutableTask
	SetLastUpdate(on time.Time) MutableTask
}

type Step interface {
}
