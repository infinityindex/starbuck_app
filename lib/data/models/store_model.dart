class StoreModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String hours;
  final bool isOpen;
  final bool hasDriveThrough;
  final bool hasMobileOrder;
  final double distanceMiles;

  const StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hours,
    this.isOpen = true,
    this.hasDriveThrough = false,
    this.hasMobileOrder = true,
    this.distanceMiles = 0.5,
  });
}
