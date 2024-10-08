import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/ThemeCubit/theme_cubit.dart';

class ThemeToggleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with the actual value from your app's theme state.
    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
 var theme = Theme.of(context);
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Toggle Theme'),
          ),
          body: Center(
            child: GestureDetector(
              onTap: () {
                // Call your toggle theme function here.
                context.read<ThemeCubit>().updateTheme(!state.isDarkThemeOn);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: state.isDarkThemeOn ? Colors.grey[850] : Colors.blue,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: state.isDarkThemeOn
                          ? Colors.black45
                          : Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.isDarkThemeOn ? Icons.nights_stay : Icons.wb_sunny,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      state.isDarkThemeOn
                          ? 'Switch to Light Mode'
                          : 'Switch to Dark Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
