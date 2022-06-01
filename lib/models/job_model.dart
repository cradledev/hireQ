class JobModel {
  int id;
  String logo;
  String imageUrl;
  String description;
  String title;
  String requirement;
  String country;
  String city;
  String companyName;
  JobModel({
    this.id,
    this.logo,
    this.imageUrl,
    this.description,
    this.title,
    this.requirement,
    this.country,
    this.city,
    this.companyName,
  });
  static final dumpListData = [
    JobModel(
      id: 3,
      title: "Project Manager",
      logo: "https://picsum.photos/128/128?random=1",
      imageUrl:
          'https://images.pexels.com/photos/33688/delicate-arch-night-stars-landscape.jpg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          ' playas de arena blanca, sitios arqueológicos, parques '
          ' playas de arena blanca, sitios arqueológicos, parques '
          ' playas de arena blanca, sitios arqueológicos, parques '
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      requirement:
          "You have strong React experience combined with an advanced knowledge of HTML, CSS and WC3 standards You have strong JavaScript experience, ideally also some TypeScript or Flow (you can learn on the job)"
          "You have experience across the full software development lifecycle from requirements through to testing and deployment"
          "Ideally you will have an interest and desire to work with functional programming languages e.g. Elm (the backend team also use Rust and Elixir), you can gain exposure across the full stack"
          "You’re collaborative with great communication skills",
      country: "Saudi Native",
      city: "Riyadh",
      companyName: "Self Employed",
    ),
    JobModel(
      id: 1,
      title: "Frontend Developer",
      requirement:
          "You have strong React experience combined with an advanced knowledge of HTML, CSS and WC3 standards You have strong JavaScript experience, ideally also some TypeScript or Flow (you can learn on the job)"
          "You have experience across the full software development lifecycle from requirements through to testing and deployment"
          "Ideally you will have an interest and desire to work with functional programming languages e.g. Elm (the backend team also use Rust and Elixir), you can gain exposure across the full stack"
          "You’re collaborative with great communication skills",
      logo: "https://picsum.photos/128/128?random=2",
      imageUrl:
          'https://images.pexels.com/photos/247431/pexels-photo-247431.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      country: "Saudi Native",
      city: "Riyadh",
      companyName: "Self Employed",
    ),
    JobModel(
      id: 2,
      title: "Full stack developer",
      requirement:
          "You have strong React experience combined with an advanced knowledge of HTML, CSS and WC3 standards You have strong JavaScript experience, ideally also some TypeScript or Flow (you can learn on the job)"
          "You have experience across the full software development lifecycle from requirements through to testing and deployment"
          "Ideally you will have an interest and desire to work with functional programming languages e.g. Elm (the backend team also use Rust and Elixir), you can gain exposure across the full stack"
          "You’re collaborative with great communication skills",
      logo: "https://picsum.photos/128/128?random=3",
      imageUrl:
          'https://images.pexels.com/photos/3244513/pexels-photo-3244513.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      country: "Saudi Native",
      city: "Riyadh",
      companyName: "Self Employed",
    ),
    JobModel(
      id: 4,
      title: "Marketing Manager",
      requirement:
          "You have strong React experience combined with an advanced knowledge of HTML, CSS and WC3 standards You have strong JavaScript experience, ideally also some TypeScript or Flow (you can learn on the job)"
          "You have experience across the full software development lifecycle from requirements through to testing and deployment"
          "Ideally you will have an interest and desire to work with functional programming languages e.g. Elm (the backend team also use Rust and Elixir), you can gain exposure across the full stack"
          "You’re collaborative with great communication skills",
      logo: "https://picsum.photos/128/128?random=4",
      imageUrl:
          'https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      description:
          'Riviera Maya tiene más de 120 km de costa turquesa cristalina,'
          ' playas de arena blanca, sitios arqueológicos, parques '
          'naturales y actividades acuáticas únicas',
      country: "Saudi Native",
      city: "Riyadh",
      companyName: "Self Employed",
    ),
  ];
}
