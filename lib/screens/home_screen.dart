import 'package:flutter/material.dart';

/// HomeScreen displays the main dashboard with user activity and tasks
/// This screen shows activity metrics, upcoming tasks, and user profile info
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State class for HomeScreen
/// Uses SingleTickerProviderStateMixin since we only need one main animation controller
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  /// Main animation controller for staggered animations of screen elements
  late AnimationController _animationController;

  /// List of animations for each UI section (header, card, tabs, tasks)
  /// Uses stagger effect - each element animates with a delay
  late List<Animation<Offset>> _itemAnimations;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for total duration of 1200ms
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create 4 staggered animations for different UI elements
    // Each animation: slides content up from below with a time delay
    _itemAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3), // Start position: below normal position
        end: Offset.zero, // End position: normal position
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          // Interval creates a stagger effect:
          // Index 0: 0ms to 400ms delay
          // Index 1: 100ms to 500ms delay
          // Index 2: 200ms to 600ms delay
          // Index 3: 300ms to 700ms delay
          curve: Interval(
            0.1 * index,
            0.1 * index + 0.4,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    // Start the animation automatically when screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    // Clean up animation controller to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light gray background for the entire screen
      backgroundColor: const Color(0xFFFAFAFA),
      // CustomScrollView allows combining SliverAppBar with scrollable content
      body: CustomScrollView(
        slivers: [
          // ========== APP BAR / HEADER SECTION ==========
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0, // No shadow
            pinned: true, // Header stays at top when scrolling
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                // Apply first staggered animation to header
                child: SlideTransition(
                  position: _itemAnimations[0],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left section: Welcome text (commented out - can be uncommented)
                        // const Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'WELCOME BACK',
                        //       style: TextStyle(
                        //         fontSize: 11,
                        //         fontWeight: FontWeight.w600,
                        //         color: Colors.grey,
                        //         letterSpacing: 1.2,
                        //       ),
                        //     ),
                        //     SizedBox(height: 4),
                        //     Text(
                        //       'Alex Morgan',
                        //       style: TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black87,
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // Right section: User avatar and notification icon
                        Row(
                          children: [
                            // User avatar (commented out - requires asset image)
                            // CircleAvatar(
                            //   radius: 24,
                            //   backgroundColor: const Color(0xFFE8E8E8),
                            //   child: Image.asset(
                            //     'assets/avatar.png',
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            const SizedBox(width: 12),

                            // Notification bell with red indicator dot
                            Stack(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 26,
                                  color: Colors.black54,
                                ),
                                // Red dot indicating unread notifications
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ========== MAIN CONTENT SECTION ==========
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Activity Card - Shows weekly activity metrics
                    SlideTransition(
                      position:
                          _itemAnimations[1], // Second staggered animation
                      child: _buildActivityCard(),
                    ),

                    const SizedBox(height: 28),

                    // Filter Tabs - All, Updates, Messages
                    SlideTransition(
                      position: _itemAnimations[2], // Third staggered animation
                      child: _buildTabButtons(),
                    ),

                    const SizedBox(height: 24),

                    // Upcoming Tasks List
                    SlideTransition(
                      position:
                          _itemAnimations[3], // Fourth staggered animation
                      child: _buildUpcomingTasks(),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700), // Bright yellow
        onPressed: () {
          // TODO: Add new task functionality
        },
        child: const Icon(Icons.add, color: Colors.black87, size: 28),
      ),
    );
  }

  /// Builds the yellow activity card showing weekly statistics
  /// Displays percentage, progress bar, and trending indicator
  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Yellow gradient background
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFEB3B), Color(0xFFFDD835)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with title and trending badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              const Text(
                'Your Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              // Trending indicator badge (+12%)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, size: 14, color: Colors.black87),
                    SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Subtitle
          const Text(
            'Weekly Overview',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // Main content: Percentage and action button
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // Large percentage number
              const Text(
                '85',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Percentage symbol
              const SizedBox(width: 8),
              const Text(
                '%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              // Spacer to push button to right
              const Spacer(),
              // Action button (arrow)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress indicator bar (85% filled)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.85, // 85% progress
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the filter tab buttons (All, Updates, Messages)
  /// These buttons allow users to filter the tasks/content
  Widget _buildTabButtons() {
    return Row(
      children: [
        // "All" tab - active by default (black background)
        _buildTabButton('All', true),
        const SizedBox(width: 12),
        // "Updates" tab - inactive (white background)
        _buildTabButton('Updates', false),
        const SizedBox(width: 12),
        // "Messages" tab - inactive (white background)
        _buildTabButton('Messages', false),
      ],
    );
  }

  /// Builds individual tab button with active/inactive styling
  /// [label] - Text displayed on button
  /// [isActive] - Whether this tab is currently selected
  Widget _buildTabButton(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        // Black background for active, white for inactive
        color: isActive ? Colors.black87 : Colors.white,
        border: Border.all(
          color: isActive ? Colors.black87 : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          // White text for active, dark for inactive
          color: isActive ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  /// Builds the upcoming tasks section
  /// Displays a list of tasks with different types and details
  Widget _buildUpcomingTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with "See All" link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Task 1: Project Alpha
        _buildTaskItem(
          icon: Icons.work_outline,
          title: 'Project Alpha',
          subtitle: 'Due tomorrow · High...',
          hasArrow: true,
        ),

        const SizedBox(height: 12),

        // Task 2: Team Meeting (with video call indicator)
        _buildTaskItem(
          icon: Icons.group_outlined,
          title: 'Team Meeting',
          subtitle: '10:00 AM · Room 602',
          hasArrow: false,
          // Custom trailing widget - yellow video call icon
          trailingWidget: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.videocam, size: 18, color: Colors.black87),
          ),
        ),

        const SizedBox(height: 12),

        // Task 3: Design Review
        _buildTaskItem(
          icon: Icons.palette_outlined,
          title: 'Design Review',
          subtitle: 'Pending Approval',
          hasArrow: true,
        ),
      ],
    );
  }

  /// Builds individual task item card
  /// [icon] - Icon representing the task type
  /// [title] - Task name/title
  /// [subtitle] - Additional task details
  /// [hasArrow] - Show arrow icon if true
  /// [trailingWidget] - Optional custom widget on the right side
  Widget _buildTaskItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool hasArrow,
    Widget? trailingWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Subtle shadow for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container on left
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.black54),
          ),

          const SizedBox(width: 16),

          // Title and subtitle in the middle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // Task details/subtitle
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Right side: either custom widget or arrow icon
          if (trailingWidget != null)
            trailingWidget
          else if (hasArrow)
            Icon(Icons.arrow_forward, size: 20, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
