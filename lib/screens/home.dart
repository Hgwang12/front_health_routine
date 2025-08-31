import 'package:flutter/material.dart';

// 데이터 모델
class Goal {
  final String text;
  bool done;
  Goal(this.text, {this.done = false});
}

// 홈 화면
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Goal> _goals = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _goals.where((g) => g.done).length;
    final total = _goals.length;
    final double progress = total > 0 ? doneCount / total : 0;

    return Scaffold(
      backgroundColor: Colors.grey[100], // 배경색 변경
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.home, color: Colors.green, size: 20),
                  SizedBox(width: 6),
                  Text('오늘의 목표', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.grey),
              iconSize: 22,
              onPressed: _showGoalEditor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 목표 카드
            Expanded(
              child: GoalCard(
                goals: _goals,
                onGoalChanged: (index, value) {
                  setState(() {
                    _goals[index].done = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // 진행률 표시줄
            ProgressBar(progress: progress),
          ],
        ),
      ),
    );
  }

  void _showGoalEditor() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("새로운 목표", style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '목표를 입력하세요...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _confirmSave(_controller.text.trim());
              }
            },
            child: const Text('추가', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmSave(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("목표 확정", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          "한번 저장한 목표는 취소/수정할 수 없습니다.\n정말로 목표를 확정하시겠습니까?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() {
                _goals.add(Goal(text));
              });
              Navigator.pop(context);
            },
            child: const Text("확정", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// 목표 카드 UI
class GoalCard extends StatelessWidget {
  final List<Goal> goals;
  final Function(int, bool) onGoalChanged;

  const GoalCard({Key? key, required this.goals, required this.onGoalChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: goals.isEmpty
          ? const Center(
        child: Text(
          "목표를 추가하여 하루를 계획하세요!",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return GoalTile(
            goal: goal,
            onChanged: (value) => onGoalChanged(index, value!),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

// 개별 목표 타일
class GoalTile extends StatelessWidget {
  final Goal goal;
  final ValueChanged<bool?> onChanged;

  const GoalTile({Key? key, required this.goal, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: goal.done,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      title: Text(
        goal.text,
        style: TextStyle(
          fontSize: 16,
          decoration: goal.done ? TextDecoration.lineThrough : null,
          color: goal.done ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}

// 진행률 표시줄 UI
class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '달성률: ${(progress * 100).toInt()}%',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
