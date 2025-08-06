import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/models/tweet_request.dart';
import 'package:subtxt_blog/provider/tweet_provider.dart';

class CreateTweetCard extends StatefulWidget {
  const CreateTweetCard({super.key});

  @override
  State<CreateTweetCard> createState() => _CreateTweetCardState();
}

class _CreateTweetCardState extends State<CreateTweetCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final trimmed = _controller.text.trim();
    setState(() {
      _isButtonEnabled = trimmed.isNotEmpty && !_isSubmitting;
    });
  }

  Future<void> _submitTweet() async {
    if (!mounted) return;

    final tweetProvider = context.read<TweetProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() {
      _isSubmitting = true;
      _isButtonEnabled = false;
    });

    try {
      await tweetProvider.createTweet(TweetRequest(content: content));
      _controller.clear();
      FocusScope.of(context).unfocus();

      await tweetProvider.fetchUserFeed();

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Tweet posted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to post tweet: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isButtonEnabled = _controller.text.trim().isNotEmpty;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                filled: true,
                fillColor:
                    theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
                border: theme.inputDecorationTheme.border,
              ),
              cursorColor: theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _submitTweet : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
