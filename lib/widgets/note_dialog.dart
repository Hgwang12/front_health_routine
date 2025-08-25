import 'package:flutter/material.dart';

class NoteDialog {
  // 새 메모 작성
  static Future<void> showEditor(
      BuildContext context, {
        required Function(String) onSave,
      }) async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // 배경 하얀색
        title: const Text('새 메모 작성'),
        content: SizedBox(
          height: 180,
          child: TextField(
            controller: controller,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: '메모를 입력하세요',
              border: InputBorder.none,
              alignLabelWithHint: true,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '취소',
              style: TextStyle(color: Colors.black), // 텍스트 검은색
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300], // 연한 파랑
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text(
              '저장',
              style: TextStyle(color: Colors.black), // 텍스트 검은색
            ),
          ),
        ],
      ),
    );
  }

  // 선택 날짜의 메모 목록
  static Future<void> showList(
      BuildContext context, {
        required DateTime day,
        required List<String> notes,
        required Function(String) onAdd,
      }) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // 다이얼로그 배경 투명
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // 위아래 모두 라운드
          child: Container(
            width: 350,
            height: 400,
            color: Colors.white, // 내부 배경 하얀색
            child: Column(
              children: [
                // 상단: 날짜 + X 버튼 + 연필 아이콘
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${day.year}-${day.month}-${day.day} 메모',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pop(context);
                              showEditor(context, onSave: onAdd);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // 메모 목록
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: notes.isNotEmpty
                        ? ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white70,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(notes[index]),
                          ),
                        );
                      },
                    )
                        : const Center(child: Text('작성된 메모가 없습니다')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
