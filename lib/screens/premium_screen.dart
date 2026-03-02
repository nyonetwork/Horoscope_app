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

    await Future<void>.delayed(const Duration(milliseconds: 900));
    await appState.setPremiumStatus(true);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Премиум идэвхжлээ.')),
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
      const SnackBar(content: Text('Худалдан авалт сэргээлээ.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Премиум')),
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
                      appState.isPremium ? 'Премиум идэвхтэй' : 'Премиум нээх',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Маргаашийн уншлага, зохицлын дэлгэрэнгүй тайлбар болон цаашдын нэмэлт боломжуудыг нээнэ.',
                  style: TextStyle(color: Color(0xFFE2E8FF), height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _featureTile(
            icon: Icons.auto_awesome_rounded,
            title: 'Маргаашийн зурлага',
            subtitle: 'Нүүр хуудсан дээрх маргаашийн хэсгийг нээнэ.',
          ),
          _featureTile(
            icon: Icons.favorite_rounded,
            title: 'Зохицлын дэлгэрэнгүй',
            subtitle: 'Тооцоо хийсний дараа дэлгэрэнгүй тайлбар уншина.',
          ),
          _featureTile(
            icon: Icons.rocket_launch_rounded,
            title: 'Шинэ боломжид түрүүлж нэвтрэх',
            subtitle: 'Шинэ боломжуудыг хамгийн түрүүнд ашиглана.',
          ),
          const SizedBox(height: 14),
          _planCard(
            id: 'monthly',
            title: 'Сар бүр',
            price: r'$2.99 / сар',
            description: 'Уян хатан төлөвлөгөө, хүссэн үедээ цуцална.',
          ),
          const SizedBox(height: 10),
          _planCard(
            id: 'yearly',
            title: 'Жил бүр',
            price: r'$19.99 / жил',
            description: 'Урт хугацаанд хамгийн ашигтай.',
            badge: '44% хэмнэлт',
          ),
          const SizedBox(height: 10),
          _planCard(
            id: 'lifetime',
            title: 'Насан турш',
            price: r'$39.99 нэг удаа',
            description: 'Нэг удаа төлөөд бүрэн нээлттэй.',
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
                      appState.isPremium ? 'Премиум аль хэдийн идэвхтэй' : 'Үргэлжлүүлэх',
                    ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _isProcessing ? null : () => _restorePurchase(appState),
            child: const Text('Худалдан авалт сэргээх'),
          ),
          const SizedBox(height: 8),
          Text(
            'Сонгосон төлөвлөгөө: ${_selectedPlan == 'monthly' ? 'Сар бүр' : _selectedPlan == 'yearly' ? 'Жил бүр' : 'Насан турш'}',
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
