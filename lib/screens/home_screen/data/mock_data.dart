import 'package:android_dev/screens/home_screen/models/comments_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';

// Fake data until the app has a real server.
// Post photos: picsum.photos/id/<n>. Avatars: i.pravatar.cc/?img=<n>.

String _avatar(int n) => 'https://i.pravatar.cc/150?img=$n';
String _photo(int n) => 'https://picsum.photos/id/$n/600/400';

final List<StoryModel> mockStories = [
  StoryModel(username: 'aida', imageUrl: _avatar(5)),
  StoryModel(username: 'timur', imageUrl: _avatar(12)),
  StoryModel(username: 'aliya', imageUrl: _avatar(9)),
  StoryModel(username: 'nursultan', imageUrl: _avatar(14)),
  StoryModel(username: 'dana', imageUrl: _avatar(16)),
  StoryModel(username: 'erlan', imageUrl: _avatar(33)),
  StoryModel(username: 'kamila', imageUrl: _avatar(20)),
  StoryModel(username: 'bekzat', imageUrl: _avatar(51)),
  StoryModel(username: 'aruzhan', imageUrl: _avatar(25)),
  StoryModel(username: 'askar', imageUrl: _avatar(59)),
];

final List<PostModel> mockPosts = [
  PostModel(
    imageUrl: _photo(10),
    description: 'Morning walk in the forest 🌲',
    likeCount: 124,
    comments: [
      CommentModel(id: 'p1_c1', text: 'So peaceful!', author: 'aida', userImageUrl: _avatar(5)),
      CommentModel(id: 'p1_c2', text: 'Where is this?', author: 'timur', userImageUrl: _avatar(12)),
    ],
  ),
  PostModel(
    imageUrl: _photo(11),
    description: 'Weekend in the mountains',
    likeCount: 87,
    comments: [
      CommentModel(id: 'p2_c1', text: 'Take me with you next time', author: 'dana', userImageUrl: _avatar(16)),
    ],
  ),
  PostModel(
    imageUrl: _photo(15),
    description: 'Found a hidden waterfall 💧',
    likeCount: 301,
    comments: [
      CommentModel(id: 'p3_c1', text: 'Wow, amazing view', author: 'erlan', userImageUrl: _avatar(33)),
      CommentModel(id: 'p3_c2', text: 'Is the water cold?', author: 'kamila', userImageUrl: _avatar(20)),
      CommentModel(id: 'p3_c3', text: 'Adding this to my list', author: 'askar', userImageUrl: _avatar(59)),
    ],
  ),
  PostModel(
    imageUrl: _photo(17),
    description: 'Road trip day 1 🚗',
    likeCount: 56,
    comments: [
      CommentModel(id: 'p4_c1', text: 'Safe travels!', author: 'aliya', userImageUrl: _avatar(9)),
    ],
  ),
  PostModel(
    imageUrl: _photo(20),
    description: 'New desk setup, finally done',
    likeCount: 210,
    comments: [
      CommentModel(id: 'p5_c1', text: 'Clean setup 🔥', author: 'bekzat', userImageUrl: _avatar(51)),
      CommentModel(id: 'p5_c2', text: 'What keyboard is that?', author: 'nursultan', userImageUrl: _avatar(14)),
    ],
  ),
  PostModel(
    imageUrl: _photo(24),
    description: 'Started reading a new book 📖',
    likeCount: 43,
    comments: [
      CommentModel(id: 'p6_c1', text: 'Tell me if it is good', author: 'aruzhan', userImageUrl: _avatar(25)),
    ],
  ),
  PostModel(
    imageUrl: _photo(28),
    description: 'Sunset by the lake',
    likeCount: 389,
    comments: [
      CommentModel(id: 'p7_c1', text: 'Those colors!', author: 'aida', userImageUrl: _avatar(5)),
      CommentModel(id: 'p7_c2', text: 'Perfect timing', author: 'erlan', userImageUrl: _avatar(33)),
    ],
  ),
  PostModel(
    imageUrl: _photo(29),
    description: 'Snow on the peaks already ❄️',
    likeCount: 172,
    comments: [
      CommentModel(id: 'p8_c1', text: 'Winter is coming', author: 'timur', userImageUrl: _avatar(12)),
    ],
  ),
  PostModel(
    imageUrl: _photo(30),
    description: 'Coffee first, then code ☕',
    likeCount: 95,
    comments: [
      CommentModel(id: 'p9_c1', text: 'Same every morning', author: 'askar', userImageUrl: _avatar(59)),
      CommentModel(id: 'p9_c2', text: 'Which cafe?', author: 'dana', userImageUrl: _avatar(16)),
    ],
  ),
  PostModel(
    imageUrl: _photo(36),
    description: 'Exploring the old city streets',
    likeCount: 64,
    comments: [
      CommentModel(id: 'p10_c1', text: 'Love this architecture', author: 'kamila', userImageUrl: _avatar(20)),
    ],
  ),
  PostModel(
    imageUrl: _photo(37),
    description: 'Picnic with friends 🧺',
    likeCount: 143,
    comments: [
      CommentModel(id: 'p11_c1', text: 'Why was I not invited 😅', author: 'nursultan', userImageUrl: _avatar(14)),
      CommentModel(id: 'p11_c2', text: 'Great day!', author: 'aliya', userImageUrl: _avatar(9)),
    ],
  ),
  PostModel(
    imageUrl: _photo(39),
    description: 'Night sky from the campsite ✨',
    likeCount: 512,
    comments: [
      CommentModel(id: 'p12_c1', text: 'You can see so many stars', author: 'bekzat', userImageUrl: _avatar(51)),
    ],
  ),
  PostModel(
    imageUrl: _photo(42),
    description: 'Tried a new restaurant tonight',
    likeCount: 78,
    comments: [
      CommentModel(id: 'p13_c1', text: 'How was the food?', author: 'aruzhan', userImageUrl: _avatar(25)),
      CommentModel(id: 'p13_c2', text: 'Looks cozy', author: 'timur', userImageUrl: _avatar(12)),
    ],
  ),
  PostModel(
    imageUrl: _photo(48),
    description: 'Late night study session 💻',
    likeCount: 39,
    comments: [
      CommentModel(id: 'p14_c1', text: 'Good luck on the exam!', author: 'aida', userImageUrl: _avatar(5)),
    ],
  ),
  PostModel(
    imageUrl: _photo(49),
    description: 'Fields of green after the rain',
    likeCount: 156,
    comments: [
      CommentModel(id: 'p15_c1', text: 'Fresh air vibes', author: 'erlan', userImageUrl: _avatar(33)),
      CommentModel(id: 'p15_c2', text: 'Beautiful shot', author: 'kamila', userImageUrl: _avatar(20)),
    ],
  ),
  PostModel(
    imageUrl: _photo(54),
    description: 'Climbed to the top today 🏔️',
    likeCount: 267,
    comments: [
      CommentModel(id: 'p16_c1', text: 'Respect, that is high!', author: 'askar', userImageUrl: _avatar(59)),
    ],
  ),
  PostModel(
    imageUrl: _photo(57),
    description: 'Bike ride along the river 🚲',
    likeCount: 91,
    comments: [
      CommentModel(id: 'p17_c1', text: 'Let us ride together on Sunday', author: 'dana', userImageUrl: _avatar(16)),
      CommentModel(id: 'p17_c2', text: 'Nice route', author: 'bekzat', userImageUrl: _avatar(51)),
    ],
  ),
  PostModel(
    imageUrl: _photo(58),
    description: 'Quiet beach, no people around',
    likeCount: 330,
    comments: [
      CommentModel(id: 'p18_c1', text: 'Paradise 🏝️', author: 'aliya', userImageUrl: _avatar(9)),
    ],
  ),
  PostModel(
    imageUrl: _photo(62),
    description: 'Autumn leaves everywhere 🍂',
    likeCount: 118,
    comments: [
      CommentModel(id: 'p19_c1', text: 'My favorite season', author: 'aruzhan', userImageUrl: _avatar(25)),
      CommentModel(id: 'p19_c2', text: 'So warm colors', author: 'nursultan', userImageUrl: _avatar(14)),
    ],
  ),
  PostModel(
    imageUrl: _photo(65),
    description: 'Last day of vacation, see you soon!',
    likeCount: 74,
    comments: [
      CommentModel(id: 'p20_c1', text: 'Come back soon!', author: 'timur', userImageUrl: _avatar(12)),
    ],
  ),
];
