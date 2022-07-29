  Color generateRandomColor() {
    // Define all colors you want here
    const predefinedColors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.brown,
      Colors.black,
      Colors.white,
    ];
    Random random = Random();
    int sayi = random.nextInt(predefinedColors.length);
    return predefinedColors[sayi];
  }
