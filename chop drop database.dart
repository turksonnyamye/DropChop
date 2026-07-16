// pubspec.yaml dependencies:
// dependencies:
//   firebase_core: ^3.6.0
//   firebase_database: ^11.1.4
//   firebase_auth: ^5.3.1

// NOTE: The project should depend on `firebase_database` in pubspec.yaml.
// If the package is not available, a minimal local stub is provided here
// to avoid analyzer errors. Replace/remove these stubs when the real
// package is added.

// Minimal stubs (only to satisfy analyzer when firebase_database is missing)
class DataSnapshot {
  final dynamic value;
  final bool exists;
  DataSnapshot([this.value, this.exists = false]);
}

class DatabaseEvent {
  final DataSnapshot snapshot;
  DatabaseEvent(this.snapshot);
}

class DatabaseReference {
  final String? key;
  DatabaseReference([this.key]);

  DatabaseReference child(String path) => DatabaseReference(path);
  Future<void> set(dynamic value) async => throw UnimplementedError('Firebase not configured');
  Future<DataSnapshot> get() async => DataSnapshot(null, false);
  Stream<DatabaseEvent> get onValue async* {}
  DatabaseReference push() => DatabaseReference('generated');
  DatabaseReference orderByChild(String child) => this;
  DatabaseReference equalTo(dynamic value) => this;
}

class FirebaseDatabase {
  FirebaseDatabase._();
  static final instance = FirebaseDatabase._();
  DatabaseReference ref() => DatabaseReference();
}



class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // customer, vendor, rider
  final String? vendorId;
  final String? riderId;
  final int createdAt;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.vendorId,
    this.riderId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        if (vendorId != null) 'vendorId': vendorId,
        if (riderId != null) 'riderId': riderId,
        'createdAt': createdAt,
      };

  factory AppUser.fromJson(String uid, Map<dynamic, dynamic> json) => AppUser(
        uid: uid,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        role: json['role'] ?? 'customer',
        vendorId: json['vendorId'],
        riderId: json['riderId'],
        createdAt: json['createdAt'] ?? 0,
      );
}

class Vendor {
  final String vendorId;
  final String name;
  final String ownerUid;
  final String category;
  final String location;
  final String phone;
  final bool isOpen;
  final double rating;
  final String imageUrl;

  Vendor({
    required this.vendorId,
    required this.name,
    required this.ownerUid,
    required this.category,
    required this.location,
    required this.phone,
    required this.isOpen,
    required this.rating,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'ownerUid': ownerUid,
        'category': category,
        'location': location,
        'phone': phone,
        'isOpen': isOpen,
        'rating': rating,
        'imageUrl': imageUrl,
      };

  factory Vendor.fromJson(String vendorId, Map<dynamic, dynamic> json) => Vendor(
        vendorId: vendorId,
        name: json['name'] ?? '',
        ownerUid: json['ownerUid'] ?? '',
        category: json['category'] ?? '',
        location: json['location'] ?? '',
        phone: json['phone'] ?? '',
        isOpen: json['isOpen'] ?? false,
        rating: (json['rating'] ?? 0).toDouble(),
        imageUrl: json['imageUrl'] ?? '',
      );
}

class MenuItem {
  final String itemId;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool available;
  final String imageUrl;

  MenuItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.available,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'available': available,
        'imageUrl': imageUrl,
      };

  factory MenuItem.fromJson(String itemId, Map<dynamic, dynamic> json) => MenuItem(
        itemId: itemId,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        category: json['category'] ?? '',
        available: json['available'] ?? true,
        imageUrl: json['imageUrl'] ?? '',
      );
}

class Rider {
  final String riderId;
  final String uid;
  final String name;
  final String phone;
  final String vehicleType;
  final bool isAvailable;
  final double lat;
  final double lng;
  final double rating;

