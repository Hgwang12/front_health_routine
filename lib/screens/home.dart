import 'package:flutter/material.dart';

class Goal {
  final String text;
  bool done;
  Goal(this.text, {this.done = false});
}

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
      appBar: AppBar(
        title: const Text("홈 화면"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showGoalEditor,
          ),
        ],
      ),
      body: Column(
        children: [
          // 목표 노트 영역
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown, width: 1),
              ),
              child: CustomPaint(
                painter: _NoteLinePainter(),
                child: _goals.isEmpty
                    ? const Center(
                  child: Text(
                    "오늘의 목표를 작성하세요",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25, horizontal: 16),
                  itemCount: _goals.length,
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "• ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            goal.text,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: goal.done
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: goal.done
                                  ? Colors.black45
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: goal.done,
                          onChanged: (val) {
                            setState(() {
                              goal.done = val ?? false;
                            });
                          },
                          fillColor:
                          MaterialStateProperty.resolveWith<Color?>(
                                  (states) {
                                if (states
                                    .contains(MaterialState.selected)) {
                                  return Colors.blue[300];
                                }
                                return null;
                              }),
                          checkColor: Colors.white,
                          side: const BorderSide(
                              color: Colors.black45, width: 1),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // 퍼센트 바
          Container(
            padding: const EdgeInsets.all(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalEditor() {
    _controller.clear(); // 기존 텍스트 초기화
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("오늘의 목표 작성"),
        content: TextField(
          controller: _controller,
          maxLines: 6,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            hintText: '목표를 입력하세요',
            border: InputBorder.none,
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[300]),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _confirmSave(_controller.text.trim());
              }
            },
            child: const Text('저장', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _confirmSave(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("목표 확정"),
        content: const Text(
          "한번 저장한 목표는 취소/수정할 수 없습니다.\n정말로 목표를 확정하시겠습니까?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[300]),
            onPressed: () {
              setState(() {
                _goals.add(Goal(text));
              });
              Navigator.pop(context);
            },
            child: const Text("확정", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

// 📒 노트 줄 커스텀 페인터
class _NoteLinePainter extends CustomPainter {
  static const double lineHeight = 32;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.3)
      ..strokeWidth = 1;

    for (double y = lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
