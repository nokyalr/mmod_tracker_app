import 'package:flutter/material.dart';
import '../../widgets/confirm_button.dart';

class AvatarSelectorScreen extends StatefulWidget {
  const AvatarSelectorScreen({super.key});

  @override
  AvatarSelectorScreenState createState() => AvatarSelectorScreenState();
}

class AvatarSelectorScreenState extends State<AvatarSelectorScreen> {
  String? _selectedAvatar;

  final List<String> _avatars = [
    'assets/images/people1.png',
    'assets/images/people2.png',
    'assets/images/people3.png',
    'assets/images/people4.png',
    'assets/images/people5.png',
    'assets/images/people6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Choose your avatar!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE68C52),
                ),
              ),
            ),
            // Grid avatar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _avatars.length,
                  itemBuilder: (context, index) {
                    final avatar = _avatars[index];
                    final isSelected = _selectedAvatar == avatar;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatar;
                        });
                      },
                      child: Opacity(
                        opacity: isSelected ? 1.0 : 0.4,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage(avatar),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConfirmButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    width: 135,
                  ),
                  const SizedBox(width: 20),
                  ConfirmButton(
                    text: 'Confirm',
                    onPressed: () {
                      if (_selectedAvatar != null) {
                        Navigator.pop(context, _selectedAvatar);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select an avatar!')),
                        );
                      }
                    },
                    width: 135,
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