  Rider({
    required this.riderId,
    required this.uid,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.isAvailable,
    required this.lat,
    required this.lng,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'phone': phone,
        'vehicleType': vehicleType,
        'isAvailable': isAvailable,
        'currentLocation': {'lat': lat, 'lng': lng},
        'rating': rating,
      };

  factory Rider.fromJson(String riderId, Map<dynamic, dynamic> json) {
    final loc = json['currentLocation'] as Map<dynamic, dynamic>? ?? {};
    return Rider(
      riderId: riderId,
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      lat: (loc['lat'] ?? 0).toDouble(),
      lng: (loc['lng'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({required this.name, required this.price, required this.quantity});

  Map<String, dynamic> toJson() => {'name': name, 'price': price, 'quantity': quantity};

  factory OrderItem.fromJson(Map<dynamic, dynamic> json) => OrderItem(
        name: json['name'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'] ?? 1,
      );
}

class ChopOrder {
  final String orderId;
  final String customerId;
  final String vendorId;
  final String? riderId;
  final Map<String, OrderItem> items;
  final double totalPrice;
  final double deliveryFee;
  final String paymentMethod; // momo, cash
  final String paymentStatus; // pending, paid
  final String status; // placed, accepted, preparing, on_the_way, delivered, cancelled
  final String deliveryAddress;
  final int createdAt;
  final int updatedAt;

  ChopOrder({
    required this.orderId,
    required this.customerId,
    required this.vendorId,
    this.riderId,
    required this.items,
    required this.totalPrice,
    required this.deliveryFee,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.deliveryAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'vendorId': vendorId,
        if (riderId != null) 'riderId': riderId,
        'items': items.map((key, value) => MapEntry(key, value.toJson())),
        'totalPrice': totalPrice,
        'deliveryFee': deliveryFee,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'status': status,
        'deliveryAddress': deliveryAddress,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory ChopOrder.fromJson(String orderId, Map<dynamic, dynamic> json) {
    final itemsJson = json['items'] as Map<dynamic, dynamic>? ?? {};
    return ChopOrder(
      orderId: orderId,
      customerId: json['customerId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      riderId: json['riderId'],
      items: itemsJson.map(
        (key, value) => MapEntry(key.toString(), OrderItem.fromJson(value)),
      ),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'momo',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      status: json['status'] ?? 'placed',
      deliveryAddress: json['deliveryAddress'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
    );
  }
}

class ChopDropDatabase {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // ---------- Users ----------
  Future<void> createUser(AppUser user) =>
      _db.child('users/${user.uid}').set(user.toJson());

  Future<AppUser?> getUser(String uid) async {
    final snap = await _db.child('users/$uid').get();
    if (!snap.exists) return null;
    return AppUser.fromJson(uid, snap.value as Map<dynamic, dynamic>);
  }

  // ---------- Vendors ----------
  Future<void> createVendor(Vendor vendor) =>
      _db.child('vendors/${vendor.vendorId}').set(vendor.toJson());

  Stream<List<Vendor>> streamVendors() {
    return _db.child('vendors').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => Vendor.fromJson(e.key.toString(), e.value))
          .toList();
    });
  }

  Future<void> setVendorOpenStatus(String vendorId, bool isOpen) =>
      _db.child('vendors/$vendorId/isOpen').set(isOpen);

  // ---------- Menu Items ----------
  Future<void> addMenuItem(String vendorId, MenuItem item) =>
      _db.child('menuItems/$vendorId/${item.itemId}').set(item.toJson());

  Stream<List<MenuItem>> streamMenu(String vendorId) {
    return _db.child('menuItems/$vendorId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => MenuItem.fromJson(e.key.toString(), e.value))
          .toList();
    });
  }

  // ---------- Riders ----------
  Future<void> createRider(Rider rider) =>
      _db.child('riders/${rider.riderId}').set(rider.toJson());

  Future<void> updateRiderLocation(String riderId, double lat, double lng) =>
      _db.child('riders/$riderId/currentLocation').set({'lat': lat, 'lng': lng});

  Future<void> setRiderAvailability(String riderId, bool isAvailable) =>
      _db.child('riders/$riderId/isAvailable').set(isAvailable);

  Stream<List<Rider>> streamAvailableRiders() {
    return _db.child('riders').orderByChild('isAvailable').equalTo(true).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => Rider.fromJson(e.key.toString(), e.value))
          .toList();
    });
  }

  // ---------- Orders ----------
  Future<String> createOrder(ChopOrder order) async {
    final ref = _db.child('orders').push();
    await ref.set(order.toJson());
    await _db.child('orderStatusHistory/${ref.key}/entry_001').set({
      'status': order.status,
      'timestamp': order.createdAt,
    });
    return ref.key!;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.child('orders/$orderId/status').set(status);
    await _db.child('orders/$orderId/updatedAt').set(now);
    final historyRef = _db.child('orderStatusHistory/$orderId').push();
    await historyRef.set({'status': status, 'timestamp': now});
  }

  Future<void> assignRiderToOrder(String orderId, String riderId) =>
      _db.child('orders/$orderId/riderId').set(riderId);

  Stream<List<ChopOrder>> streamCustomerOrders(String customerId) {
    return _db
        .child('orders')
        .orderByChild('customerId')
        .equalTo(customerId)
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => ChopOrder.fromJson(e.key.toString(), e.value))
          .toList();
    });
  }

  Stream<List<ChopOrder>> streamVendorOrders(String vendorId) {
    return _db
        .child('orders')
        .orderByChild('vendorId')
        .equalTo(vendorId)
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => ChopOrder.fromJson(e.key.toString(), e.value))
          .toList();
    });
  }

  Stream<ChopOrder?> streamOrder(String orderId) {
    return _db.child('orders/$orderId').onValue.map((event) {
      if (!event.snapshot.exists) return null;
      return ChopOrder.fromJson(orderId, event.snapshot.value as Map<dynamic, dynamic>);
    });
  }

  // ---------- Reviews ----------
  Future<void> addReview(String vendorId, String customerId, String orderId,
      int rating, String comment) async {
    final ref = _db.child('reviews/$vendorId').push();
    await ref.set({
      'customerId': customerId,
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
