
class Profile{
  String? phone,firstname,uid,signin_method,lastname,email,gender,city,state,zipcode,country,longitude,latitude;

  Profile( this.email,this.uid,this.firstname, this.lastname, this.gender, this.city,
      this.state, this.zipcode, this.country, this.longitude, this.latitude,this.phone);

  Map<String, dynamic> toMap() {
    return {
      'phone':phone,
      'firstname': firstname,
      'lastname': lastname,
      'email':email,
      'gender':gender,
      'city':city,
      'state':state,
      'zipcode':zipcode,
      'country':country,
      'longitude':longitude,
      'latitude':latitude,
      'uid':uid,

    };
  }


}