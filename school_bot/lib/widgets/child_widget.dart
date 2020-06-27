import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_bot/models/http_exception.dart';
import 'package:school_bot/providers/auth.dart';

class ChildCard extends StatefulWidget {
  final ChildData _childData;

  ChildCard(this._childData);
  @override
  _ChildCardState createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  DateTime _attendanceDate = null;
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  String status = "";
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Retry'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _checkAttendance() async {
    setState(() {
      _isLoading = true;
    });
    try {
      status = await Provider.of<Auth>(context, listen: false)
          .checkAttendance(1, 1, 2019, 97);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0),
              Theme.of(context).primaryColor.withOpacity(0.2),
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 0.3, 0.8],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ClipRRect(
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(10),
            //     topRight: Radius.circular(10),
            //   ),
            //   child: Container(
            //     alignment: Alignment.center,
            //     color: Theme.of(context).primaryColor,
            //     width: double.infinity,
            //     height: 50,
            //     child: Image.asset(
            //       'assets/images/elogo_trans.png',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Name : ${widget._childData.name}",
                        style: Theme.of(context).textTheme.display1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Class : ${widget._childData.classId}th",
                        style: Theme.of(context).textTheme.display1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Email : ${widget._childData.email}",
                        style: Theme.of(context).textTheme.display1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Birthday : ${widget._childData.birthday}",
                        style: Theme.of(context).textTheme.display1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.all(
                    //   Radius.circular(10),
                    // ),
                    border: Border.all(
                        width: 2, color: Theme.of(context).primaryColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    child: FadeInImage(
                        placeholder: AssetImage("assets/images/profileO.png"),
                        image: NetworkImage("${widget._childData.imageUrl}")),
                  ),
                ),
              ],
            ),
            // Center(
            //   child: RaisedButton(
            //     elevation: 0,
            //     child: Text(
            //       'View',
            //       style: Theme.of(context)
            //           .textTheme
            //           .subtitle
            //           .copyWith(color: Colors.white, fontSize: 18),
            //     ),
            //     onPressed: () {
            //       // Navigator.of(context).pushNamed(
            //       //     SingleChildScreen.routeName,
            //       //     arguments: item);
            //     },
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            //     color: Theme.of(context).primaryColorDark,
            //     textColor: Theme.of(context).primaryTextTheme.button.color,
            //   ),
            // ),
            Divider(
              height: 10,
            ),
            Text(
              'Attendance History',
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Colors.grey[800], fontSize: 20),
            ),
            _isLoading
                ? CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                : Form(
                    key: _form,
                    child: DateTimeField(
                      initialValue: _attendanceDate,
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        labelText: 'Attendance Date',
                        labelStyle: TextStyle(
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.today,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      format: DateFormat('dd MMM yyy'),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime.now(),
                        );
                      },
                      onChanged: (value) {
                        // _checkAttendance();
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Select a Date Of Birth';
                        }
                        return null;
                      },
                    ),
                  ),
            Text(
              status,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Colors.grey[800], fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
