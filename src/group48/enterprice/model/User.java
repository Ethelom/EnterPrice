package group48.enterprice.model;

import group48.enterprice.database.UserDAO;
import group48.enterprice.exceptions.IntruderException;

public abstract class User {
    private String username, fullname, email, password, image;
    private AddressInfo adInfo;
    public static final String CUSTOMER_DEFAULT_IMAGE = "icons/navbar-user-icon.png";
    public static final String STORE_DEFAULT_IMAGE = "icons/online-store.png";

    public User() {

    }

    public User(String username, String fullname, String email, String password, AddressInfo adInfo, String image) {
        super();
        this.username = username;
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.adInfo = adInfo;
        this.image = image;
    }

    public abstract UserDAO getDAO();

    public abstract void preloadData() throws Exception;

    public abstract String getNavbarSrc();

    public abstract String getHomePageSrc();

    public abstract String getSearchBarForwardSrc();

    public abstract String getTypeOfUser();

    public abstract User castToSelf(Object x) throws IntruderException;

    public static Customer castToCustomer(Object x) throws IntruderException {
        if(x instanceof Customer) {
            return (Customer) x;
        } else {
            throw new IntruderException();
        }
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public AddressInfo getAdInfo() {
        return adInfo;
    }

    public void setAddress(AddressInfo address) {
        this.adInfo = address;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

}
