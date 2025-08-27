import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _goals = []; // { 'text': 목표내용, 'done': bool }

  @override
  Widget build(BuildContext context) {
    int doneCount = _goals.where((g) => g['done'] == true).length;
    int total = _goals.length;
    double progress = total > 0 ? doneCount / total : 0;

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
                            _goals[index]['text'],
                            style: TextStyle(
                              fontSize: 16,
                              decoration: _goals[index]['done']
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: _goals[index]['done']
                                  ? Colors.black45
                                  : Colors.black,
                            ),
                          ),
                        ),
                        // 체크박스: 기존 UI 유지 + 외곽선 살아있게
                        Checkbox(
                          value: _goals[index]['done'],
                          onChanged: (val) {
                            setState(() {
                              _goals[index]['done'] = val;
                            });
                          },
                          fillColor:
                          MaterialStateProperty.resolveWith<Color?>(
                                  (states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.blue[300]; // 체크 시 내부 색
                                }
                                return null; // 체크 안 했을 때 배경 투명 유지
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
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("오늘의 목표 작성"),
        content: TextField(
          controller: controller,
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
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _confirmSave(controller.text.trim());
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
                _goals.add({'text': text, 'done': false});
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.3)
      ..strokeWidth = 1;

    double lineHeight = 32;
    for (double y = lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
