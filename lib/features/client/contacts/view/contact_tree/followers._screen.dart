import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/contacts/view/contact_tree/widgets/follower_list_item.dart';
import 'package:flutter/material.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({super.key});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  final List<Map<String, dynamic>> _followers = [
    {
      'id': '1',
      'name': 'Maria Khalid',
      'isVerified': true,
      'avatar': 'assets/images/profile.png',
      'isFollowing': true,
    },
    {
      'id': '2',
      'name': 'Diana Sayal',
      'isVerified': true,
      'avatar': 'assets/images/brand-two.png',
      'isFollowing': true,
    },
    {
      'id': '3',
      'name': 'Comfort Shoes',
      'isVerified': true,
      'avatar': 'assets/images/brand-logo.png',
      'isFollowing': true,
    },
    {
      'id': '4',
      'name': 'Naseeba Attar',
      'isVerified': true,
      'avatar': 'assets/images/profile.png',
      'isFollowing': true,
    },
  ];

  void _toggleFollow(String id) {
    setState(() {
      final index = _followers.indexWhere((follower) => follower['id'] == id);
      if (index != -1) {
        _followers[index]['isFollowing'] = !_followers[index]['isFollowing'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: 'follower_title'.tr(context),
              centerTitle: true,
              showBackButton: true,
            ),

            // Follower List
            _buildFollowersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowersList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _followers.length,
        itemBuilder: (context, index) {
          final follower = _followers[index];
          return FollowerListItem(
            id: follower['id'],
            name: follower['name'],
            avatar: follower['avatar'],
            isVerified: follower['isVerified'],
            isFollowing: follower['isFollowing'],
            onFollowPressed: () => _toggleFollow(follower['id']),
          );
        },
      ),
    );
  }
}
