import 'package:flutter/material.dart';
import '../objectbox.g.dart';
import '../memberData.dart';
import 'add.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  Store? store;
  Box<Member>? memberBox;
  List<Member> members = [];

  //initState の中では async/await を使うことができないので、
  //新しくメソッドを用意して、storeとboxを作成する
  Future<void> initialize() async {
    store = await openStore();
    memberBox = store?.box<Member>();
    fetchMembers();
  }

  /// Box から LifeEvent 一覧を取得します
  void fetchMembers() {
    members = memberBox?.getAll() ?? [];
    setState(() {});
  }

  //StatefulWidgetで使用されるウィジェットの初期化時に呼び出されるメソッド
  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    store?.close(); // アプリ終了時にStoreを閉じる
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '入力画面',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  title: Text(member.name),
                  subtitle: Text(member.groupName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            member.count--;
                            memberBox?.put(member);
                            fetchMembers();
                          }),
                      Text(
                        '${member.count}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            member.count++;
                            memberBox?.put(member);
                            fetchMembers();
                          }),
                      IconButton(
                        onPressed: () {
                          memberBox?.remove(member.id);
                          fetchMembers();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
                child: const Icon(Icons.person_add_alt_1),
                onPressed: () async {
                  final newMember = await Navigator.of(context).push<Member>(
                    // onPressed: () {
                    //   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return const AddScreen();
                    }),
                  );
                  if (newMember != null) {
                    memberBox?.put(newMember);
                    fetchMembers();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
