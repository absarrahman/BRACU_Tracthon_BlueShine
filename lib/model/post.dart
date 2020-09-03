class PostModel {
  var _title, _report, _uId;
  bool _isVerified = false, _isSolved = false;

  PostModel(this._title, this._report, this._uId);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> m = Map<String, dynamic>();
    m["title"] = _title;
    m["report"] = _report;
    m["verified"] = _isVerified;
    m["time"] = DateTime.now().toString();
    m["uid"] = _uId;
    m["solved"] = _isSolved;
    return m;
  }
}
