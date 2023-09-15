import 'package:ecampus_flutter/screens/landing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecampus_flutter/functions/marks_calc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecampus App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.cyan,
        cardColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.cyan,
        primaryColorDark: Colors.cyan[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? username = dotenv.env['defaultRoll'];
  String? password = dotenv.env['defaultPass'];
  bool passwordVisible = false;
  String? studentName;
  List<dynamic>? attendance;
  List<dynamic>? courses;
  List<dynamic>? semResults;
  List<dynamic>? coreTitles;
  List<dynamic>? coreMarks;
  List<dynamic>? additionalTitles;
  List<dynamic>? additionalMarks;
  List<dynamic>? projectTitles;
  List<dynamic>? projectMarks;
  String? prevSem;
  Map<String, dynamic>? lastUpdated;
  bool loading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data from cache when the app starts
    loadDataFromCache();
    setState(() {
      _usernameController.text = dotenv.env['defaultRoll'] ?? '';
      _passwordController.text = dotenv.env['defaultPass'] ?? '';
    });
  }

  Future<void> loadDataFromCache() async {
    // Fetch and set data from local cache (e.g., SharedPreferences)
    // Example code:
    // SharedPreferences.setMockInitialValues({});

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? cachedData = prefs.getString('retrievedData');
    // if (cachedData != null) {
    //   final Map<String, dynamic> parsedData = jsonDecode(cachedData);
    //   const months = [
    //     'Jan',
    //     'Feb',
    //     'Mar',
    //     'Apr',
    //     'May',
    //     'Jun',
    //     'Jul',
    //     'Aug',
    //     'Sep',
    //     'Nov',
    //     'Dec'
    //   ];
    //   // Update the UI with the fetched data
    //   var lastDate = parsedData['body']['attendance'][0].last;
    //   setState(() {
    //     studentName = parsedData['body']['studentName'];
    //     attendance = parsedData['body']['attendance'];
    //     attendance?.sort((a, b) {
    //       int valueA = int.tryParse(a[5]) ?? 0;
    //       int valueB = int.tryParse(b[5]) ?? 0;
    //       return valueA.compareTo(valueB);
    //     });
    //     courses = parsedData['body']['courses'];
    //     semResults = parsedData['body']['results'];
    //     semResults?.sort(((a, b) {
    //       int valueA = int.tryParse(a[4]?.split(' ')[0]) ?? 100;
    //       int valueB = int.tryParse(b[4]?.split(' ')[0]) ?? 100;
    //       return valueA.compareTo(valueB);
    //     }));
    //     lastUpdated = {
    //       'date': lastDate.split('-')[0],
    //       'month': months[int.parse(lastDate.split('-')[1]) - 1],
    //       'year': lastDate.split('-')[2],
    //     };
    //     loading = false;
    //   });
    // }
  }

  void navigateToLanding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LandingScreen(
          studentName: studentName!,
          coreTitles: coreTitles!,
          coreMarks: coreMarks!,
          additionalTitles: additionalTitles!,
          additionalMarks: additionalMarks!,
          projectTitles: projectTitles!,
          projectMarks: projectMarks!,
          attendance: attendance!,
          courses: courses!,
          lastUpdated: lastUpdated!,
          prevSem: prevSem!,
          semResults: semResults!,
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    if (username == '' || password == '') {
      // Alert user to enter username and password
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: const Text('Please enter username and password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final res = await http.post(
        Uri.parse(dotenv.env['API_Key'] ?? ''),
        body: jsonEncode({
          "body": {
            "username": username ?? "", // Use an empty string if username is null
            "password": password ?? "", // Use an empty string if password is null
          },
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> responseBody = jsonDecode(res.body);
      final int status = responseBody['statusCode'];

      if (status == 200) {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Nov', 'Dec'];

        // Update the UI with the fetched data
        var lastDate = responseBody['body']['attendance'][0].last;
        setState(() {
          studentName = responseBody['body']['studentName'];
          attendance = responseBody['body']['attendance'];
          attendance?.sort((a, b) {
            int valueA = int.tryParse(a[5]) ?? 0;
            int valueB = int.tryParse(b[5]) ?? 0;
            return valueA.compareTo(valueB);
          });
          courses = responseBody['body']['courses'];
          semResults = responseBody['body']['results'];
          prevSem = responseBody['body']['results'][0][0];
          semResults?.sort((a, b) {
            int valueA = int.tryParse(a[4]?.split(' ')[0]) ?? 100;
            int valueB = int.tryParse(b[4]?.split(' ')[0]) ?? 100;
            return valueA.compareTo(valueB);
          });
          lastUpdated = {
            'date': lastDate.split('-')[0],
            'month': months[int.parse(lastDate.split('-')[1]) - 1],
            'year': lastDate.split('-')[2],
          };
          coreTitles = responseBody['body']['ca']['core'][0];
          coreMarks = responseBody['body']['ca']['core'].sublist(1);
          coreMarks?.sort((a, b) {
            double valueA = totalCaMarks(a);
            double valueB = totalCaMarks(b);
            return valueA.compareTo(valueB);
          });
          additionalTitles = responseBody['body']['ca']['additional'][0];
          additionalMarks = responseBody['body']['ca']['additional'].sublist(1);
          additionalMarks?.sort((a, b) {
            double valueA = totalCaMarks(a);
            double valueB = totalCaMarks(b);
            return valueA.compareTo(valueB);
          });
          projectTitles = responseBody['body']['ca']['project'][0];
          projectMarks = responseBody['body']['ca']['project'].sublist(1);
          loading = false;
        });

        navigateToLanding();

        // Cache the fetched data (e.g., using SharedPreferences)
        // Example code:
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('retrievedData', jsonEncode(responseBody));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Invalid username or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred while fetching data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecampus App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Image.asset('assets/LoginImage.png'),
            const SizedBox(height: 48),
            const Text(
              'Credentials',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.all(16.0),
              ),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    obscureText: !passwordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    icon: passwordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 50,
                  width: 110,
                  child: ElevatedButton(
                    onPressed: loading ? null : fetchData,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    ),
                    child: Text(loading ? "Loading..." : "Login", style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
