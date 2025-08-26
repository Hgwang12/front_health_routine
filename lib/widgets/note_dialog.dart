import 'package:flutter/material.dart';

class NoteDialog {
  // 새 메모 작성
  static Future<void> showEditor(
      BuildContext context, {
        required Function(String) onSave,
      }) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('새 메모 작성'),
        content: TextField(
          controller: controller,
          maxLines: 6, // 🔑 입력창 높이 제한 (6줄까지만 확장)
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            hintText: '메모를 입력하세요',
            border: InputBorder.none,
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '취소',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300],
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text(
              '저장',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );

    controller.dispose(); // 🔑 다이얼로그 닫히면 해제
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
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 350,
            height: 400,
            color: Colors.white,
            child: Column(
              children: [
                // 상단: 날짜 + X 버튼 + 연필 아이콘
                Padding(
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
                  child: notes.isNotEmpty
                      ? ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white70, // 메모 카드 흰색
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
