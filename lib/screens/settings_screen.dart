import 'package:flutter/material.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final birthdate = appState.birthdate;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
        children: [
          Text('Profile', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          const Text(
            'Manage your sign, Premium state, and privacy settings.',
            style: TextStyle(color: Color(0xFFAFB8DC)),
          ),
          const SizedBox(height: 20),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your zodiac sign',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: appState.selectedZodiac,
                  dropdownColor: const Color(0xFF161C33),
                  decoration: _inputDecoration(),
                  items: ZodiacUtils.allSigns
                      .map(
                        (sign) => DropdownMenuItem(
                          value: sign,
                          child: Text(ZodiacUtils.displayName(sign)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      appState.setSelectedZodiac(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: birthdate ?? DateTime(2000, 1, 1),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      helpText: 'Birth date',
                    );
                    if (selected != null) {
                      await appState.setBirthdate(selected);
                    }
                  },
                  icon: const Icon(Icons.cake_outlined),
                  label: Text(
                    birthdate == null
                        ? 'Set birth date'
                        : 'Birth date: ${birthdate.year}.${birthdate.month.toString().padLeft(2, '0')}.${birthdate.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  appState.isPremium
                      ? 'Enabled: daily horoscope and detailed compatibility explanation'
                      : 'Disabled: premium content is locked',
                  style: const TextStyle(color: Color(0xFFD5DAF0)),
                ),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  title: const Text('Premium subscription status (MVP)'),
                  value: appState.isPremium,
                  onChanged: (value) => appState.setPremiumStatus(value),
                  contentPadding: EdgeInsets.zero,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () async {
                      await appState.setPremiumStatus(true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Purchase restored. Premium enabled.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.restore_rounded),
                    label: const Text('Restore purchase'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Your birth date and sign are stored locally on this device only. '
                  'In this MVP version, no personal data is sent to a server.',
                  style: TextStyle(color: Color(0xFFD5DAF0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF283257)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF283257)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6F7BFF)),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1020).withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A335A)),
      ),
      child: child,
    );
  }
}
