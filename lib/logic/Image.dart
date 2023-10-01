class Image {
  final String reference; // Reference to the image (e.g., filename, URL)
  final DateTime
      timestamp; // Timestamp indicating when the image was created or captured

  Image({
    required this.reference,
    required this.timestamp,
  });
}
