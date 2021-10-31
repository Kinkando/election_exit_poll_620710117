import 'package:election_exit_poll_620710117/models/candidate.dart';
import 'package:election_exit_poll_620710117/pages/result/result_page.dart';
import 'package:election_exit_poll_620710117/services/api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<Candidate>> _futureCandidate;

  @override
  void initState() {
    super.initState();
    _futureCandidate = _loadCandidates();
  }

  Future<List<Candidate>> _loadCandidates() async {
    List list = await Api().fetch('exit_poll');
    var candidate = list.map((item) => Candidate.fromJson(item)).toList();
    return candidate;
  }

  Future<void> _election(int candidateNumber) async {
    var elector = (await Api().submit('exit_poll', {'candidateNumber': candidateNumber}));
    _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ ${elector.toString()}');
  }

  _handleClickCandidate(Candidate candidate) {
    _election(candidate.number);
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText1),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: OutlinedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            ResultPage.routeName,
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.purple,
        ),
        child: Text(
          'ดูผล',
          style: Theme.of(context).textTheme.bodyText2
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  'assets/images/vote_hand.png',
                  width: 70.0,
                  height: 70.0,
                  //fit: BoxFit.cover,
                ),
              ),
              Text(
                'EXIT POLL',
                style: Theme.of(context).textTheme.bodyText2
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'เลือกตั้ง อบต.',
                  style: Theme.of(context).textTheme.headline1
                ),
              ),
              Text(
                'รายชื่อผู้สมัครรับเลือกตั้ง',
                style: Theme.of(context).textTheme.bodyText2
              ),
              Text(
                'นายกองค์การบริหารส่วนตำบลเขาพระ',
                style: Theme.of(context).textTheme.bodyText2
              ),
              Text(
                'อำเภอเมืองนครนายก จังหวัดนครนายก',
                style: Theme.of(context).textTheme.bodyText2
              ),
              _buildCandidate(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCandidate(BuildContext context) {
    return FutureBuilder<List<Candidate>>(
      future: _futureCandidate,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var candidateList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: candidateList!.length,
            itemBuilder: (BuildContext context, int index) {
              var candidate = candidateList[index];

              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(8.0),
                elevation: 5.0,
                shadowColor: Colors.black.withOpacity(0.2),
                color: Colors.white.withOpacity(0.5),
                child: InkWell(
                  onTap: () => _handleClickCandidate(candidate),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${candidate.number}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            candidate.displayName,
                            style: Theme.of(context).textTheme.bodyText1
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureCandidate = _loadCandidates();
                    });
                  },
                  child: const Text('ลองใหม่'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
