class Review {
  String id; 
  String userId;
  String menuItemId;
  String reviewContent;

  Review({
    required this.id,  
    required this.userId,
    required this.menuItemId,
    required this.reviewContent,
  });

  // To convert a Review to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,  
      'userId': userId,
      'menuItemId': menuItemId,
      'reviewContent': reviewContent,
    };
  }

  // To convert a Map back to a Review
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'], 
      userId: map['userId'],
      menuItemId: map['menuItemId'],
      reviewContent: map['reviewContent'],
    );
  }
}