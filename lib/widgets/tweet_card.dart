import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/provider/like_provider.dart';
import 'package:subtxt_blog/screens/hashtag_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends StatefulWidget {
  final Tweet tweet;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLikePressed;
  final int? currentUserId;

  const TweetCard({
    super.key,
    required this.tweet,
    required this.onTap,
    this.onDelete,
    this.onEdit,
    this.onLikePressed,
    this.currentUserId,
  });

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  @override
  void initState() {
    super.initState();
    // 🔥 This ensures like count/status are loaded when card is built
    Future.microtask(() {
      Provider.of<LikeProvider>(
        context,
        listen: false,
      ).initializeLikeData(widget.tweet.id);
    });
  }

  List<InlineSpan> _buildTweetContentWithHashtags(
    BuildContext context,
    String content,
  ) {
    final words = content.split(' ');
    final accentColor = Theme.of(context).colorScheme.primary;

    return words.map((word) {
      if (word.startsWith('#')) {
        final tag = word.replaceFirst('#', '');
        return TextSpan(
          text: '$word ',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HashtagScreen(hashtag: tag)),
              );
            },
        );
      } else {
        return TextSpan(text: '$word ');
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final isOwner = widget.tweet.userId == widget.currentUserId;

    final likeProvider = context.watch<LikeProvider>();
    final isLiked = likeProvider.isLiked(widget.tweet.id);
    final likeCount = likeProvider.getLikeCount(widget.tweet.id);

    return InkWell(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: accentColor.withAlpha(40),
                    child: const Icon(Icons.person, color: Colors.black87),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@${widget.tweet.username}",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timeago.format(widget.tweet.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withAlpha(
                              (0.6 * 255).toInt(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOwner &&
                      (widget.onEdit != null || widget.onDelete != null))
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') widget.onEdit?.call();
                        if (value == 'delete') widget.onDelete?.call();
                      },
                      itemBuilder: (context) => [
                        if (widget.onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                        if (widget.onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 12),

              /// Tweet content
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: _buildTweetContentWithHashtags(
                    context,
                    widget.tweet.content,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Like + actions
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.redAccent : Colors.grey,
                    ),
                    onPressed: widget.onLikePressed,
                  ),
                  Text('$likeCount', style: theme.textTheme.bodySmall),
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline, color: accentColor),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: accentColor),
                    onPressed: () {},
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
