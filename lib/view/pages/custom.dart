import 'package:flutter/material.dart';
import 'package:air_guard/data/palatte.dart';
import 'package:air_guard/data/constant_data.dart';
import 'package:air_guard/view/widget/app_bar.dart';
import 'package:air_guard/view/widget/custom_cards.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';
import 'package:air_guard/view/widget/custom_widgets/theme_buttons.dart';
import 'package:air_guard/view/widget/custom_widgets/general_section.dart';
import 'package:air_guard/view/widget/custom_widgets/connection_indegator.dart';

class Custom extends StatefulWidget {
  const Custom({super.key});

  @override
  State<Custom> createState() => _CustomState();
}

class _CustomState extends State<Custom> {
    late List<Item> items = [
      Item(
        title: "Account",
        icon: FluentIcons.person_20_regular,
        child: accountSection(),
      ),
      Item(
        title: "Connection",
        icon: FluentIcons.cloud_20_regular,
        child: ConnectionIndegator(),
      ),
      Item(
        title: "Appearance",
        icon: FluentIcons.apps_20_regular,
        child: ThemeButtons(),
      ),
      Item(
        title: "General",
        icon: FluentIcons.settings_20_regular,
        child: General(),
      )
    ];

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: context.mainColors.primaryBg,
      appBar: DefaultAppBar(),
      body: Container(        
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView.separated(
          itemCount: items.length,
          itemBuilder: (_, index) {
            final item = items[index];
            return CustomCards(item : item);
          },
          separatorBuilder: (_, _) => SizedBox(height: 10,),
        ),
      ),
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }

  // Widget customWidgetExpandable(Item item, dynamic mainColors) {
    
  // }

  Widget accountSection(){
    return Center();
  }

  Widget connectionSection(){
    return Center();
  }

  // Widget themeButtons() {
    
  // }
  
  // Widget generalSection() {
    

  // }
}