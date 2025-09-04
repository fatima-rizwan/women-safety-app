import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_safety_app/data/services/review_services.dart';
import 'package:women_safety_app/res/utils/utils.dart';

class ReviewViewModel extends GetxController {
  var location = TextEditingController();
  var review = TextEditingController();

  final ReviewServices reviewServices = ReviewServices();

  Future addReviews({String? location, String? review}) async {
    try {
      return reviewServices.addReviews(location: location, review: review);
    } catch (e) {
      showError(e.toString());
    }
  }

  Stream<QuerySnapshot> getReviews() {
    try {
      return reviewServices.getReviews();
    } catch (e) {
      return showError(e.toString());
    }
  }

  Future<void> editReviewDialog(BuildContext context,
      {required String docId, required String oldReview, required String location}) async {
    var editController = TextEditingController(text: oldReview);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Review'),
        content: TextFormField(
          controller: editController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter updated review',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('reviews')
                    .doc(docId)
                    .update({'review': editController.text.trim()});
                Navigator.pop(context);
                showSuccess('Review updated successfully', '');
              } catch (e) {
                showError('Error updating review: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
