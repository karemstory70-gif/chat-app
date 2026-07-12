import 'package:chatapp_task/Services/auth_services.dart';
import 'package:chatapp_task/screens/users_screen.dart';
import 'package:chatapp_task/screens/sgin_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SginIn extends StatefulWidget {
  const SginIn({super.key});

  @override
  State<SginIn> createState() => _SginInState();
}

class _SginInState extends State<SginIn> {
  
  bool isHidden = true;
  final authService = AuthServices();
  final email = TextEditingController();
  final password = TextEditingController();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Title(
            color: Colors.black,
            child: Text(
              "تسجيل دخول",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "البريد الالكترونى ",
                  filled: true,
                  fillColor: const Color.fromARGB(45, 158, 158, 158),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: password,
                obscureText: isHidden,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "كلمة المرور",
                  filled: true,
                  fillColor: const Color.fromARGB(45, 158, 158, 158),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    onPressed: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    icon: Icon(
                      isHidden ? Icons.visibility_off : Icons.visibility,
                      color: const Color.fromARGB(71, 0, 0, 0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: AlignmentGeometry.bottomLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(
                      color: Color(0xffD84D4D),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffD84D4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          try {
                            await authService.signIn(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                            setState(() => _loading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تم تسجيل الدخول يا ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}',
                                ),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => UsersScreen()),
                            );
                          } catch (e) {
                            setState(() => _loading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                  child: _loading
                      ? SizedBox(
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          "تسجيل دخول",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SginUp()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "قم بانشاء حساب",
                      style: TextStyle(
                        color: Color(0xffD84D4D),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    "لا تمتلك حساب",
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
