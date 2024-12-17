import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsScreen extends StatefulWidget {
  final String menuItemId;
  final String menuItemName;

  const ReviewsScreen({
    Key? key,
    required this.menuItemId,
    required this.menuItemName,
  }) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late Future<List<ReviewWithUser>> _reviewsWithUsersFuture;

  @override
  void initState() {
    super.initState();
    _reviewsWithUsersFuture = _fetchReviewsWithUserNames(widget.menuItemId);
  }

  /// Fetch reviews and their respective user names
  Future<List<ReviewWithUser>> _fetchReviewsWithUserNames(
      String menuItemId) async {
    try {
      final reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('menuItemId', isEqualTo: menuItemId)
          .get();

      List<Review> reviews = reviewsSnapshot.docs
          .map((doc) => Review.fromMap(doc.data()))
          .toList();

      List<Future<ReviewWithUser>> reviewWithUserFutures =
          reviews.map((review) async {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('clients')
            .doc(review.userId)
            .get();

        final userName = userSnapshot.data()?['name'] ?? 'Anonymous';
        return ReviewWithUser(review: review, userName: userName);
      }).toList();

      return await Future.wait(reviewWithUserFutures);
    } catch (e) {
      throw Exception('Failed to fetch reviews and user data: $e');
    }
  }

  Future<void> _refreshReviews() async {
    setState(() {
      _reviewsWithUsersFuture = _fetchReviewsWithUserNames(widget.menuItemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA), // Light background
      appBar: AppBar(
        title: Text(
          'Reviews for ${widget.menuItemName}',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFE0E0E0),
            height: 1.0,
          ),
        ),
      ),
      body: FutureBuilder<List<ReviewWithUser>>(
        future: _reviewsWithUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reviews yet. Be the first to write one!',
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
              ),
            );
          } else {
            final reviewsWithUsers = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshReviews,
              child: ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: reviewsWithUsers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                itemBuilder: (context, index) {
                  final reviewWithUser = reviewsWithUsers[index];
                  return _buildReviewCard(reviewWithUser);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildReviewCard(ReviewWithUser reviewWithUser) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFFF7F7F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User's Name and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reviewWithUser.userName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < reviewWithUser.review.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            const SizedBox(height: 8.0),
            // Review Content
            Text(
              reviewWithUser.review.reviewContent,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class to hold a review and its user's name
class ReviewWithUser {
  final Review review;
  final String userName;

  ReviewWithUser({required this.review, required this.userName});
}

/// Review Model
class Review {
  final String id;
  final String userId;
  final String menuItemId;
  final String reviewContent;
  final int rating;

  Review({
    required this.id,
    required this.userId,
    required this.menuItemId,
    required this.reviewContent,
    required this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      menuItemId: map['menuItemId'] ?? '',
      reviewContent: map['reviewContent'] ?? '',
      rating: map['rating'] ?? 0,
    );
  }
}
