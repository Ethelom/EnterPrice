package group48.enterprice.utilities;

import org.eclipse.jdt.core.compiler.InvalidInputException;

public class PasswordValidator extends Validator {

    private String password;

    public PasswordValidator(String password) {
        super();
        this.password = password;
    }

    public boolean passwordIsValid() throws InvalidInputException {
        if(lengthIsValid(password, 5, 25)) {
            return true;
        } else {
            throw new InvalidInputException("Please insert a longer password! (5-25 characters long)");
        }
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
