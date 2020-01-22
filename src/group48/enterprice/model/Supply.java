package group48.enterprice.model;

import java.io.Serializable;

@SuppressWarnings("serial")
public class Supply implements Comparable<Supply> , Serializable {
    private Provision provision;
    private int stock;

    public Supply(Provision provision, int stock) {
        this.provision = provision;
        this.stock = stock;
    }

    @Override
    public int compareTo(Supply otherSupply) {
        String thisProductName = this.getProvision().getProduct().getProductName();
        String otherProductName = otherSupply.getProvision().getProduct().getProductName();
        return thisProductName.compareTo(otherProductName);
    }

    public Provision getProvision() {
        return provision;
    }

    public void setProvision(Provision provision) {
        this.provision = provision;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    @Override
    public String toString() {
        return provision.getProduct() + " " + provision.getStore() + " " + provision.getPrice();
    }

}
