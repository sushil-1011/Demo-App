import 'package:flutter/material.dart';

void main() {
  runApp(const BvcApp());
}

class BvcApp extends StatelessWidget {
  const BvcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BVC Engineering Campus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// ================== HOME PAGE ==================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeContent(),
    const RegisteredPage(),
    const AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🌈 Light blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Logo + Title
            Row(
              children: [
                Image.asset("assets/images/logo.png", height: 40),
                const SizedBox(width: 10),
                const Text(
                  "BVC Engineering Campus",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            // Right Logo
            Image.asset("assets/images/logo1.png", height: 40),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts), label: "Registered"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ================== HOME CONTENT ==================
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text("CSE"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
    );
  }
}

// ================== LOGIN PAGE ==================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitData() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      RegisteredPage.savedUsers.add({
        "username": username,
        "password": password,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );

      Navigator.pop(context); // go back to Home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo2.png", height: 100),
            const SizedBox(height: 20),
            const Text(
              "Login to CSE",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: _submitData,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== REGISTERED PAGE ==================
class RegisteredPage extends StatefulWidget {
  const RegisteredPage({super.key});

  static List<Map<String, String>> savedUsers = [];

  @override
  State<RegisteredPage> createState() => _RegisteredPageState();
}

class _RegisteredPageState extends State<RegisteredPage> {
  final Map<int, bool> _passwordVisible = {};

  @override
  Widget build(BuildContext context) {
    if (RegisteredPage.savedUsers.isEmpty) {
      return const Center(
        child: Text(
          "Data not entered yet",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: RegisteredPage.savedUsers.length,
        itemBuilder: (context, index) {
          final user = RegisteredPage.savedUsers[index];
          final visible = _passwordVisible[index] ?? false;

          return ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: Text("User: ${user['username']}"),
            subtitle: Row(
              children: [
                Text(
                  visible
                      ? "Password: ${user['password']}"
                      : "Password: ${'*' * user['password']!.length}",
                ),
                IconButton(
                  icon: Icon(
                    visible ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible[index] = !visible;
                    });
                  },
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  RegisteredPage.savedUsers.removeAt(index);
                });
              },
            ),
          );
        },
      );
    }
  }
}

// ================== ABOUT PAGE ==================
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo at the top
          Image.asset(
            "assets/images/logo1.png", // 🖼️ same logo as login page
            height: 100,
          ),
          const SizedBox(height: 20),

          // College Info Text
          const Text(
            "BVC Engineering College (Autonomous)\n"
            "Odalarevu-533210, East Godavari Dist., A.P.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

