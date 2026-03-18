import 'package:flutter/material.dart';
class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final double height;
  const GradientButton({super.key, required this.onPressed, required this.text, this.icon, this.height = 56});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF448AFF)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            if (icon != null) ...[const SizedBox(width: 8), Icon(icon, color: Colors.white, size: 20)],
          ],
        ),
      ),
    );
  }
}
```

اضغط **Commit changes**

---

## الخطوة 2 — أنشئ ملف security_service.dart

**Add file** ← **Create new file**

الاسم:
```
lib/services/security_service.dart
  import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SecurityService {
  static final SecurityService _i = SecurityService._();
  factory SecurityService() => _i;
  SecurityService._();
  static const _s = 'DualLock_Salt_2024';
  String hash(String p) => sha256.convert(utf8.encode('$_s:$p:$_s')).toString();
  Future<void> saveRealPattern(String p) async => (await SharedPreferences.getInstance()).setString('real', hash(p));
  Future<void> saveDecoyPattern(String p) async => (await SharedPreferences.getInstance()).setString('decoy', hash(p));
  Future<bool> verifyRealPattern(String p) async => (await SharedPreferences.getInstance()).getString('real') == hash(p);
  Future<bool> verifyDecoyPattern(String p) async => (await SharedPreferences.getInstance()).getString('decoy') == hash(p);
  Future<PatternType> checkPattern(String p) async {
    if (await verifyRealPattern(p)) return PatternType.real;
    if (await verifyDecoyPattern(p)) return PatternType.decoy;
    return PatternType.invalid;
  }
  Future<bool> hasRealPattern() async => (await SharedPreferences.getInstance()).getString('real') != null;
  Future<bool> hasDecoyPattern() async => (await SharedPreferences.getInstance()).getString('decoy') != null;
}
enum PatternType { real, decoy, invalid }
