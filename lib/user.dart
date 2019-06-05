class User {
  final String name;
  final String surname;
  final String image;
  final String home;
  final String work;
  final String address;
  final String email;

  User(this.name, this.surname, this.image, this.email, this.address, this.home,
      this.work);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        surname = json['surname'],
        image = json['image'],
        email = json['contactDetails']['email'],
        home = json['contactDetails']['phones']['home'],
        work = json['contactDetails']['phones']['work'],
        address = json['contactDetails']['address'];

}