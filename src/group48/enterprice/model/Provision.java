package group48.enterprice.model;

import java.io.Serializable;

@SuppressWarnings("serial")
public class Provision implements Serializable {
    private Product product;
    private Store store;
    private double price;

    public Provision(Product product, Store store, double price) {
        this.product = product;
        this.store = store;
        this.price = price;
    }

    public boolean equals(Provision otherProvision) {
        return ((this.product.equals(otherProvision.getProduct()))
            && this.store.equals(otherProvision.getStore())
            && this.price == otherProvision.getPrice());
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

}
