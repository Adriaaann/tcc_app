import 'package:flutter/material.dart';
import 'package:tcc_app/localization/welcome.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double logoSize = 200.0;
    const double buttonSize = 240.0;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 64,
            children: [
              Image.asset('assets/images/logo.png', width: logoSize),
              SizedBox(
                width: buttonSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    _OutlinedButton(
                      text: WelcomeLocale.login,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                    ),
                    _FilledButton(
                      text: WelcomeLocale.createAccount,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                    ),
                    _TextButton(
                      text: WelcomeLocale.guest,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const _OutlinedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: BorderSide(width: 2, color: context.colorScheme.primary),
    ),
    child: Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _FilledButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const _FilledButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(backgroundColor: context.colorScheme.primary),
    child: Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _TextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const _TextButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
