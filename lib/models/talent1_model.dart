class TalentModel1 {
  int id;
  String type;
  String mediaUrl;
  String imageUrl;
  String description;
  String firstName;
  String lastName;
  String country;
  String city;
  String phoneNumber;
  String currentJobTitle;
  String companyName;
  TalentModel1({
    this.id,
    this.type,
    this.mediaUrl,
    this.imageUrl,
    this.description,
    this.firstName,
    this.lastName,
    this.country,
    this.city,
    this.phoneNumber,
    this.currentJobTitle,
    this.companyName,
  });
  static final dumpListData = [
    TalentModel1(
      id: 3,
      type: "Video",
      firstName: "Ramiro",
      lastName: "Talavera",
      mediaUrl: "",
      imageUrl:
          "https://images.unsplash.com/photo-1549068106-b024baf5062d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      country: "Saudi Native",
      city: "Riyadh",
      phoneNumber: "123456789",
      currentJobTitle: "Talent Developer",
      companyName: "Self Employed",
    ),
    TalentModel1(
      id: 1,
      type: "Video",
      firstName: "Beca",
      lastName: "Lway",
      mediaUrl: "",
      imageUrl:
          "https://images.unsplash.com/photo-1569124589354-615739ae007b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      country: "Saudi Native",
      city: "Riyadh",
      phoneNumber: "123456789",
      currentJobTitle: "Talent Developer",
      companyName: "Self Employed",
    ),
    TalentModel1(
      id: 2,
      type: "Video",
      firstName: "Mariela",
      lastName: "Guajardo",
      mediaUrl: "",
      imageUrl:
          "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=333&q=80",
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      country: "Saudi Native",
      city: "Riyadh",
      phoneNumber: "123456789",
      currentJobTitle: "Talent Developer",
      companyName: "Self Employed",
    ),
    TalentModel1(
      id: 4,
      type: "image",
      firstName: "Marcos",
      lastName: "Reine",
      mediaUrl: "",
      imageUrl:
          "https://images.unsplash.com/photo-1493863641943-9b68992a8d07?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=739&q=80",
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      country: "Saudi Native",
      city: "Riyadh",
      phoneNumber: "123456789",
      currentJobTitle: "Talent Developer",
      companyName: "Self Employed",
    ),
  ];
}
