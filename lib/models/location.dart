class Location {
  String location;
  String longitude;
  String lattitude;
  String capacity;
  String occupied;

  Location(this.location, this.longitude, this.lattitude, this.capacity,
      this.occupied);
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      json["location"] as String,
      json["longitude"] as String,
      json["lattitude"] as String,
      json["capacity"] as String,
      json["occupied"] as String,
    );
  }
  // Items items;
  // bool hasMore;
  // int limit;
  // int offset;
  // int count;
  // Links links;

  // Location(this.items);
  // factory Location.fromJson(Map<String, dynamic> json) {
  //   return Location(Items.fromJson(json["items"]));
  // json["hasMore"],
  // json["limit"],
  // json["offset"],
  // json["count"],
  // Links.fromJson(json["links"]));
}

// class Links {
//   String rel;
//   String href;

//   Links(this.rel, this.href);
//   factory Links.fromJson(Map<String, dynamic> json) {
//     return Links(json["rel"] as String, json["href"] as String);
//   }
// }

class Items {}
