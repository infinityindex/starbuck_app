import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_stores.dart';

class StoreLocatorScreen extends StatefulWidget {
  const StoreLocatorScreen({super.key});

  @override
  State<StoreLocatorScreen> createState() => _StoreLocatorScreenState();
}

class _StoreLocatorScreenState extends State<StoreLocatorScreen> {
  final MapController _mapController = MapController();
  int _selectedStoreIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Find a Store', style: AppTypography.headingMedium(context)),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(47.6205, -122.3493), // Seattle
              initialZoom: 13.0,
              minZoom: 11.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.starbucks.app',
              ),
              MarkerLayer(
                markers: mockStores.asMap().entries.map((entry) {
                  final index = entry.key;
                  final store = entry.value;
                  return Marker(
                    point: LatLng(store.latitude, store.longitude),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedStoreIndex = index);
                        _mapController.move(LatLng(store.latitude, store.longitude), 15.0);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _selectedStoreIndex == index ? 44 : 36,
                        height: _selectedStoreIndex == index ? 44 : 36,
                        decoration: BoxDecoration(
                          color: _selectedStoreIndex == index ? AppColors.primaryGreen : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryGreen,
                            width: _selectedStoreIndex == index ? 4 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_cafe_rounded,
                          color: _selectedStoreIndex == index ? Colors.white : AppColors.primaryGreen,
                          size: _selectedStoreIndex == index ? 22 : 18,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Store cards sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Store list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: mockStores.length,
                      itemBuilder: (context, index) {
                        final store = mockStores[index];
                        final isSelected = _selectedStoreIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedStoreIndex = index);
                            _mapController.move(LatLng(store.latitude, store.longitude), 15.0);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 260,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryGreen : AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryGreen : AppColors.divider,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (isSelected ? Colors.white : AppColors.success).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        store.isOpen ? 'Open' : 'Closed',
                                        style: AppTypography.caption(context).copyWith(
                                          color: isSelected ? Colors.white : AppColors.success,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${store.distanceMiles} mi',
                                      style: AppTypography.caption(context).copyWith(
                                        color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  store.name,
                                  style: AppTypography.labelMedium(context).copyWith(
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  store.address,
                                  style: AppTypography.bodySmall(context).copyWith(
                                    color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (store.hasDriveThrough)
                                      _StoreFeatureIcon(
                                        icon: Icons.directions_car_rounded,
                                        isSelected: isSelected,
                                      ),
                                    if (store.hasMobileOrder) ...[
                                      if (store.hasDriveThrough) const SizedBox(width: 6),
                                      _StoreFeatureIcon(
                                        icon: Icons.smartphone_rounded,
                                        isSelected: isSelected,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreFeatureIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _StoreFeatureIcon({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.primaryGreenLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 14,
        color: isSelected ? Colors.white : AppColors.primaryGreen,
      ),
    );
  }
}
