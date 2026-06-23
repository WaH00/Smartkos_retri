import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({this.showScaffold = true, super.key});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Obx(
            () => Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName.value,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preferensi area: ${controller.preferredCity.value}',
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _ProfileTile(
          icon: Icons.tune_rounded,
          title: 'Preferensi Kos',
          subtitle: 'Budget, fasilitas, dan radius favorit',
          onTap: () => _showComingSoon(),
        ),
        _ProfileTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifikasi',
          subtitle: 'Info kos baru dan Super Deal',
          onTap: () => _showComingSoon(),
        ),
        _ProfileTile(
          icon: Icons.help_outline_rounded,
          title: 'Bantuan',
          subtitle: 'Pusat bantuan SmartKos',
          onTap: () => _showComingSoon(),
        ),
      ],
    );

    if (!showScaffold) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: content,
    );
  }

  void _showComingSoon() {
    Get.snackbar(
      'Segera hadir',
      'Fitur ini akan dihubungkan saat backend dan akun pengguna siap.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
