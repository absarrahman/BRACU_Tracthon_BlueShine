import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String _firstName,
      _lastName,
      _address,
      _area,
      _city,
      _zipCode,
      _birthday,
      _email;

  User(this._firstName, this._lastName, this._address, this._area, this._city,
      this._zipCode, this._birthday, this._email);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> m = Map<String, dynamic>();
    m["first_name"] = this._firstName;
    m["last_name"] = this._lastName;
    m["address"] = this._address;
    m["area"] = this._area;
    m["city"] = this._city;
    m["zip"] = this._zipCode;
    m["birthday"] = this._birthday;
    m["email"] = this._email;
    return m;
  }
}
