// import 'package:flutter/material.dart';
// import 'package:flutter_doan/screens/action_page.dart';
// import 'package:flutter_doan/screens/userHome_screen.dart';
// import 'package:flutter_doan/screens/userPoin_page.dart';
// import 'package:flutter_doan/screens/user_page.dart';
// import 'package:flutter_doan/utils/services.dart';
// import 'package:flutter_doan/utils/tokenService.dart';

// class UserHomePage extends StatefulWidget {
//   const UserHomePage({Key? key}) : super(key: key);

//   @override
//   _UserHomePageState createState() => _UserHomePageState();
// }

// class _UserHomePageState extends State<UserHomePage> {
//   String? _role; // Sử dụng role như là userId
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   List<Widget>? _widgetOptions;

//   @override
//   void initState() {
//     super.initState();
//     _getRole(); // Thay vì _getRoleAndUserId, chỉ cần lấy role
//   }

//   Future<void> _getRole() async {
//     final tokenAndRole = await TokenService.getTokenAndRole();
//     setState(() {
//       _role = tokenAndRole['role'] ?? '';
//       _widgetOptions = <Widget>[
//         const UserHomeScreen(),
//         const UserPage(),
//         UserPointPage(userId: _role!),
//         const Text(
//           'Đăng xuất',
//           style: optionStyle,
//         ),
//       ];
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void handleLogout() {
//     try {
//       final response = AppUtils.handleLogout();
//       if (response.toString().isNotEmpty) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const ActionPage()),
//         );
//         TokenService.deleteToken();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Trang chủ")),
//       body: Center(
//         child: _widgetOptions?[_selectedIndex],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const SizedBox(height: 50),
//             ListTile(
//               title: const Text("Trang chủ"),
//               selected: _selectedIndex == 0,
//               onTap: () {
//                 _onItemTapped(0);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text("Xem thông tin sinh viên"),
//               selected: _selectedIndex == 1,
//               onTap: () {
//                 _onItemTapped(1);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text("Xem điểm sinh viên"),
//               selected: _selectedIndex == 2,
//               onTap: () {
//                 _onItemTapped(2);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text("Đăng xuất"),
//               selected: _selectedIndex == 3,
//               onTap: () {
//                 _onItemTapped(3);
//                 handleLogout();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
