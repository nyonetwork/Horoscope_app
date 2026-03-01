import 'package:flutter/material.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';
import 'package:horoscope_app/widgets/birth_date_picker_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final birthdate = appState.birthdate;
    final birthdateLabel = birthdate == null
        ? 'Not set'
        : '${birthdate.year}.${birthdate.month.toString().padLeft(2, '0')}.${birthdate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _menuGroup(
            children: [
              _menuTile(
                icon: Icons.person_outline_rounded,
                title: 'Profile',
                subtitle:
                    '${ZodiacUtils.displayName(appState.selectedZodiac)} • $birthdateLabel',
                onTap: () => _openProfileSheet(context, appState),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _menuGroup(
            children: [
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.workspace_premium_rounded),
                title: const Text('Premium'),
                subtitle: Text(appState.isPremium ? 'Enabled' : 'Disabled'),
                value: appState.isPremium,
                onChanged: (value) => appState.setPremiumStatus(value),
              ),
              const Divider(height: 1),
              _menuTile(
                icon: Icons.restore_rounded,
                title: 'Restore purchase',
                subtitle: 'Enable premium if already purchased',
                onTap: () async {
                  await appState.setPremiumStatus(true);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Purchase restored.')),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _menuGroup(
            children: [
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.motion_photos_off_rounded),
                title: const Text('Reduce motion'),
                subtitle: const Text('Calmer background and lighter effects'),
                value: appState.reduceMotion,
                onChanged: (value) => appState.setReduceMotion(value),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _menuGroup(
            children: [
              _menuTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
                subtitle: 'Stored locally on this device',
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Privacy'),
                      content: const Text(
                        'Your birth date and sign are stored locally on this device only. '
                        'In this MVP version, no personal data is sent to a server.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuGroup({required List<Widget> children}) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }

  Future<void> _openProfileSheet(
    BuildContext context,
    AppState appState,
  ) async {
    String selectedSign = appState.selectedZodiac;
    DateTime? selectedBirthdate = appState.birthdate;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final birthdateText = selectedBirthdate == null
                ? 'Set birth date'
                : 'Birth date: ${selectedBirthdate!.year}.${selectedBirthdate!.month.toString().padLeft(2, '0')}.${selectedBirthdate!.day.toString().padLeft(2, '0')}';
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedSign,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Zodiac sign',
                      ),
                      items: ZodiacUtils.allSigns
                          .map(
                            (sign) => DropdownMenuItem(
                              value: sign,
                              child: Text(ZodiacUtils.displayName(sign)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => selectedSign = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final selected = await showBirthDatePickerSheet(
                          context,
                          initialDate:
                              selectedBirthdate ?? DateTime(2000, 1, 1),
                          minimumDate: DateTime(1950),
                          maximumDate: DateTime.now(),
                        );
                        if (selected == null) return;
                        setState(() => selectedBirthdate = selected);
                      },
                      icon: const Icon(Icons.cake_outlined),
                      label: Text(birthdateText),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await appState.setSelectedZodiac(selectedSign);
                          if (selectedBirthdate != null) {
                            await appState.setBirthdate(selectedBirthdate!);
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
