import 'package:flutter/material.dart';
import 'package:flutter_app/repository/contents_repository.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContentsRepository contentsRepository;
  List<Map<String, String>> datas = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contentsRepository = ContentsRepository();
  }

  _loadContents() {
    return contentsRepository.loadContentsData();
  }

  _makeDataList(List<Map<String, String>> data) {
    datas = data;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (BuildContext _context, int index) {
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  // width를 맞출때 사용
                  child: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          datas[index]["title"],
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          datas[index]["location"],
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                        Text(datas[index]["date"]),
                      ],
                    ),
                  ),
                )
              ],
            ));
      },
      separatorBuilder: (BuildContext _context, int index) {
        return Container(
          height: 1,
          color: Color(0xff999999),
        );
      },
      itemCount: datas.length,
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        //데이터 API 통신
        future: _loadContents(),
        builder: (context, snapshot) {
          //snapshot null check를 해줘야함
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator()); //데이터가 안왔을때 로딩처리
          }

          if (snapshot.hasError) {
            // 에러 로직처리
            return Center(
              child: Text("데이터 오류"),
            );
          }

          if (snapshot.hasData) { // 데이터가 있을 때만 데이터를 넘겨줌
            return _makeDataList(snapshot.data);
          }

          return Center(child: Text("데이터가 없습니다."),)
        });
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }
}
