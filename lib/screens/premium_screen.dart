import 'package:flutter/material.dart';
import 'package:horoscope_app/utils/app_state.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  String _selectedPlan = 'yearly';
  bool _isProcessing = false;

  Future<void> _activatePremium(AppState appState) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    // Placeholder flow until real billing SDK is integrated.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    await appState.setPremiumStatus(true);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Premium activated.')),
    );
    Navigator.of(context).pop();
  }

  Future<void> _restorePurchase(AppState appState) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    await appState.setPremiumStatus(true);
    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Purchase restored.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A356E), Color(0xFF1D244E), Color(0xFF12193A)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF5267C4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFFFD486),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appState.isPremium ? 'Premium Active' : 'Unlock Premium',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Get tomorrow readings, detailed compatibility explanations, and future premium features.',
                  style: TextStyle(color: Color(0xFFE2E8FF), height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _featureTile(
            icon: Icons.auto_awesome_rounded,
            title: 'Tomorrow Horoscope',
            subtitle: 'Unlock tomorrow section on Home with full details.',
          ),
          _featureTile(
            icon: Icons.favorite_rounded,
            title: 'Detailed Match Insights',
            subtitle: 'Read premium compatibility narrative after calculation.',
          ),
          _featureTile(
            icon: Icons.rocket_launch_rounded,
            title: 'Priority Features',
            subtitle: 'You get first access as premium grows.',
          ),
          const SizedBox(height: 14),
          _planCard(
            id: 'monthly',
            title: 'Monthly',
            price: r'$2.99 / month',
            description: 'Flexible option, cancel anytime.',
          ),
          const SizedBox(height: 10),
          _planCard(
            id: 'yearly',
            title: 'Yearly',
            price: r'$19.99 / year',
            description: 'Best value for long-term daily use.',
            badge: 'Save 44%',
          ),
          const SizedBox(height: 10),
          _planCard(
            id: 'lifetime',
            title: 'Lifetime',
            price: r'$39.99 one-time',
            description: 'Single payment, permanent unlock.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : () => _activatePremium(appState),
              child: _isProcessing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      appState.isPremium ? 'Premium Already Active' : 'Continue',
                    ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _isProcessing ? null : () => _restorePurchase(appState),
            child: const Text('Restore Purchase'),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected plan: ${_selectedPlan[0].toUpperCase()}${_selectedPlan.substring(1)}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFB8C4EA), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _featureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF1A254E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFD6E0FF), size: 18),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _planCard({
    required String id,
    required String title,
    required String price,
    required String description,
    String? badge,
  }) {
    final isSelected = _selectedPlan == id;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedPlan = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF152352) : const Color(0xFF0F162F),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF7F9DFF) : const Color(0xFF304172),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF9CB6FF) : const Color(0xFF7F8CB8),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E4AA2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFE2E9FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(color: Color(0xFFB9C6EE), height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
