package group48.enterprice.exceptions;

import java.io.Serializable;

@SuppressWarnings("serial")
public class IntruderException extends ClassCastException implements Serializable {

    private String message;

    public IntruderException() {

    }

    public IntruderException(String message) {
        this.message= message;
    }

    @Override
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
