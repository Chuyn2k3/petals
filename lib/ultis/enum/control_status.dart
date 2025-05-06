enum ControlStatus {
  master,
  slave1,
  slave2,
  slave3;

  String get display {
    switch (this) {
      case ControlStatus.master:
        return "Master";
      case ControlStatus.slave1:
        return "Slave 1";
      case ControlStatus.slave2:
        return "Slave 2";
      case ControlStatus.slave3:
        return "Slave 3";
      default:
        return "";
    }
  }

   int get value => index;
}
