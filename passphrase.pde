// Core functionality:
// We have list of number to word mappings
// Generate a word:
//   Roll Five Dice (d6)
//   Combine the dice roll results into a 5-digit number
//   Use that number to look up the word
//   Record the word
// Keep generating words

// Side quests:
//   Add as many words as we like
//   Displaying words (keeping things on the screen)
//   Alter the words 
//     capitalize
//     all caps
//     substitutions (zero for the letter 'o', etc.)
//     add numbers or special characters 
//   Delete words
//   copy-paste?
//   More efficient data structure to hold the words
//   Base 6 encoding

ArrayList<String> words = new ArrayList<String>();
HashMap<Integer, String> wordMap = new HashMap<Integer, String>();
String currentWord = "";
String displayText = "";
boolean caps = false;
boolean allCaps = false;
boolean substitutions = false;

void setup() { 
  size(1000, 800);
  textSize(32);
  textAlign(CENTER, CENTER);
  
  // Load word list
  String[] lines = loadStrings("eff_large_wordlist.txt");
  for (String line : lines) {
    String[] results = line.split("\t");
    if (results.length == 2) {
      int key = int(results[0]);
      wordMap.put(key, results[1]);
    }
  }
}

// Generate words
String randomWord() {
  String code = "";
  for (int i = 0; i < 5; i++) {
    code += int(random(1, 7)); // base-6 digits (1–6)
  }
  int lookup = int(code);
  if (wordMap.containsKey(lookup)) {
    String w = wordMap.get(lookup);
    return applyTransformations(w);
  } else {
    return "???";
  }
}

void draw() {
  background(240);
  fill(60);
  text(displayText, width / 2, height / 2);
}

//commands
void keyPressed() {
  if (key == ' ') {                     // add a new random word
    String newWord = randomWord();
    words.add(newWord);
    updateDisplay();
  } else if (key == BACKSPACE) {        // delete last word
    if (words.size() > 0) {
      words.remove(words.size() - 1);
      updateDisplay();
    }
  } else if (key == 'a') {              // toggle capitalize
    caps = !caps;
    updateDisplay();
  } else if (key == 's') {              // toggle all caps
    allCaps = !allCaps;
    updateDisplay();
  } else if (key == 'd') {              // toggle substitutions
    substitutions = !substitutions;
    updateDisplay();
  } else if (key == 'f') {              // clear
    words.clear();
    updateDisplay();
  } else if (key == 'g') {              // simulate copy 
    println("Copied: " + join(words.toArray(new String[0]), " "));
  }
}

void updateDisplay() {
  String out = join(words.toArray(new String[0]), " ");
  displayText = out.trim();
}

// Apply changes
String applyTransformations(String input) {
  String w = input;
  if (caps) w = capitalize(w);
  if (allCaps) w = w.toUpperCase();
  if (substitutions) {
    w = w.replace("o", "0");
    w = w.replace("i", "1");
    w = w.replace("e", "3");
    w = w.replace("a", "@");
    w = w.replace("s", "$");
  }
  return w;
}

// Capitalize first letter 
String capitalize(String s) {
  if (s.length() == 0) return s;
  return s.substring(0, 1).toUpperCase() + s.substring(1);
}
