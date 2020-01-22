package group48.enterprice.utilities;

public abstract class Validator {

    public Validator() {

    }

    //lower and upper limit inclusive
    public boolean lengthIsValid(String checkString, int lowerLimit, int upperLimit) {
        return (checkString.length() >= lowerLimit && checkString.length() <= upperLimit);
    }

    public boolean containsNumber(String checkString) {
        return checkString.matches(".*\\d.*");
    }

    public boolean containsNoSpecialCharacters(String checkString) {
        return checkString.replace(" ", "").matches("[a-zA-Zα-ωΑ-Ω0-9'άέίόώύήΆΈΊΌΏΎΉς]*");
    }

    public boolean containsLatinCharacter(String checkString) {
        return checkString.replace(" ", " ").matches("[a-zA-Z]*");
    }

    public boolean checkForValidAddressFormat(String s) {
        if(s.trim().contains(" ")) {
            String[] parts = s.split(" ");
            String[] types = new String[parts.length];
            int counter = 0;
            for(String part : parts) {
                //check if omoeidh
                if(!(part.matches("[0-9]+") || !part.matches(".*\\d.*"))) {
                    return false; //px (44j)
                } else if (part.matches("[0-9]+")) {
                    types[counter] = "numbers";
                } else {
                    types[counter] = "letters";
                }
                counter++;
            }
            int changeCounter = 0;
            for(int i = 0; i < types.length-1; i++) {
                String current = types[i];
                String next = types[i + 1];
                if(!current.equals(next)) {
                    changeCounter++;
                    if(changeCounter > 1) {
                        return false;
                    }
                } else if (current.equals("numbers")) {
                    return false;
                }
            }
            return true;
        } else {
            return false;
        }
    }

}
