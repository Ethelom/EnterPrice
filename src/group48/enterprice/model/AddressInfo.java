package group48.enterprice.model;

public class AddressInfo {

    private String country, city, address, zip;

    public AddressInfo(String country, String city, String address, String zip) {
        this.country = country;
        this.city = city;
        this.address = address;
        this.zip = zip;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }
}
