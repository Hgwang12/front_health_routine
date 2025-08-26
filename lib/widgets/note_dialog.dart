import 'package:flutter/material.dart';

class NoteDialog {
  // 새 메모 작성 (수정할 때도 같이 씀)
  static Future<void> showEditor(
      BuildContext context, {
        required Function(String) onSave,
        String? initialText, // 수정 시 기존 텍스트
      }) async {
    final controller = TextEditingController(text: initialText ?? "");

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(initialText == null ? '새 메모 작성' : '메모 수정'),
        content: TextField(
          controller: controller,
          maxLines: 6,
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

    controller.dispose();
  }

  // 선택 날짜의 메모 목록
  static Future<void> showList(
      BuildContext context, {
        required DateTime day,
        required List<String> notes,
        required Function(String) onAdd,
        required Function(int, String) onEdit, // 수정 콜백
        required Function(int) onDelete, // 삭제 콜백
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        color: Colors.white70,
                        margin:
                        const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 8, right: 0),
                          title: Text(notes[index]),
                          trailing: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'edit') {
                                // 수정
                                showEditor(
                                  context,
                                  initialText: notes[index],
                                  onSave: (newText) {
                                    onEdit(index, newText);
                                  },
                                );
                              } else if (value == 'delete') {
                                // 삭제
                                onDelete(index);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('수정'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('삭제'),
                              ),
                            ],
                          ),
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
