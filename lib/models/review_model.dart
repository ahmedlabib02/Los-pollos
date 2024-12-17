class Review {
  String id;
  String userId;
  String menuItemId;
  String reviewContent;
  int rating;

  Review({
    required this.id,
    required this.userId,
    required this.menuItemId,
    required this.reviewContent,
    required this.rating,
  });

  // To convert a Review to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'menuItemId': menuItemId,
      'reviewContent': reviewContent,
      'rating': rating,
    };
  }

  // To convert a Map back to a Review
  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      userId: map['userId'],
      menuItemId: map['menuItemId'],
      reviewContent: map['reviewContent'],
      rating: map['rating'],
    );
  }
}
