package group48.enterprice.utilities;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.eclipse.jdt.core.compiler.InvalidInputException;

public class UserDataValidator extends Validator {

    public void validateData(String fullname) {

    }

    public boolean fullnameIsValid(String fullname) throws InvalidInputException {
        if (lengthIsValid(fullname, 3, 40)) {
            if(!containsNumber(fullname) && containsNoSpecialCharacters(fullname)) {
                return true;
            } else {
                throw new InvalidInputException("Please insert a valid fullname (neither special characters nor numbers are allowed).");
            }
        } else {
            throw new InvalidInputException("Please insert a valid fullname (longer than 3 characters).");
        }
    }

    public boolean emailIsValid(String email, int upperLimit) throws InvalidInputException {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\."+
            "[a-zA-Z0-9_+&*-]+)*@" +
            "(?:[a-zA-Z0-9-]+\\.)+[a-z" +
            "A-Z]{2,7}$";

        Pattern pat = Pattern.compile(emailRegex);
        if (pat.matcher(email).matches()) {
            if(email.length() <= upperLimit) {
                return true;
            } else {
                throw new InvalidInputException("Please insert a shorter email (max. 45)");
            }
        } else {
            throw new InvalidInputException("Wrong format: email must look like example@domain.org");
        }
    }

    public boolean countryIsValid(String country) throws InvalidInputException {
        String[] locales = Locale.getISOCountries();
        for (String countryCode : locales) {

            Locale localeObject = new Locale("", countryCode);

            if(localeObject.getDisplayCountry().equals(country)) {
                return true;
            }

        }

        //this can only happen in case the user intervenes in the HTML source code (inspect) and changes the input type.
        throw new InvalidInputException(country + " country does not exist! Please select a country from the given list!");

    }

    public boolean cityIsValid(String city) throws InvalidInputException {
        if(containsNoSpecialCharacters(city)) {
            if(lengthIsValid(city, 1, 60) && !containsNumber(city)) {
                return true;
            } else {
                throw new InvalidInputException ("Please insert a valid city name! (Numbers are not allowed)");
            }
        } else {
            throw new InvalidInputException ("Please insert a valid city name! (Special characters are not allowed)");
        }
    }

    public boolean addressIsValid(String address, int upperLimit) throws InvalidInputException {
        if(containsNoSpecialCharacters(address)) {
            Pattern p = Pattern.compile("(([a-zA-Zα-ωΑ-Ω].*[0-9])|([0-9].*[a-zA-Zα-ωΑ-Ω]))"); //contains at least one number and one letter
            Matcher matcher = p.matcher(address);
            if (matcher.find() && address.length() <= upperLimit) {
                if(checkForValidAddressFormat(address)) {
                    return true;
                } else {
                    throw new InvalidInputException("Please insert a valid address (e.g. \"Street 123\" or \"123 Street\"). ");
                }
            } else {
                throw new InvalidInputException("Please insert an address that contains at least one number & digit (max. 100 characters).");
            }
        } else {
            throw new InvalidInputException("Please insert a valid address (special characters are not allowed).");
        }
    }

    public boolean zipIsValid(String zip, int upperLimit) throws InvalidInputException {
        if (zip.matches("[0-9]+") && zip.length() <= upperLimit) {
            return true;
        } else {
            throw new InvalidInputException("Zip number can only contain digits! (max. 5 digits)");
        }
    }

    public boolean ibanIsValid(String iban) throws InvalidInputException {
        if(iban.matches("[0-9]+") && lengthIsValid(iban, 12, 30)) {
            return true;
        } else {
            throw new InvalidInputException("Please insert a valid iban (12-30 digits allowed)");
        }
    }

    public boolean websiteIsValid(String website, int upperLimit) throws Exception {
        if (website.length() <= upperLimit) {
            try {
                URL url = new URL(website);
                HttpURLConnection huc = (HttpURLConnection) url.openConnection();
                int responseCode = huc.getResponseCode();
                if(HttpURLConnection.HTTP_OK == responseCode) {
                    return true;
                }
                return false;
            } catch(Exception e) {
                throw new Exception("Cannot find this website");
            }
        } else {
            throw new InvalidInputException("Website is too long! (max. 100 characters)");
        }
    }

}
