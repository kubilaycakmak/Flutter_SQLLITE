class Note{
  int _id;
  String _title;
  String _description;
  String _date;

  Note(this._title, this._date, [this._description]);
  Note.withId(this._id ,this._title, this._date, [this._description]);

  String get date => _date;

  set date(String value) {
    this._date = value;
  }

  String get description => _description;

  set description(String value) {
    if(value.length <= 255){
      this._description = value;
    }
  }

  String get title => _title;

  set title(String value) {
    if(value.length <= 255){
      this._title = value;
    }
  }

  int get id => _id;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(id!=null){
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic>map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
  }

}