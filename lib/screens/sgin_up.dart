import 'package:chatapp_task/Services/auth_services.dart';
import 'package:chatapp_task/screens/users_screen.dart';
import 'package:chatapp_task/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SginUp extends StatefulWidget {
  const SginUp({super.key});

  @override
  State<SginUp> createState() => _SginUpState();
}

class _SginUpState extends State<SginUp> {
  bool isHidden = true;
  final authService = AuthServices();
  final name = TextEditingController();
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
              "حساب جديد",
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
                controller: name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "الاسم بالكامل",
                  filled: true,
                  fillColor: const Color.fromARGB(45, 158, 158, 158),
                ),
              ),
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
              SizedBox(height: 30),
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
                            await authService.signUp(
                              name: name.text.trim(),
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                            setState(() => _loading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم انشاء الحساب يا ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}' )
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
                  child: _loading ? SizedBox(height: 14,child: CircularProgressIndicator(strokeWidth: 2,),) : Text(
                    "انشاء حساب جديد",
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SginIn()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "تسجيل دخول",
                      style: TextStyle(
                        color: Color(0xffD84D4D),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    "تمتلك حساب بالفعل؟",
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
