import 'package:election_exit_poll_620710117/models/candidate.dart';
import 'package:election_exit_poll_620710117/services/api.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/result_page';
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  late Future<List<Candidate>> _futureCandidate;

  @override
  void initState() {
    super.initState();
    _futureCandidate = _loadCandidates();
  }

  Future<List<Candidate>> _loadCandidates() async {
    List list = await Api().fetch('exit_poll/result');
    var candidate = list.map((item) => Candidate.fromJson2(item)).toList();
    return candidate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'RESULT',
                    style: Theme.of(context).textTheme.headline1
                ),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            candidate.displayName,
                            style: Theme.of(context).textTheme.bodyText1
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        candidate.score.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
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
