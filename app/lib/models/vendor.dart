import '../utils/constants.dart';
import 'package:requests/requests.dart';
import 'dart:convert';

class Vendor {
  int vid;
  String name;
  bool open;
  String contactNo;
  String photoURL;

  Vendor({
    this.vid,
    this.name,
    this.open,
    this.contactNo,
    this.photoURL,
  });

  factory Vendor.fromJson(Map<String, dynamic> parsedJson) {
    // Map<String, dynamic> parsedJson = jsonDecode(json);
    return Vendor(
      vid: parsedJson['vid'],
      name: parsedJson['name'],
      open: (parsedJson['open'] == 1),
      contactNo: parsedJson['contact_no'],
      photoURL: parsedJson['photoURL'],
    );
  }
}

class Vendors {
  final Map<int, Vendor> mp = {};
  bool loaded = false;

  Vendors();

  Future<void> loadVendors() {
    return Requests.get(BACKEND + "/vendors/").then((resp) {
      Map<String, dynamic> data = jsonDecode(resp);
      for (var vid in data.keys) {
        mp[int.parse(vid)] = Vendor.fromJson(data[vid]);
      }
      loaded = true;
    });
  }
}
