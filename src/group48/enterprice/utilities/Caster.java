package group48.enterprice.utilities;

import group48.enterprice.exceptions.IntruderException;
import group48.enterprice.model.Customer;
import group48.enterprice.model.Store;

public class Caster {

    /**
     *
     * @param obj
     * @param className represents the class that the object is supposed to be casted to. For example, cart.jsp would require user to be casted to Customer
     * @return
     * @throws IntruderException in case a type of user attempts to access a page that is not supposed to be
     * accessed by their type (e.g a Store attempts to access cart.jsp)
     * @throws IllegalArgumentException in case the method is called with @param className that is not associated to any user type
     */
    public static <T> T castObjectToTypeOfUser(Object obj, Class<T> className) throws IntruderException, IllegalArgumentException {
        if(castingRefersToUserType(className)) {
            if(castIsPermitted(obj, className)) {
                return className.cast(obj);
            } else {
                throw new IntruderException();
            }
        } else {
            throw new IllegalArgumentException("Invalid args");
        }
    }

    private static <T> boolean castingRefersToUserType(Class<T> className) {
        return (className == Customer.class || className == Store.class);
    }

    private static <T> boolean castIsPermitted(Object object, Class<T> className) {
        return className == object.getClass();
    }

}
