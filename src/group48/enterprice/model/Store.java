package group48.enterprice.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import group48.enterprice.database.StoreDAO;
import group48.enterprice.database.UserDAO;
import group48.enterprice.exceptions.IntruderException;

@SuppressWarnings("serial")
public class Store extends User implements Serializable {
    private String website, accountNumber, storeName;
    private List<Supply> products;

    public Store(String username, String ownerName, String storeName, String email, String password,
        AddressInfo adInfo, String image, String website, String accountNumber) {
        super(username, ownerName, email, password, adInfo, image);
        this.storeName = storeName;
        this.website = website;
        this.accountNumber = accountNumber;
        this.products = new ArrayList<Supply>();
    }

    public boolean equals(Store otherStore) {
        return this.storeName.equals(otherStore.getStoreName())
            && this.getUsername().equals(otherStore.getUsername());
    }

    public Supply findProductInfo(String productName) {
        Supply returnedSupply = null;
        for(Supply supply : products) {
            if(supply.getProvision().getProduct().getProductName().equals(productName)) {
                returnedSupply = supply;
                break;
            }
        }
        return returnedSupply;
    }

    public void updateProductInformation(Supply newSupply) {
        Product editedProduct = newSupply.getProvision().getProduct();
        int counter = 0;
        int indexOfEdited = -1;
        for(Supply supply : products) {
            Product examinedProduct = supply.getProvision().getProduct();
            if(editedProduct.equals(examinedProduct)) {
                indexOfEdited = counter;
                break;
            }
            counter++;
        }
        if(indexOfEdited != -1) {
            products.set(indexOfEdited, newSupply);
        }
    }

    public void deleteProduct(String productName) {
        for(Supply item : products) {
            if(item.getProvision().getProduct().getProductName().equals(productName)) {
                products.remove(item);
                break;
            }
        }
    }

    @Override
    public UserDAO getDAO() {
        return new StoreDAO(this);
    }

    @Override
    public String getNavbarSrc() {
        return "navbarStore.jsp";
    }

    @Override
    public String getHomePageSrc() {
        return "homePageStore.jsp";
    }

    @Override
    public String getSearchBarForwardSrc() {
        // TODO Auto-generated method stub
        return "editProduct.jsp";
    }

    @Override
    public void preloadData() throws Exception {
        products = new StoreDAO(this).findProductsThatStoreSells();
    }

    public String getOwnerName() {
        return super.getFullname();
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public List<Supply> getProducts() {
        return products;
    }

    public void setProducts(List<Supply> products) {
        this.products = products;
    }

    @Override
    public String getTypeOfUser() {
        return "store";
    }

    @Override
    public Store castToSelf(Object x) throws IntruderException {
        try {
            return (Store) x;
        } catch(ClassCastException e) {
            throw new IntruderException();
        }
    }
}
