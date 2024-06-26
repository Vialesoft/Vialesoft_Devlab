package main;

import (
	"gopkg.in/mgo.v2"
);

func getCollection(servidor string, bd string, collection string) *mgo.Collection {
	session := getSession(servidor);

	return session.DB(bd).C(collection); //C = Collection
}

//Conexión a la BD MongoDB
func getSession(servidor string) *mgo.Session {
	session, err := mgo.Dial(servidor);

	if (err != nil) {
		panic(err);
	}

	return session;
}