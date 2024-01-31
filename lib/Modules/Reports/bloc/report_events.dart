abstract class ReportEvent {}

class FetchData extends ReportEvent {
  final bool load;
  FetchData({this.load = true});
}
