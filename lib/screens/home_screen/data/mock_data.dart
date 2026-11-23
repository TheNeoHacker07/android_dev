// Starter content written into the database the first time the app runs
// (see AppDatabase.migration -> onCreate). After that everything comes from
// the database.
// Post photos: picsum.photos/id/<n>. Avatars: i.pravatar.cc/?img=<n>.

String avatarUrl(int n) => 'https://i.pravatar.cc/150?img=$n';
String _photo(int n) => 'https://picsum.photos/id/$n/600/400';

/// Every seed user can log in with this password, e.g. aida / password123.
const seedPassword = 'password123';

const List<({String username, int avatar})> seedUsers = [
  (username: 'aida', avatar: 5),
  (username: 'timur', avatar: 12),
  (username: 'aliya', avatar: 9),
  (username: 'nursultan', avatar: 14),
  (username: 'dana', avatar: 16),
  (username: 'erlan', avatar: 33),
  (username: 'kamila', avatar: 20),
  (username: 'bekzat', avatar: 51),
  (username: 'aruzhan', avatar: 25),
  (username: 'askar', avatar: 59),
];

typedef SeedPost = ({
  String author,
  String imageUrl,
  String description,
  List<(String author, String text)> comments,
});

final List<SeedPost> seedPosts = [
  (author: 'aida', imageUrl: _photo(10), description: 'Morning walk in the forest 🌲', comments: [
    ('aida', 'So peaceful!'),
    ('timur', 'Where is this?'),
  ]),
  (author: 'timur', imageUrl: _photo(11), description: 'Weekend in the mountains', comments: [
    ('dana', 'Take me with you next time'),
  ]),
  (author: 'aliya', imageUrl: _photo(15), description: 'Found a hidden waterfall 💧', comments: [
    ('erlan', 'Wow, amazing view'),
    ('kamila', 'Is the water cold?'),
    ('askar', 'Adding this to my list'),
  ]),
  (author: 'nursultan', imageUrl: _photo(17), description: 'Road trip day 1 🚗', comments: [
    ('aliya', 'Safe travels!'),
  ]),
  (author: 'dana', imageUrl: _photo(20), description: 'New desk setup, finally done', comments: [
    ('bekzat', 'Clean setup 🔥'),
    ('nursultan', 'What keyboard is that?'),
  ]),
  (author: 'erlan', imageUrl: _photo(24), description: 'Started reading a new book 📖', comments: [
    ('aruzhan', 'Tell me if it is good'),
  ]),
  (author: 'kamila', imageUrl: _photo(28), description: 'Sunset by the lake', comments: [
    ('aida', 'Those colors!'),
    ('erlan', 'Perfect timing'),
  ]),
  (author: 'bekzat', imageUrl: _photo(29), description: 'Snow on the peaks already ❄️', comments: [
    ('timur', 'Winter is coming'),
  ]),
  (author: 'aruzhan', imageUrl: _photo(30), description: 'Coffee first, then code ☕', comments: [
    ('askar', 'Same every morning'),
    ('dana', 'Which cafe?'),
  ]),
  (author: 'askar', imageUrl: _photo(36), description: 'Exploring the old city streets', comments: [
    ('kamila', 'Love this architecture'),
  ]),
  (author: 'aida', imageUrl: _photo(37), description: 'Picnic with friends 🧺', comments: [
    ('nursultan', 'Why was I not invited 😅'),
    ('aliya', 'Great day!'),
  ]),
  (author: 'timur', imageUrl: _photo(39), description: 'Night sky from the campsite ✨', comments: [
    ('bekzat', 'You can see so many stars'),
  ]),
  (author: 'aliya', imageUrl: _photo(42), description: 'Tried a new restaurant tonight', comments: [
    ('aruzhan', 'How was the food?'),
    ('timur', 'Looks cozy'),
  ]),
  (author: 'nursultan', imageUrl: _photo(48), description: 'Late night study session 💻', comments: [
    ('aida', 'Good luck on the exam!'),
  ]),
  (author: 'dana', imageUrl: _photo(49), description: 'Fields of green after the rain', comments: [
    ('erlan', 'Fresh air vibes'),
    ('kamila', 'Beautiful shot'),
  ]),
  (author: 'erlan', imageUrl: _photo(54), description: 'Climbed to the top today 🏔️', comments: [
    ('askar', 'Respect, that is high!'),
  ]),
  (author: 'kamila', imageUrl: _photo(57), description: 'Bike ride along the river 🚲', comments: [
    ('dana', 'Let us ride together on Sunday'),
    ('bekzat', 'Nice route'),
  ]),
  (author: 'bekzat', imageUrl: _photo(58), description: 'Quiet beach, no people around', comments: [
    ('aliya', 'Paradise 🏝️'),
  ]),
  (author: 'aruzhan', imageUrl: _photo(62), description: 'Autumn leaves everywhere 🍂', comments: [
    ('aruzhan', 'My favorite season'),
    ('nursultan', 'So warm colors'),
  ]),
  (author: 'askar', imageUrl: _photo(65), description: 'Last day of vacation, see you soon!', comments: [
    ('timur', 'Come back soon!'),
  ]),
];
