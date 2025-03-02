String durationToTime(Duration? dur) {
  if(dur == null) {
    return "--:--";
  }

  var minutes = "${dur.inMinutes}".padLeft(2, "0");
  var seconds = "${dur.inSeconds % 60}".padLeft(2, "0");

  return "$minutes:$seconds";
}
