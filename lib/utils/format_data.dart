String formatName(String name, int length) {
  if (name.length > length) {
    return '${name.substring(0, length)}.....';
  }
  return name;
}

String formatDuration(Duration? duration) {
  if (duration != null) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  return "0:00";
}
