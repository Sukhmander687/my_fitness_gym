import 'package:fluttergym/components/Header.dart';
import 'package:fluttergym/components/tab_view_base.dart';
import 'package:flutter/material.dart';
import 'package:fluttergym/utils/const.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(

          body: Column(
            children: <Widget>[
              TabBar(
                tabs: <Widget>[
                  Container(
                    height: 30.0,
                    child: Tab(
                      text: 'Breakfast',
                    ),
                  ),
                  Container(
                    height: 30.0,
                    child: Tab(
                      text: 'Lunch',
                    ),
                  ),
                  Container(
                    height: 30.0,
                    child: Tab(
                      text: 'Dinner',
                    ),
                  ),
                  Container(
                    height: 30.0,
                    child: Tab(
                      text: 'Snacks',
                    ),
                  ),
                ],
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey[400],
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Color.fromRGBO(215, 225, 255, 1.0),
              ) ,
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    TabViewBase(
                      tabName: 'Breakfast',
                    ),
                    TabViewBase(
                      tabName: 'Lunch',
                    ),
                    TabViewBase(
                      tabName: 'Dinner',
                    ),
                    TabViewBase(
                      tabName: 'Snacks',
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
