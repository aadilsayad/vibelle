import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/common/widgets.dart';
import 'package:client/common/utils/utils.dart';
import 'package:client/common/theme/palette.dart';
import 'package:client/features/auth/view/screens/login_screen.dart';
import 'package:client/features/auth/view/widgets/auth_text_field.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            showSnackBar(
              context,
              'Account created successfully. Please log in now.',
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const LoginScreen(),
              ),
            );
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthTextField(
                          hintText: 'Name', controller: nameController),
                      const SizedBox(height: 15),
                      AuthTextField(
                          hintText: 'Email', controller: emailController),
                      const SizedBox(height: 15),
                      AuthTextField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(height: 20),
                      AuthGradientButton(
                        buttonText: 'Sign Up',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .signupUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const LoginScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                text: 'Log in',
                                style: TextStyle(
                                  color: Palette.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
